import { Request, Response } from 'express'
import { createClient } from '@supabase/supabase-js'
import Stripe from 'stripe'

interface AuthRequest extends Request {
  user?: {
    id: string
    email: string
    subscription_type: string
  }
}

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16'
})

/**
 * 구독 플랜 조회
 * GET /api/subscriptions/plans
 */
export async function getSubscriptionPlans(req: Request, res: Response) {
  const plans = [
    {
      id: 'free',
      name: '무료',
      price: 0,
      features: [
        '기본 AI 추천 5개/일',
        '1개 포트폴리오',
        '기본 차트 분석',
        '커뮤니티 접근'
      ],
      limitations: {
        daily_recommendations: 5,
        portfolios: 1,
        api_calls: 100,
        real_time_alerts: false,
        advanced_analytics: false
      }
    },
    {
      id: 'basic',
      name: '베이직',
      price: 9900,
      stripe_price_id: process.env.STRIPE_BASIC_PRICE_ID,
      features: [
        'AI 추천 20개/일',
        '3개 포트폴리오',
        '실시간 알림',
        '기술적 분석 도구',
        '이메일 지원'
      ],
      limitations: {
        daily_recommendations: 20,
        portfolios: 3,
        api_calls: 1000,
        real_time_alerts: true,
        advanced_analytics: false
      }
    },
    {
      id: 'premium',
      name: '프리미엄',
      price: 29900,
      stripe_price_id: process.env.STRIPE_PREMIUM_PRICE_ID,
      features: [
        'AI 추천 50개/일',
        '10개 포트폴리오',
        '고급 분석 도구',
        '백테스팅 기능',
        '우선 지원',
        'API 접근'
      ],
      limitations: {
        daily_recommendations: 50,
        portfolios: 10,
        api_calls: 5000,
        real_time_alerts: true,
        advanced_analytics: true,
        backtesting: true,
        api_access: true
      }
    },
    {
      id: 'vip',
      name: 'VIP',
      price: 99900,
      stripe_price_id: process.env.STRIPE_VIP_PRICE_ID,
      features: [
        '무제한 AI 추천',
        '무제한 포트폴리오',
        '1:1 전문가 상담',
        '커스텀 전략 개발',
        '전용 서버',
        'WhiteLabel 옵션'
      ],
      limitations: {
        daily_recommendations: -1,
        portfolios: -1,
        api_calls: -1,
        real_time_alerts: true,
        advanced_analytics: true,
        backtesting: true,
        api_access: true,
        dedicated_support: true,
        custom_strategies: true
      }
    }
  ]

  res.json({ plans })
}

/**
 * 구독 생성/업그레이드
 * POST /api/subscriptions/subscribe
 * 
 * @body {
 *   plan_id: 'basic' | 'premium' | 'vip',
 *   payment_method_id?: string
 * }
 */
export async function createSubscription(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { plan_id, payment_method_id } = req.body

    // 현재 구독 확인
    const { data: currentUser } = await supabase
      .from('users')
      .select('subscription_type, stripe_customer_id')
      .eq('id', req.user!.id)
      .single()

    if (currentUser?.subscription_type === plan_id) {
      return res.status(400).json({ error: '이미 해당 플랜을 구독 중입니다.' })
    }

    // Stripe 고객 생성 또는 조회
    let stripeCustomerId = currentUser?.stripe_customer_id

    if (!stripeCustomerId) {
      const customer = await stripe.customers.create({
        email: req.user!.email,
        metadata: {
          user_id: req.user!.id
        }
      })
      stripeCustomerId = customer.id

      // Stripe 고객 ID 저장
      await supabase
        .from('users')
        .update({ stripe_customer_id: stripeCustomerId })
        .eq('id', req.user!.id)
    }

    // 결제 수단 연결
    if (payment_method_id) {
      await stripe.paymentMethods.attach(payment_method_id, {
        customer: stripeCustomerId
      })

      await stripe.customers.update(stripeCustomerId, {
        invoice_settings: {
          default_payment_method: payment_method_id
        }
      })
    }

    // 가격 ID 매핑
    const priceIds = {
      basic: process.env.STRIPE_BASIC_PRICE_ID!,
      premium: process.env.STRIPE_PREMIUM_PRICE_ID!,
      vip: process.env.STRIPE_VIP_PRICE_ID!
    }

    // Stripe 구독 생성
    const subscription = await stripe.subscriptions.create({
      customer: stripeCustomerId,
      items: [{ price: priceIds[plan_id as keyof typeof priceIds] }],
      expand: ['latest_invoice.payment_intent']
    })

    // 구독 정보 저장
    const { data: subscriptionData, error: subscriptionError } = await supabase
      .from('subscriptions')
      .insert({
        user_id: req.user!.id,
        plan_id,
        stripe_subscription_id: subscription.id,
        status: subscription.status,
        current_period_start: new Date(subscription.current_period_start * 1000).toISOString(),
        current_period_end: new Date(subscription.current_period_end * 1000).toISOString()
      })
      .select()
      .single()

    if (subscriptionError) {
      // Stripe 구독 취소 (롤백)
      await stripe.subscriptions.cancel(subscription.id)
      throw subscriptionError
    }

    // 사용자 구독 레벨 업데이트
    await supabase
      .from('users')
      .update({ 
        subscription_type: plan_id,
        subscription_updated_at: new Date().toISOString()
      })
      .eq('id', req.user!.id)

    // 구독 변경 이벤트 기록
    await supabase
      .from('subscription_events')
      .insert({
        user_id: req.user!.id,
        event_type: 'subscription_created',
        from_plan: currentUser?.subscription_type || 'free',
        to_plan: plan_id,
        metadata: { stripe_subscription_id: subscription.id }
      })

    res.status(201).json({
      subscription: subscriptionData,
      payment_intent: (subscription.latest_invoice as any)?.payment_intent
    })

  } catch (error) {
    console.error('Create subscription error:', error)
    res.status(500).json({ error: '구독 생성 중 오류가 발생했습니다.' })
  }
}

/**
 * 구독 취소
 * POST /api/subscriptions/cancel
 */
export async function cancelSubscription(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    // 현재 구독 조회
    const { data: subscription, error: subError } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('user_id', req.user!.id)
      .eq('status', 'active')
      .single()

    if (subError || !subscription) {
      return res.status(404).json({ error: '활성 구독을 찾을 수 없습니다.' })
    }

    // Stripe 구독 취소 (기간 종료 시)
    const canceledSubscription = await stripe.subscriptions.update(
      subscription.stripe_subscription_id,
      {
        cancel_at_period_end: true
      }
    )

    // 구독 상태 업데이트
    await supabase
      .from('subscriptions')
      .update({
        status: 'canceling',
        cancel_at: new Date(canceledSubscription.cancel_at! * 1000).toISOString()
      })
      .eq('id', subscription.id)

    // 취소 이벤트 기록
    await supabase
      .from('subscription_events')
      .insert({
        user_id: req.user!.id,
        event_type: 'subscription_canceled',
        from_plan: subscription.plan_id,
        to_plan: 'free',
        metadata: { 
          cancel_at: new Date(canceledSubscription.cancel_at! * 1000).toISOString() 
        }
      })

    res.json({
      message: '구독이 취소되었습니다. 현재 결제 기간이 끝나면 무료 플랜으로 전환됩니다.',
      cancel_at: new Date(canceledSubscription.cancel_at! * 1000).toISOString()
    })

  } catch (error) {
    console.error('Cancel subscription error:', error)
    res.status(500).json({ error: '구독 취소 중 오류가 발생했습니다.' })
  }
}

/**
 * 구독 내역 조회
 * GET /api/subscriptions/history
 */
export async function getSubscriptionHistory(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    // 구독 이력 조회
    const { data: history, error } = await supabase
      .from('subscription_events')
      .select('*')
      .eq('user_id', req.user!.id)
      .order('created_at', { ascending: false })

    if (error) {
      throw error
    }

    // 결제 내역 조회 (Stripe)
    const { data: user } = await supabase
      .from('users')
      .select('stripe_customer_id')
      .eq('id', req.user!.id)
      .single()

    let invoices = []
    if (user?.stripe_customer_id) {
      const stripeInvoices = await stripe.invoices.list({
        customer: user.stripe_customer_id,
        limit: 10
      })

      invoices = stripeInvoices.data.map(invoice => ({
        id: invoice.id,
        amount: invoice.amount_paid,
        currency: invoice.currency,
        status: invoice.status,
        period_start: new Date(invoice.period_start * 1000).toISOString(),
        period_end: new Date(invoice.period_end * 1000).toISOString(),
        invoice_pdf: invoice.invoice_pdf
      }))
    }

    res.json({
      events: history,
      invoices
    })

  } catch (error) {
    console.error('Get subscription history error:', error)
    res.status(500).json({ error: '구독 내역 조회 중 오류가 발생했습니다.' })
  }
}