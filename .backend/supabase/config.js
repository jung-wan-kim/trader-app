// Supabase 설정
export const supabaseConfig = {
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key',
  serviceKey: 'your-service-key' // 서버 사이드에서만 사용
};

// 개발 환경 설정
export const isDevelopment = process.env.NODE_ENV === 'development';

// Supabase 클라이언트 옵션
export const supabaseOptions = {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
};