import { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'
import { createClient } from '@supabase/supabase-js'

interface AuthRequest extends Request {
  user?: {
    id: string
    email: string
    subscription_type: string
  }
}

/**
 * JWT 인증 미들웨어
 */
export async function authenticate(
  req: AuthRequest, 
  res: Response, 
  next: NextFunction
) {
  try {
    const authHeader = req.headers.authorization
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: '인증 토큰이 필요합니다.' })
    }

    const token = authHeader.substring(7)
    
    // JWT 검증
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as {
      id: string
      email: string
      subscription_type: string
    }

    // 사용자 정보를 request에 추가
    req.user = decoded
    next()

  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      return res.status(401).json({ error: '토큰이 만료되었습니다.' })
    }
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({ error: '유효하지 않은 토큰입니다.' })
    }
    return res.status(500).json({ error: '인증 처리 중 오류가 발생했습니다.' })
  }
}

/**
 * 구독 레벨 확인 미들웨어
 */
export function requireSubscription(
  requiredLevels: ('free' | 'basic' | 'premium' | 'vip')[]
) {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({ error: '인증이 필요합니다.' })
    }

    if (!requiredLevels.includes(req.user.subscription_type as any)) {
      return res.status(403).json({ 
        error: '이 기능을 사용하려면 더 높은 구독 레벨이 필요합니다.',
        required_levels: requiredLevels,
        current_level: req.user.subscription_type
      })
    }

    next()
  }
}

/**
 * API 사용량 제한 미들웨어
 */
export async function rateLimit(
  req: AuthRequest, 
  res: Response, 
  next: NextFunction
) {
  if (!req.user) {
    return res.status(401).json({ error: '인증이 필요합니다.' })
  }

  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  // 구독 레벨별 API 제한
  const limits = {
    free: 100,      // 일 100회
    basic: 1000,    // 일 1000회
    premium: 5000,  // 일 5000회
    vip: -1         // 무제한
  }

  const userLimit = limits[req.user.subscription_type as keyof typeof limits]
  
  if (userLimit === -1) {
    return next() // VIP는 무제한
  }

  // 오늘의 API 사용량 확인
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const { data: usage, error } = await supabase
    .from('api_usage')
    .select('count')
    .eq('user_id', req.user.id)
    .gte('created_at', today.toISOString())
    .single()

  if (error && error.code !== 'PGRST116') { // 데이터가 없는 경우가 아닌 에러
    return res.status(500).json({ error: 'API 사용량 확인 중 오류가 발생했습니다.' })
  }

  const currentUsage = usage?.count || 0

  if (currentUsage >= userLimit) {
    return res.status(429).json({ 
      error: 'API 사용량 한도를 초과했습니다.',
      limit: userLimit,
      usage: currentUsage,
      reset_at: new Date(today.getTime() + 24 * 60 * 60 * 1000).toISOString()
    })
  }

  // API 사용량 기록
  await supabase
    .from('api_usage')
    .upsert({
      user_id: req.user.id,
      count: currentUsage + 1,
      created_at: new Date().toISOString()
    }, {
      onConflict: 'user_id,created_at'
    })

  next()
}