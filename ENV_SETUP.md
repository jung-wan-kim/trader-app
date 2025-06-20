# 환경 변수 설정 가이드

## 필수 환경 변수

이 프로젝트를 실행하려면 다음 환경 변수가 필요합니다:

### 1. 환경 변수 파일 생성

`config/development.env` 파일을 생성하고 다음 내용을 추가하세요:

```env
# Supabase 설정 (필수)
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### 2. Supabase 키 찾는 방법

1. [Supabase 대시보드](https://supabase.com/dashboard)에 로그인
2. 프로젝트 선택
3. Settings → API 메뉴로 이동
4. Project URL과 Anon/Public Key 복사

### 3. 보안 주의사항

- **절대 하드코딩하지 마세요**: 환경 변수는 반드시 `.env` 파일에서만 관리
- **Git에 커밋하지 마세요**: `.env` 파일은 `.gitignore`에 포함되어 있어야 함
- **비밀 키는 사용하지 마세요**: `service_role` 키가 아닌 `anon` 키만 사용

### 4. 환경별 설정

#### 개발 환경
```bash
# config/development.env
SUPABASE_URL=https://dev-project.supabase.co
SUPABASE_ANON_KEY=dev-anon-key
```

#### 프로덕션 환경
```bash
# config/production.env
SUPABASE_URL=https://prod-project.supabase.co
SUPABASE_ANON_KEY=prod-anon-key
```

### 5. 문제 해결

#### 환경 변수를 찾을 수 없을 때
- 파일 경로 확인: `config/development.env`
- 파일 권한 확인: 읽기 권한이 있는지 확인
- 앱 재시작: 환경 변수 변경 후 앱을 다시 시작

#### Supabase 연결 오류
- URL 형식 확인: `https://` 포함 여부
- 키 길이 확인: Anon 키는 일반적으로 매우 긴 문자열
- 네트워크 연결 확인

### 6. Demo 모드

환경 변수 없이 앱을 테스트하려면 Demo 모드를 사용할 수 있습니다:
- 로그인 화면에서 "Continue with Demo" 버튼 클릭
- 제한된 기능만 사용 가능 (읽기 전용)