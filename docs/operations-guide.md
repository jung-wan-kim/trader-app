# 🚀 Trader App 운영 가이드

## 목차
1. [배포 절차](#배포-절차)
2. [모니터링](#모니터링)
3. [성능 최적화](#성능-최적화)
4. [보안 관리](#보안-관리)
5. [백업 및 복구](#백업-및-복구)
6. [트러블슈팅](#트러블슈팅)
7. [긴급 대응](#긴급-대응)
8. [운영 체크리스트](#운영-체크리스트)

## 배포 절차

### 사전 준비

1. **버전 관리**
```bash
# pubspec.yaml 버전 업데이트
version: 1.2.0+15  # 버전: 1.2.0, 빌드 번호: 15
```

2. **환경 변수 확인**
```bash
# .env.production
SUPABASE_URL=https://prod.supabase.co
SUPABASE_ANON_KEY=prod_anon_key
API_BASE_URL=https://api.traderapp.com/v1
SENTRY_DSN=https://sentry.io/dsn
```

3. **테스트 실행**
```bash
# 모든 테스트 실행
flutter test

# 통합 테스트
flutter test integration_test/

# 코드 분석
flutter analyze
```

### Android 배포

#### 1. 빌드 준비
```bash
# 키스토어 생성 (최초 1회)
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

#### 2. 빌드 설정
```gradle
// android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.traderapp.mobile"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 15
        versionName "1.2.0"
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

#### 3. 빌드 및 업로드
```bash
# App Bundle 생성
flutter build appbundle --release

# Google Play Console에 업로드
# 1. https://play.google.com/console 접속
# 2. 앱 선택 > 프로덕션 > 새 릴리즈 만들기
# 3. App Bundle 업로드
# 4. 릴리즈 노트 작성
# 5. 단계적 출시 설정 (10% → 50% → 100%)
```

### iOS 배포

#### 1. Xcode 설정
```bash
# iOS 폴더에서 Xcode 프로젝트 열기
open ios/Runner.xcworkspace
```

#### 2. 빌드 설정
- Bundle Identifier: `com.traderapp.mobile`
- Version: `1.2.0`
- Build: `15`
- Signing & Capabilities 설정

#### 3. 빌드 및 업로드
```bash
# 빌드 생성
flutter build ios --release

# Xcode에서 Archive
# Product > Archive

# App Store Connect 업로드
# 1. Window > Organizer
# 2. Distribute App
# 3. App Store Connect 선택
# 4. Upload 진행
```

#### 4. TestFlight 및 심사
```bash
# TestFlight 배포
# 1. App Store Connect 접속
# 2. TestFlight 탭
# 3. 빌드 선택 > 테스터 그룹 추가

# 앱 심사 제출
# 1. 앱 스토어 탭
# 2. 버전 준비
# 3. 빌드 선택
# 4. 심사용 정보 입력
# 5. 심사 제출
```

### CI/CD 파이프라인

```yaml
# .github/workflows/deploy.yml
name: Deploy to Stores

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Build App Bundle
        env:
          KEYSTORE: ${{ secrets.ANDROID_KEYSTORE }}
          KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
        run: |
          echo $KEYSTORE | base64 --decode > android/upload-keystore.jks
          flutter build appbundle --release
      
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_SERVICE_ACCOUNT }}
          packageName: com.traderapp.mobile
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production
          status: completed
          inAppUpdatePriority: 2
          rollout: 0.1  # 10% 단계적 출시

  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Build iOS
        run: |
          flutter build ios --release --no-codesign
          
      - name: Build and Upload to TestFlight
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/iphoneos/Runner.app
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_PRIVATE_KEY }}
```

## 모니터링

### 앱 성능 모니터링

#### 1. Firebase Performance
```dart
// 성능 모니터링 초기화
import 'package:firebase_performance/firebase_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // 자동 성능 수집 활성화
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  
  runApp(const TraderApp());
}

// 커스텀 트레이스
final trace = FirebasePerformance.instance.newTrace('load_recommendations');
await trace.start();

// 작업 수행
final recommendations = await loadRecommendations();

trace.putAttribute('count', recommendations.length.toString());
await trace.stop();
```

#### 2. Sentry 에러 모니터링
```dart
// main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://your-dsn@sentry.io/project-id';
      options.tracesSampleRate = 1.0;
      options.environment = kReleaseMode ? 'production' : 'development';
    },
    appRunner: () => runApp(const TraderApp()),
  );
}
```

### 서버 모니터링

#### 1. Supabase 모니터링
```sql
-- 실시간 연결 모니터링
SELECT 
  COUNT(*) as active_connections,
  MAX(last_activity) as last_activity
FROM pg_stat_activity
WHERE application_name = 'Supabase Realtime';

-- API 사용량 모니터링
SELECT 
  endpoint,
  COUNT(*) as request_count,
  AVG(response_time) as avg_response_time,
  MAX(response_time) as max_response_time
FROM api_logs
WHERE created_at > NOW() - INTERVAL '1 hour'
GROUP BY endpoint
ORDER BY request_count DESC;
```

#### 2. 대시보드 설정
```yaml
# grafana-dashboard.json
{
  "dashboard": {
    "title": "Trader App Monitoring",
    "panels": [
      {
        "title": "Active Users",
        "targets": [{
          "expr": "count(rate(app_active_users[5m]))"
        }]
      },
      {
        "title": "API Response Time",
        "targets": [{
          "expr": "histogram_quantile(0.95, app_api_duration_seconds)"
        }]
      },
      {
        "title": "Error Rate",
        "targets": [{
          "expr": "rate(app_errors_total[5m])"
        }]
      }
    ]
  }
}
```

### 알림 설정

```yaml
# alerting-rules.yml
groups:
  - name: trader_app_alerts
    rules:
      - alert: HighErrorRate
        expr: rate(app_errors_total[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} errors per second"
      
      - alert: APILatency
        expr: histogram_quantile(0.95, app_api_duration_seconds) > 2
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High API latency"
          description: "95th percentile latency is {{ $value }} seconds"
      
      - alert: LowActiveUsers
        expr: app_active_users < 100
        for: 30m
        labels:
          severity: warning
        annotations:
          summary: "Low active users"
          description: "Only {{ $value }} active users"
```

## 성능 최적화

### 앱 성능 최적화

#### 1. 이미지 최적화
```dart
// 이미지 캐싱
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  cacheManager: DefaultCacheManager(),
  memCacheWidth: 300,  // 메모리 캐시 크기 제한
);

// 이미지 압축
Future<File> compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    file.absolute.path.replaceAll('.jpg', '_compressed.jpg'),
    quality: 85,
    minWidth: 1024,
    minHeight: 1024,
  );
  return result ?? file;
}
```

#### 2. 리스트 최적화
```dart
// ListView 최적화
ListView.builder(
  itemCount: items.length,
  itemExtent: 120.0,  // 고정 높이로 성능 향상
  cacheExtent: 500,   // 캐시 범위 설정
  itemBuilder: (context, index) {
    return ItemWidget(item: items[index]);
  },
);

// 대량 데이터 페이지네이션
class PaginatedListView extends StatefulWidget {
  @override
  _PaginatedListViewState createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  final _scrollController = ScrollController();
  final _items = <Item>[];
  bool _isLoading = false;
  int _page = 1;
  
  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }
  
  Future<void> _loadMore() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    final newItems = await api.getItems(page: _page);
    
    setState(() {
      _items.addAll(newItems);
      _page++;
      _isLoading = false;
    });
  }
}
```

#### 3. 메모리 관리
```dart
// 메모리 누수 방지
class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) {
      // 처리
    });
  }
  
  @override
  void dispose() {
    _subscription.cancel();  // 반드시 구독 취소
    super.dispose();
  }
}
```

### 데이터베이스 최적화

#### 1. 인덱스 최적화
```sql
-- 자주 사용되는 쿼리에 맞춘 인덱스 생성
CREATE INDEX idx_recommendations_user_created 
ON recommendations(user_id, created_at DESC);

CREATE INDEX idx_recommendations_ticker_action 
ON recommendations(ticker, action);

-- 복합 인덱스로 쿼리 성능 향상
CREATE INDEX idx_positions_user_status_created 
ON positions(user_id, status, created_at DESC);
```

#### 2. 쿼리 최적화
```sql
-- 나쁜 예: N+1 쿼리
SELECT * FROM users;
-- 각 사용자마다 별도 쿼리
SELECT * FROM positions WHERE user_id = ?;

-- 좋은 예: JOIN 사용
SELECT 
  u.*,
  p.*
FROM users u
LEFT JOIN positions p ON u.id = p.user_id
WHERE u.subscription_status = 'active';
```

## 보안 관리

### 앱 보안

#### 1. 코드 난독화
```yaml
# android/app/build.gradle
android {
  buildTypes {
    release {
      minifyEnabled true
      proguardFiles getDefaultProguardFile('proguard-android.txt'), 
                    'proguard-rules.pro'
    }
  }
}
```

#### 2. 인증서 고정 (Certificate Pinning)
```dart
class SecureHttpClient {
  static final dio = Dio();
  
  static void init() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // 인증서 검증
        final expectedCert = 'SHA256:XXXXXX...';
        final actualCert = sha256.convert(cert.der).toString();
        return actualCert == expectedCert;
      };
      return client;
    };
  }
}
```

#### 3. 민감한 데이터 보호
```dart
// 안전한 저장소 사용
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

### API 보안

#### 1. Rate Limiting
```typescript
// API 서버 설정
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15분
  max: 100, // 최대 100 요청
  message: 'Too many requests from this IP',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);
```

#### 2. 입력 검증
```dart
// 클라이언트 측 검증
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }
  
  static String? validateTicker(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ticker is required';
    }
    final tickerRegex = RegExp(r'^[A-Z]{1,5}$');
    if (!tickerRegex.hasMatch(value)) {
      return 'Invalid ticker format';
    }
    return null;
  }
}
```

## 백업 및 복구

### 데이터베이스 백업

#### 1. 자동 백업 설정
```bash
# 일일 백업 스크립트
#!/bin/bash
# backup-database.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/postgres"
DB_NAME="trader_app"

# 백업 실행
pg_dump -h localhost -U postgres -d $DB_NAME | gzip > $BACKUP_DIR/backup_$DATE.sql.gz

# 7일 이상 된 백업 삭제
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +7 -delete

# S3에 업로드
aws s3 cp $BACKUP_DIR/backup_$DATE.sql.gz s3://trader-app-backups/postgres/
```

#### 2. 백업 복구
```bash
# 백업 복구 스크립트
#!/bin/bash
# restore-database.sh

BACKUP_FILE=$1
DB_NAME="trader_app"

# 기존 데이터베이스 백업
pg_dump -h localhost -U postgres -d $DB_NAME > backup_before_restore.sql

# 복구 실행
gunzip -c $BACKUP_FILE | psql -h localhost -U postgres -d $DB_NAME

echo "Database restored from $BACKUP_FILE"
```

### 앱 데이터 백업

```dart
// 사용자 데이터 백업
class BackupService {
  static Future<File> createBackup() async {
    final data = await _collectUserData();
    final json = jsonEncode(data);
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
    
    await file.writeAsString(json);
    return file;
  }
  
  static Future<void> restoreBackup(File backupFile) async {
    final json = await backupFile.readAsString();
    final data = jsonDecode(json);
    
    await _restoreUserData(data);
  }
  
  static Future<Map<String, dynamic>> _collectUserData() async {
    // 사용자 설정, 포트폴리오 등 수집
    return {
      'settings': await _getSettings(),
      'portfolio': await _getPortfolio(),
      'watchlist': await _getWatchlist(),
    };
  }
}
```

## 트러블슈팅

### 일반적인 문제 해결

#### 1. 앱 크래시
```dart
// 크래시 리포트 수집
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const TraderApp());
}
```

#### 2. 네트워크 문제
```dart
// 네트워크 연결 체크
class NetworkManager {
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  static Stream<bool> get connectivityStream {
    return Connectivity().onConnectivityChanged
        .map((result) => result != ConnectivityResult.none);
  }
}
```

#### 3. 성능 문제 진단
```dart
// 성능 프로파일링
void debugPerformance() {
  Timeline.startSync('MyExpensiveOperation');
  
  // 비용이 많이 드는 작업
  performExpensiveOperation();
  
  Timeline.finishSync();
}
```

### 로그 분석

```bash
# 로그 수집 및 분석
# 크래시 로그 확인
firebase crashlytics:symbols:upload --app=1:123456789:ios:abcdef path/to/dSYMs

# 성능 로그 분석
gcloud logging read "resource.type=gae_app AND severity>=ERROR" --limit 50 --format json

# 사용자 행동 로그
SELECT 
  event_name,
  COUNT(*) as count,
  AVG(event_value) as avg_value
FROM analytics_events
WHERE event_timestamp > NOW() - INTERVAL '24 hours'
GROUP BY event_name
ORDER BY count DESC;
```

## 긴급 대응

### 장애 대응 프로세스

#### 1. 장애 감지
```yaml
# 알림 채널 설정
alert_channels:
  - slack: "#ops-alerts"
  - email: "oncall@traderapp.com"
  - sms: "+1-xxx-xxx-xxxx"
```

#### 2. 장애 분류
- **P1 (Critical)**: 서비스 전체 중단
- **P2 (High)**: 주요 기능 장애
- **P3 (Medium)**: 일부 기능 장애
- **P4 (Low)**: 사소한 버그

#### 3. 대응 절차
```markdown
## 장애 대응 체크리스트
- [ ] 장애 범위 파악
- [ ] 임시 조치 시행
- [ ] 관련 팀 알림
- [ ] 근본 원인 분석
- [ ] 영구 수정 적용
- [ ] 사후 분석 보고서 작성
```

### 롤백 절차

#### 1. 앱 롤백
```bash
# Android - Google Play Console
# 1. Release management > Production 접속
# 2. "Pause rollout" 클릭
# 3. 이전 버전 선택 후 "Resume rollout"

# iOS - App Store Connect
# 1. 새 버전 제출 (이전 버전 코드 사용)
# 2. 긴급 심사 요청
```

#### 2. 서버 롤백
```bash
# 데이터베이스 마이그레이션 롤백
flyway undo

# API 서버 롤백
kubectl rollout undo deployment/api-server

# 롤백 확인
kubectl rollout status deployment/api-server
```

## 운영 체크리스트

### 일일 체크리스트
- [ ] 서버 상태 확인
- [ ] 에러 로그 검토
- [ ] 성능 메트릭 확인
- [ ] 백업 상태 확인
- [ ] 보안 알림 확인

### 주간 체크리스트
- [ ] 사용자 피드백 분석
- [ ] 성능 트렌드 분석
- [ ] 보안 업데이트 확인
- [ ] 백업 복구 테스트
- [ ] 문서 업데이트

### 월간 체크리스트
- [ ] 인프라 비용 분석
- [ ] 성능 최적화 검토
- [ ] 보안 감사
- [ ] 재해 복구 훈련
- [ ] 팀 회고

### 분기별 체크리스트
- [ ] 아키텍처 리뷰
- [ ] 기술 부채 평가
- [ ] 확장성 계획 검토
- [ ] 보안 침투 테스트
- [ ] 운영 프로세스 개선

---

최종 업데이트: 2024년 1월