import { createClient } from '@supabase/supabase-js'
import { Request, Response } from 'express'
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

/**
 * 회원가입 API
 * POST /api/auth/register
 * 
 * @body {
 *   email: string,
 *   password: string,
 *   name: string,
 *   phone?: string,
 *   subscription_type?: 'free' | 'basic' | 'premium' | 'vip'
 * }
 */
export async function register(req: Request, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { email, password, name, phone, subscription_type = 'free' } = req.body

    // 이메일 중복 체크
    const { data: existingUser } = await supabase
      .from('users')
      .select('id')
      .eq('email', email)
      .single()

    if (existingUser) {
      return res.status(400).json({ error: '이미 등록된 이메일입니다.' })
    }

    // 비밀번호 해시화
    const hashedPassword = await bcrypt.hash(password, 10)

    // Supabase Auth 사용자 생성
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true
    })

    if (authError) {
      throw authError
    }

    // 사용자 프로필 생성
    const { data: userData, error: userError } = await supabase
      .from('users')
      .insert({
        id: authData.user.id,
        email,
        name,
        phone,
        subscription_type,
        created_at: new Date().toISOString()
      })
      .select()
      .single()

    if (userError) {
      // Auth 사용자 삭제 (롤백)
      await supabase.auth.admin.deleteUser(authData.user.id)
      throw userError
    }

    // 초기 포트폴리오 생성
    await supabase
      .from('portfolios')
      .insert({
        user_id: userData.id,
        name: '내 포트폴리오',
        initial_capital: 0,
        current_value: 0,
        is_primary: true
      })

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

    res.status(201).json({
      user: {
        id: userData.id,
        email: userData.email,
        name: userData.name,
        subscription_type: userData.subscription_type
      },
      token
    })

  } catch (error) {
    console.error('Registration error:', error)
    res.status(500).json({ error: '회원가입 중 오류가 발생했습니다.' })
  }
}