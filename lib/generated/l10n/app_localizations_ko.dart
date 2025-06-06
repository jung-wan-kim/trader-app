// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '트레이더 앱';

  @override
  String get appSubtitle => 'AI 기반 주식 추천 서비스';

  @override
  String get chooseLanguage => '언어를 선택하세요';

  @override
  String get selectLanguageDescription => '앱에서 사용할 언어를 선택해주세요';

  @override
  String get continueButton => '계속하기';

  @override
  String get onboardingTitle1 => '전설적 트레이더의 전략';

  @override
  String get onboardingDesc1 =>
      '제시 리버모어, 윌리엄 오닐 등\\n역사상 가장 성공한 트레이더들의\\n검증된 투자 전략을 활용하세요';

  @override
  String get onboardingTitle2 => 'AI 기반 종목 추천';

  @override
  String get onboardingDesc2 =>
      '최신 AI 기술로 시장을 분석하고\\n전설적 트레이더의 전략에 맞는\\n최적의 종목을 추천받으세요';

  @override
  String get onboardingTitle3 => '리스크 관리';

  @override
  String get onboardingDesc3 => '포지션 사이즈 계산기와\\n손절/익절 전략으로\\n안전한 투자를 실현하세요';

  @override
  String get onboardingTitle4 => '실시간 시장 분석';

  @override
  String get onboardingDesc4 =>
      '실시간 차트와 기술적 지표로\\n시장의 흐름을 파악하고\\n최적의 타이밍을 포착하세요';

  @override
  String get getStarted => '시작하기';

  @override
  String get next => '다음';

  @override
  String get skip => '건너뛰기';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get login => '로그인';

  @override
  String get or => '또는';

  @override
  String get signInWithApple => 'Apple로 로그인';

  @override
  String get demoModeNotice => '데모 모드: 테스트 계정이 자동 입력되었습니다';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get termsOfService => '이용약관';

  @override
  String get investmentWarning => '투자 권유가 아닌 참고 정보를 제공합니다';

  @override
  String get profile => '프로필';

  @override
  String get trader => '트레이더';

  @override
  String get subscriptionManagement => '구독 관리';

  @override
  String subscribedPlan(String planName) {
    return '$planName 구독 중';
  }

  @override
  String daysRemaining(int days) {
    return '$days일 남음';
  }

  @override
  String get upgradeToPremiun => '프리미엄으로 업그레이드';

  @override
  String get freePlan => '무료 플랜';

  @override
  String get investmentPerformance => '투자 성과';

  @override
  String get performanceDescription => '수익률 및 거래 내역 확인';

  @override
  String get watchlist => '관심 종목';

  @override
  String get watchlistDescription => '저장한 종목 관리';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get notificationDescription => '추천 및 시장 알림 관리';

  @override
  String get legalInformation => '법적 정보';

  @override
  String get customerSupport => '고객 지원';

  @override
  String get appInfo => '앱 정보';

  @override
  String get versionInfo => '버전 정보';

  @override
  String get logout => '로그아웃';

  @override
  String get investmentWarningTitle => '투자 위험 경고';

  @override
  String get investmentWarningText =>
      '본 앱에서 제공하는 모든 정보는 투자 참고 자료이며, 투자 권유나 투자 자문에 해당하지 않습니다. 모든 투자 결정은 본인의 판단과 책임 하에 이루어져야 합니다.';

  @override
  String get settings => '설정';

  @override
  String get tradingSignals => '트레이딩 시그널';

  @override
  String get realTimeRecommendations => '전문 트레이더들의 실시간 추천';

  @override
  String get investmentReferenceNotice => '투자 참고용 정보입니다. 투자 결정은 본인 책임입니다.';

  @override
  String get currentPlan => '현재 플랜';

  @override
  String get nextBilling => '다음 결제';

  @override
  String get amount => '금액';

  @override
  String get notScheduled => '예정 없음';

  @override
  String get subscriptionInfo => '구독 정보';

  @override
  String get subscriptionTerms => '구독 약관';

  @override
  String get subscriptionTermsText =>
      '• 구독은 구매 확인 시 iTunes 계정으로 청구됩니다\\n• 현재 기간 종료 24시간 전까지 자동 갱신을 끄지 않으면 구독이 자동으로 갱신됩니다\\n• 현재 기간 종료 24시간 이내에 갱신 요금이 청구됩니다\\n• 구독은 구매 후 계정 설정에서 관리할 수 있습니다\\n• 무료 체험 기간의 미사용 부분은 구독 구매 시 소멸됩니다';

  @override
  String get dataDelayWarning => '실시간 데이터는 15분 지연될 수 있습니다';

  @override
  String get dataSource => '데이터 제공: Finnhub';

  @override
  String get poweredBy => '전설적 트레이더들의 전략';
}
