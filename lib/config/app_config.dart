class AppConfig {
  static const bool isDemoMode = true; // 심사용 데모 모드
  static const String appVersion = '1.0.0';
  
  // API 설정
  static const String finnhubApiKey = 'YOUR_API_KEY'; // 실제 키로 교체 필요
  static const bool useMockData = isDemoMode; // 데모 모드에서는 Mock 데이터 사용
  
  // 지원 정보
  static const String supportEmail = 'support@traderapp.com';
  static const String privacyPolicyUrl = 'https://traderapp.com/privacy';
  static const String termsOfServiceUrl = 'https://traderapp.com/terms';
  
  // 테스트 계정 (심사용)
  static const String testEmail = 'reviewer@example.com';
  static const String testPassword = 'test1234';
  
  // 금융 데이터 설정
  static const String dataDelayWarning = '실시간 데이터는 15분 지연될 수 있습니다.';
  static const String dataSource = 'Data provided by Finnhub';
}