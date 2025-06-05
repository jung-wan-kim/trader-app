import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

interface NotificationRequest {
  type: 'recommendation' | 'position_alert' | 'market_update' | 'subscription' | 'custom'
  user_ids?: string[]
  strategy_id?: string
  data: Record<string, any>
}

/**
 * 알림 발송 Edge Function
 * 
 * 다양한 종류의 알림을 처리하는 중앙 함수
 */
serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const payload: NotificationRequest = await req.json()
    const { type, user_ids, strategy_id, data } = payload

    let targetUsers: string[] = []

    // 대상 사용자 결정
    if (user_ids && user_ids.length > 0) {
      targetUsers = user_ids
    } else if (strategy_id) {
      // 전략 구독자 조회
      const { data: subscribers } = await supabase
        .from('strategy_subscriptions')
        .select('user_id')
        .eq('strategy_id', strategy_id)
        .eq('is_active', true)

      targetUsers = subscribers?.map(s => s.user_id) || []
    }

    if (targetUsers.length === 0) {
      return new Response(
        JSON.stringify({ error: 'No target users found' }),
        { 
          status: 400,
          headers: { 'Content-Type': 'application/json' } 
        }
      )
    }

    // 사용자 정보 및 설정 조회
    const { data: users } = await supabase
      .from('users')
      .select('id, email, notification_preferences, subscription_type, device_tokens')
      .in('id', targetUsers)

    const notifications = []
    const emailQueue = []
    const pushNotifications = []

    // 알림 타입별 처리
    for (const user of users || []) {
      const prefs = user.notification_preferences || {}
      
      // 구독 레벨별 알림 제한 확인
      if (!canReceiveNotification(type, user.subscription_type)) {
        continue
      }

      // 알림 콘텐츠 생성
      const content = generateNotificationContent(type, data, user)

      // 인앱 알림 (항상 생성)
      notifications.push({
        user_id: user.id,
        type,
        title: content.title,
        body: content.body,
        data: content.data,
        is_read: false,
        created_at: new Date().toISOString()
      })

      // 푸시 알림
      if (prefs.push_enabled && user.device_tokens?.length > 0) {
        for (const token of user.device_tokens) {
          pushNotifications.push({
            user_id: user.id,
            device_token: token,
            title: content.title,
            body: content.body,
            data: content.data,
            platform: token.platform || 'ios'
          })
        }
      }

      // 이메일 알림
      if (prefs.email_enabled && shouldSendEmail(type, prefs)) {
        emailQueue.push({
          to: user.email,
          subject: content.title,
          template: getEmailTemplate(type),
          data: {
            user_name: user.name || 'Trader',
            ...content.data
          },
          scheduled_at: new Date().toISOString()
        })
      }
    }

    // 알림 저장
    if (notifications.length > 0) {
      await supabase.from('notifications').insert(notifications)
    }

    // 푸시 알림 발송
    if (pushNotifications.length > 0) {
      await sendPushNotifications(pushNotifications)
    }

    // 이메일 큐에 추가
    if (emailQueue.length > 0) {
      await supabase.from('email_queue').insert(emailQueue)
    }

    // 알림 통계 업데이트
    await updateNotificationStats(supabase, type, notifications.length)

    return new Response(
      JSON.stringify({ 
        success: true,
        notifications_sent: {
          in_app: notifications.length,
          push: pushNotifications.length,
          email: emailQueue.length
        }
      }),
      { headers: { 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 500,
        headers: { 'Content-Type': 'application/json' } 
      }
    )
  }
})

/**
 * 구독 레벨별 알림 수신 가능 여부
 */
function canReceiveNotification(type: string, subscriptionType: string): boolean {
  const restrictions = {
    recommendation: ['basic', 'premium', 'vip'],
    position_alert: ['basic', 'premium', 'vip'],
    market_update: ['premium', 'vip'],
    subscription: ['free', 'basic', 'premium', 'vip'],
    custom: ['vip']
  }

  return restrictions[type]?.includes(subscriptionType) || false
}

/**
 * 알림 콘텐츠 생성
 */
function generateNotificationContent(type: string, data: any, user: any) {
  const templates = {
    recommendation: {
      title: '새로운 AI 추천',
      body: `${data.ticker} ${data.action} 추천 (신뢰도: ${data.confidence_score}%)`,
      data: {
        recommendation_id: data.id,
        ticker: data.ticker,
        action: data.action,
        entry_price: data.entry_price,
        target_price: data.target_price
      }
    },
    position_alert: {
      title: data.alert_type === 'stop_loss' ? '손절 실행' : '익절 실행',
      body: `${data.ticker} 포지션이 ${data.alert_type === 'stop_loss' ? '손절' : '익절'}되었습니다.`,
      data: {
        position_id: data.position_id,
        ticker: data.ticker,
        pnl: data.pnl,
        pnl_percentage: data.pnl_percentage
      }
    },
    market_update: {
      title: '시장 업데이트',
      body: data.summary || '중요한 시장 변동이 감지되었습니다.',
      data: {
        market_data: data.market_data,
        sectors: data.sectors
      }
    },
    subscription: {
      title: '구독 알림',
      body: data.message || '구독 상태가 변경되었습니다.',
      data: {
        plan: data.plan,
        action: data.action
      }
    },
    custom: {
      title: data.title || '알림',
      body: data.body || '',
      data: data.custom_data || {}
    }
  }

  return templates[type] || templates.custom
}

/**
 * 이메일 발송 여부 결정
 */
function shouldSendEmail(type: string, preferences: any): boolean {
  const emailTypes = preferences.email_types || []
  
  // 기본적으로 중요한 알림만 이메일로 발송
  const importantTypes = ['position_alert', 'subscription']
  
  if (importantTypes.includes(type)) {
    return true
  }

  return emailTypes.includes(type)
}

/**
 * 이메일 템플릿 선택
 */
function getEmailTemplate(type: string): string {
  const templates = {
    recommendation: 'recommendation',
    position_alert: 'position_alert',
    market_update: 'market_update',
    subscription: 'subscription_change',
    custom: 'general'
  }

  return templates[type] || 'general'
}

/**
 * 푸시 알림 발송
 */
async function sendPushNotifications(notifications: any[]) {
  // 실제로는 FCM, APNS 등을 사용
  // 여기서는 시뮬레이션
  
  const fcmTokens = notifications.filter(n => n.platform === 'android').map(n => n.device_token)
  const apnsTokens = notifications.filter(n => n.platform === 'ios').map(n => n.device_token)

  // FCM 발송
  if (fcmTokens.length > 0) {
    // await sendToFCM(fcmTokens, notifications[0])
    console.log(`Sending ${fcmTokens.length} FCM notifications`)
  }

  // APNS 발송
  if (apnsTokens.length > 0) {
    // await sendToAPNS(apnsTokens, notifications[0])
    console.log(`Sending ${apnsTokens.length} APNS notifications`)
  }
}

/**
 * 알림 통계 업데이트
 */
async function updateNotificationStats(supabase: any, type: string, count: number) {
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  await supabase.rpc('increment_notification_stats', {
    stat_date: today.toISOString(),
    notification_type: type,
    increment_count: count
  })
}