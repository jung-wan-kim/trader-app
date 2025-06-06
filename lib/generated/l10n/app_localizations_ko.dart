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
  String get subscription => 'Subscription';

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

  @override
  String get errorLoadingSubscription => '구독 정보를 불러오는 중 오류가 발생했습니다';

  @override
  String get active => '활성';

  @override
  String get inactive => '비활성';

  @override
  String autoRenewalOff(String date) {
    return '자동 갱신이 꺼져 있습니다. $date에 만료됩니다';
  }

  @override
  String get availablePlans => '이용 가능한 플랜';

  @override
  String get popular => '인기';

  @override
  String savePercent(int percent) {
    return '$percent% 할인';
  }

  @override
  String get upgrade => '업그레이드';

  @override
  String get billingHistory => '결제 내역';

  @override
  String get upgradePlan => '플랜 업그레이드';

  @override
  String upgradePlanConfirm(String planName) {
    return '$planName으로 업그레이드하시겠습니까?';
  }

  @override
  String get price => '가격';

  @override
  String upgradeSuccessful(String planName) {
    return '$planName으로 성공적으로 업그레이드되었습니다';
  }

  @override
  String get tierDescFree => '기본 기능으로 시작하기';

  @override
  String get tierDescBasic => '개인 트레이더를 위한 플랜';

  @override
  String get tierDescPro => '진지한 트레이더를 위한 고급 도구';

  @override
  String get tierDescPremium => '성공에 필요한 모든 것';

  @override
  String get tierDescEnterprise => '팀을 위한 맞춤 솔루션';

  @override
  String get errorLoadingRecommendations => '추천 목록을 불러오는 중 오류가 발생했습니다';

  @override
  String get retry => '다시 시도';

  @override
  String get allActions => '모든 액션';

  @override
  String get buy => '매수';

  @override
  String get sell => '매도';

  @override
  String get hold => '보유';

  @override
  String get latest => '최신';

  @override
  String get confidence => '신뢰도';

  @override
  String get profitPotential => '수익 잠재력';

  @override
  String get noRecommendationsFound => '추천 종목이 없습니다';

  @override
  String get portfolio => '포트폴리오';

  @override
  String get errorLoadingPositions => '포지션을 불러오는 중 오류가 발생했습니다';

  @override
  String get today => '오늘';

  @override
  String get winRate => '승률';

  @override
  String get positions => '포지션';

  @override
  String get dayPL => '일일 손익';

  @override
  String get noOpenPositions => '보유 포지션이 없습니다';

  @override
  String get startTradingToSeePositions => '거래를 시작하여 포지션을 확인하세요';

  @override
  String get quantity => '수량';

  @override
  String get avgCost => '평균 단가';

  @override
  String get current => '현재가';

  @override
  String get pl => '손익';

  @override
  String get close => '청산';

  @override
  String get edit => '편집';

  @override
  String get closePosition => '포지션 청산';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return '$stockCode $quantity주를 청산하시겠습니까?';
  }

  @override
  String get cancel => '취소';

  @override
  String get positionClosedSuccessfully => '포지션이 성공적으로 청산되었습니다';

  @override
  String get sl => '손절';

  @override
  String get tp => '익절';

  @override
  String get upload => '업로드';

  @override
  String get uploadVideo => '동영상 업로드';

  @override
  String get uploadDescription => '갤러리에서 선택하거나 카메라로 촬영하세요';

  @override
  String get gallery => '갤러리';

  @override
  String get camera => '카메라';

  @override
  String get inbox => '받은 메시지함';

  @override
  String get activity => '활동';

  @override
  String get newLikes => '새로운 좋아요';

  @override
  String get lastWeek => '지난주';

  @override
  String get yesterday => '어제';

  @override
  String get newFollowers => '새로운 팔로워';

  @override
  String get newComments => '새로운 댓글';

  @override
  String hoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String get messages => '메시지';

  @override
  String get search => '검색';

  @override
  String get signals => '시그널';

  @override
  String get discover => '발견';

  @override
  String get premium => '프리미엄';

  @override
  String get planFeatureBasicRecommendations => '기본 추천';

  @override
  String planFeatureLimitedPositions(int count) {
    return '최대 $count개 포지션';
  }

  @override
  String get planFeatureCommunitySupport => '커뮤니티 지원';

  @override
  String get planFeatureAllFreeFeatures => '모든 무료 기능';

  @override
  String planFeatureUpToPositions(int count) {
    return '최대 $count개 포지션';
  }

  @override
  String get planFeatureEmailSupport => '이메일 지원';

  @override
  String get planFeatureBasicAnalytics => '기본 분석';

  @override
  String get planFeatureAllBasicFeatures => '모든 기본 기능';

  @override
  String get planFeatureRealtimeRecommendations => '실시간 추천';

  @override
  String get planFeatureAdvancedAnalytics => '고급 분석';

  @override
  String get planFeaturePrioritySupport => '우선 지원';

  @override
  String get planFeatureRiskManagementTools => '리스크 관리 도구';

  @override
  String get planFeatureCustomAlerts => '사용자 정의 알림';

  @override
  String get planFeatureAllProFeatures => '모든 프로 월간 기능';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count개월 무료';
  }

  @override
  String get planFeatureAnnualReview => '연간 성과 검토';

  @override
  String get planFeatureAllProFeaturesUnlimited => '모든 프로 기능';

  @override
  String get planFeatureUnlimitedPositions => '무제한 포지션';

  @override
  String get planFeatureApiAccess => 'API 액세스';

  @override
  String get planFeatureDedicatedManager => '전담 계정 관리자';

  @override
  String get planFeatureCustomStrategies => '맞춤 전략';

  @override
  String get planFeatureWhiteLabelOptions => '화이트 라벨 옵션';
}
