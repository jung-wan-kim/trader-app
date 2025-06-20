# Trader App Configuration Guide

## 환경 설정 방법

### 1. 환경 파일 생성

개발 환경을 위한 설정 파일을 생성해야 합니다:

```bash
# 예제 파일을 복사하여 실제 환경 파일 생성
cp config/development.env.example config/development.env
```

### 2. Supabase 설정

`config/development.env` 파일을 열어 다음 값들을 설정하세요:

```env
# Supabase Configuration
SUPABASE_URL=https://lgebgddeerpxdjvtqvoi.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxnZWJnZGRlZXJweGRqdnRxdm9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzODcyMDksImV4cCI6MjA0ODk2MzIwOX0.2lw4P_8CQJd0Pb7iLBEqwBcQJxNAgfx3uSyQROQw-1A
```

### 3. 기타 API 키 설정 (선택사항)

#### Finnhub API Key
1. Get your free API key from [Finnhub](https://finnhub.io/)
2. Add to your environment file:
```
FINNHUB_API_KEY=your_finnhub_api_key_here
```

#### Development Configuration
Create `config/development.env`:
```
SUPABASE_URL=https://lgebgddeerpxdjvtqvoi.supabase.co
SUPABASE_ANON_KEY=your_actual_anon_key
FINNHUB_API_KEY=your_finnhub_api_key_here
```

#### Production Configuration  
Create `config/production.env`:
```
SUPABASE_URL=your_production_supabase_url
SUPABASE_ANON_KEY=your_production_anon_key
FINNHUB_API_KEY=your_production_finnhub_api_key_here
```

#### Staging Configuration
Create `config/staging.env`:
```
SUPABASE_URL=your_staging_supabase_url
SUPABASE_ANON_KEY=your_staging_anon_key
FINNHUB_API_KEY=your_staging_finnhub_api_key_here
```

### Using API Keys in Code

The API keys are loaded through the `EnvConfig` class in `lib/config/env_config.dart`.

Example usage:
```dart
final apiKey = EnvConfig.finnhubApiKey;
```

### Security Notes

- Never commit `.env` files to version control
- Add `*.env` to your `.gitignore` file
- Use different API keys for different environments
- Consider using secret management services for production