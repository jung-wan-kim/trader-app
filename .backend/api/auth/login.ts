import { createClient } from '@supabase/supabase-js'
import { Request, Response } from 'express'
import jwt from 'jsonwebtoken'

/**
 * 로그인 API
 * POST /api/auth/login
 * 
 * @body {
 *   email: string,
 *   password: string
 * }
 */
export async function login(req: Request, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { email, password } = req.body

    // Supabase Auth로 로그인
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email,
      password
    })

    if (authError) {
      return res.status(401).json({ error: '이메일 또는 비밀번호가 잘못되었습니다.' })
    }

    // 사용자 정보 조회
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('id', authData.user.id)
      .single()

    if (userError || !userData) {
      return res.status(404).json({ error: '사용자 정보를 찾을 수 없습니다.' })
    }

    // 마지막 로그인 시간 업데이트
    await supabase
      .from('users')
      .update({ last_login_at: new Date().toISOString() })
      .eq('id', userData.id)

    // JWT 토큰 생성
    const token = jwt.sign(
      { 
        id: userData.id, 
        email: userData.email,
        subscription_type: userData.subscription_type 
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    )

    // 리프레시 토큰 저장
    await supabase
      .from('refresh_tokens')
      .insert({
        user_id: userData.id,
        token: authData.session.refresh_token,
        expires_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString() // 30일
      })

    res.json({
      user: {
        id: userData.id,
        email: userData.email,
        name: userData.name,
        subscription_type: userData.subscription_type,
        is_verified: userData.is_verified
      },
      token,
      refresh_token: authData.session.refresh_token
    })

  } catch (error) {
    console.error('Login error:', error)
    res.status(500).json({ error: '로그인 중 오류가 발생했습니다.' })
  }
}