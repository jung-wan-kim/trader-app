import { createClient } from '@supabase/supabase-js'
import { Request, Response } from 'express'
import jwt from 'jsonwebtoken'

/**
 * 토큰 갱신 API
 * POST /api/auth/refresh
 * 
 * @body {
 *   refresh_token: string
 * }
 */
export async function refreshToken(req: Request, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { refresh_token } = req.body

    // 리프레시 토큰 검증
    const { data: tokenData, error: tokenError } = await supabase
      .from('refresh_tokens')
      .select('*, users(*)')
      .eq('token', refresh_token)
      .gte('expires_at', new Date().toISOString())
      .single()

    if (tokenError || !tokenData) {
      return res.status(401).json({ error: '유효하지 않은 리프레시 토큰입니다.' })
    }

    // Supabase Auth 세션 갱신
    const { data: authData, error: authError } = await supabase.auth.refreshSession({
      refresh_token
    })

    if (authError) {
      return res.status(401).json({ error: '세션 갱신에 실패했습니다.' })
    }

    // 새로운 JWT 토큰 생성
    const newToken = jwt.sign(
      { 
        id: tokenData.users.id, 
        email: tokenData.users.email,
        subscription_type: tokenData.users.subscription_type 
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    )

    // 기존 리프레시 토큰 삭제
    await supabase
      .from('refresh_tokens')
      .delete()
      .eq('token', refresh_token)

    // 새로운 리프레시 토큰 저장
    await supabase
      .from('refresh_tokens')
      .insert({
        user_id: tokenData.users.id,
        token: authData.session.refresh_token,
        expires_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString()
      })

    res.json({
      token: newToken,
      refresh_token: authData.session.refresh_token
    })

  } catch (error) {
    console.error('Token refresh error:', error)
    res.status(500).json({ error: '토큰 갱신 중 오류가 발생했습니다.' })
  }
}