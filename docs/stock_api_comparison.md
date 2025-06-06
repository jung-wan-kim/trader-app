# 무료 실시간 주식 차트 데이터 API 비교

## 1. Yahoo Finance API

### 무료 티어 제한
- 공식 API 없음 (비공식 스크래핑 방식)
- 요청 제한 없음 (하지만 과도한 사용 시 IP 차단 가능)

### OHLC 데이터 제공
- ✅ 일일, 주간, 월간 OHLC 데이터 제공
- ✅ 1분, 5분, 15분, 30분, 60분 인터벌 지원

### API 키 필요 여부
- ❌ API 키 불필요

### Flutter/Dart 패키지
- ✅ `yahoo_finance_data_reader` (v1.0.12, 27 likes)
- ✅ `yahoofin` (v0.0.8, 19 likes)

### 실시간 vs 지연된 데이터
- 15분 지연된 데이터 (무료)
- 실시간 데이터 불가능

### 장단점
- 장점: 무료, API 키 불필요, Flutter 패키지 존재
- 단점: 비공식 API, 언제든 중단될 수 있음, 실시간 데이터 없음

---

## 2. Alpha Vantage API

### 무료 티어 제한
- 분당 5 API 호출
- 일일 500 API 호출

### OHLC 데이터 제공
- ✅ 일일, 주간, 월간 OHLC 데이터
- ✅ 1분, 5분, 15분, 30분, 60분 인트라데이 데이터
- ✅ 20년 이상의 역사적 데이터

### API 키 필요 여부
- ✅ 무료 API 키 필요

### Flutter/Dart 패키지
- ❌ 공식 패키지 없음 (HTTP 요청으로 직접 구현 필요)

### 실시간 vs 지연된 데이터
- 대부분 거래일 종료 후 업데이트
- 실시간/15분 지연 데이터는 프리미엄 플랜 필요

### 장단점
- 장점: 공식 API, 안정적, 다양한 데이터
- 단점: 매우 제한적인 무료 티어 (분당 5회), 실시간 데이터 유료

---

## 3. Finnhub API

### 무료 티어 제한
- 초당 30 API 호출
- 웹소켓 연결 지원

### OHLC 데이터 제공
- ✅ 주식 캔들 데이터 (OHLC)
- ✅ 외환, 암호화폐 데이터도 지원

### API 키 필요 여부
- ✅ API 키 필요

### Flutter/Dart 패키지
- ❌ 공식 패키지 없음 (HTTP/WebSocket으로 직접 구현)

### 실시간 vs 지연된 데이터
- 실시간 데이터 일부 제공
- 무료 티어에서도 웹소켓 지원

### 장단점
- 장점: 초당 30회로 넉넉한 제한, 웹소켓 지원
- 단점: Flutter 패키지 없음

---

## 4. Polygon.io API

### 무료 티어 제한
- 분당 5 API 호출
- 2년간의 역사적 데이터만 접근 가능

### OHLC 데이터 제공
- ✅ 종합적인 OHLC 데이터
- ✅ 집계된 바 데이터

### API 키 필요 여부
- ✅ API 키 필요

### Flutter/Dart 패키지
- ❌ 공식 패키지 없음

### 실시간 vs 지연된 데이터
- 15분 지연된 데이터 (무료)
- 실시간 데이터는 유료

### 장단점
- 장점: 고품질 데이터, 공식 API
- 단점: 매우 제한적인 무료 티어 (분당 5회)

---

## 5. IEX Cloud API

### 무료 티어 제한
- 월 50,000 메시지 크레딧
- 각 엔드포인트마다 다른 크레딧 소비

### OHLC 데이터 제공
- ✅ 일일, 인트라데이 OHLC 데이터
- ✅ 역사적 가격 데이터

### API 키 필요 여부
- ✅ API 키 필요

### Flutter/Dart 패키지
- ❌ 공식 패키지 없음

### 실시간 vs 지연된 데이터
- 15분 지연된 데이터 (무료)
- 실시간 데이터는 프리미엄

### 장단점
- 장점: 크레딧 시스템으로 유연한 사용
- 단점: 복잡한 크레딧 계산, Flutter 패키지 없음

---

## 추천 순위 (Flutter 앱 개발 기준)

1. **Finnhub API** - 초당 30회의 넉넉한 제한, 웹소켓 지원으로 실시간 느낌 구현 가능
2. **Yahoo Finance** - API 키 불필요, Flutter 패키지 존재, 하지만 비공식
3. **IEX Cloud** - 월 50,000 크레딧으로 합리적인 사용 가능
4. **Alpha Vantage** - 안정적이지만 분당 5회는 너무 제한적
5. **Polygon.io** - 고품질이지만 무료 티어가 너무 제한적

## Flutter 구현 팁

```dart
// Finnhub WebSocket 예시
final channel = WebSocketChannel.connect(
  Uri.parse('wss://ws.finnhub.io?token=YOUR_API_KEY'),
);

// Yahoo Finance 패키지 사용 예시
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

final yahooFinance = YahooFinanceDailyReader();
final stockData = await yahooFinance.getDailyData('AAPL');
```