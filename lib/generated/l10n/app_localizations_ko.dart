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
      '제시 리버모어, 윌리엄 오닐 등\\\\n역사상 가장 성공한 트레이더들의\\\\n검증된 투자 전략을 활용하세요';

  @override
  String get onboardingTitle2 => 'AI 기반 종목 추천';

  @override
  String get onboardingDesc2 =>
      '최신 AI 기술로 시장을 분석하고\\\\n전설적 트레이더의 전략에 맞는\\\\n최적의 종목을 추천받으세요';

  @override
  String get onboardingTitle3 => '리스크 관리';

  @override
  String get onboardingDesc3 => '포지션 사이즈 계산기와\\\\n손절/익절 전략으로\\\\n안전한 투자를 실현하세요';

  @override
  String get onboardingTitle4 => '실시간 시장 분석';

  @override
  String get onboardingDesc4 =>
      '실시간 차트와 기술적 지표로\\\\n시장의 흐름을 파악하고\\\\n최적의 타이밍을 포착하세요';

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
  String get signInWithGoogle => 'Google로 로그인';

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
  String get accountManagement => '계정 관리';

  @override
  String get cancelSubscription => '구독 취소';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get cancelSubscriptionTitle => '구독 취소';

  @override
  String get cancelSubscriptionMessage =>
      '정말로 구독을 취소하시겠습니까? 현재 결제 기간이 끝날 때까지 계속 이용하실 수 있습니다.';

  @override
  String get cancelSubscriptionConfirm => '네, 취소합니다';

  @override
  String get deleteAccountTitle => '계정 삭제';

  @override
  String get deleteAccountMessage =>
      '정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없으며 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get deleteAccountConfirm => '네, 계정을 삭제합니다';

  @override
  String get subscriptionCancelledSuccessfully => '구독이 성공적으로 취소되었습니다';

  @override
  String get accountDeletedSuccessfully => '계정이 성공적으로 삭제되었습니다';

  @override
  String get languageSettings => '언어 설정';

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
      '• 구독은 구매 확인 시 iTunes 계정으로 청구됩니다\\\\n• 현재 기간 종료 24시간 전까지 자동 갱신을 끄지 않으면 구독이 자동으로 갱신됩니다\\\\n• 현재 기간 종료 24시간 이내에 갱신 요금이 청구됩니다\\\\n• 구독은 구매 후 계정 설정에서 관리할 수 있습니다\\\\n• 무료 체험 기간의 미사용 부분은 구독 구매 시 소멸됩니다';

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
  String get downgrade => '다운그레이드';

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

  @override
  String get termsTitle => 'Trader App 이용약관';

  @override
  String get termsEffectiveDate => '시행일: 2025년 2월 21일';

  @override
  String get termsSection1Title => '제1조 (목적)';

  @override
  String get termsSection1Content =>
      '이 약관은 Trader App(이하 \"회사\")이 제공하는 모바일 애플리케이션 서비스(이하 \"서비스\")의 이용과 관련하여 회사와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.';

  @override
  String get termsSection2Title => '제2조 (정의)';

  @override
  String get termsSection2Content =>
      '1. \"서비스\"란 회사가 제공하는 AI 기반 주식 추천 및 투자 정보 제공 서비스를 의미합니다.\n2. \"이용자\"란 이 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.\n3. \"회원\"이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며 서비스를 계속적으로 이용할 수 있는 자를 말합니다.';

  @override
  String get termsSection3Title => '제3조 (약관의 효력 및 변경)';

  @override
  String get termsSection3Content =>
      '1. 이 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력을 발생합니다.\n2. 회사는 필요하다고 인정되는 경우 이 약관을 변경할 수 있으며, 변경된 약관은 적용일 7일 전에 공지합니다.';

  @override
  String get termsSection4Title => '제4조 (서비스의 제공)';

  @override
  String get termsSection4Content =>
      '1. 회사는 다음과 같은 서비스를 제공합니다:\n   • AI 기반 주식 추천 서비스\n   • 전설적 트레이더 전략 정보 제공\n   • 실시간 주식 시세 정보\n   • 포트폴리오 관리 도구\n   • 리스크 계산기\n\n2. 서비스는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다. 단, 시스템 점검 등의 필요에 의해 일시적으로 중단될 수 있습니다.';

  @override
  String get termsFinancialDisclaimer =>
      '본 서비스에서 제공하는 모든 정보는 투자 참고 자료이며, 투자 권유나 투자 자문에 해당하지 않습니다.\n\n• 모든 투자 결정은 이용자 본인의 판단과 책임 하에 이루어져야 합니다.\n• 주식 투자는 원금 손실의 위험이 있습니다.\n• 과거의 수익률이 미래의 수익을 보장하지 않습니다.\n• 회사는 제공된 정보를 바탕으로 한 투자 결과에 대해 어떠한 책임도 지지 않습니다.';

  @override
  String get termsSection5Title => '제5조 (회원가입)';

  @override
  String get termsSection5Content =>
      '1. 회원가입은 이용자가 약관의 내용에 대하여 동의를 하고 회원가입신청을 한 후 회사가 이러한 신청에 대하여 승낙함으로써 체결됩니다.\n2. 회사는 다음 각 호에 해당하는 신청에 대하여는 승낙을 하지 않거나 사후에 이용계약을 해지할 수 있습니다:\n   • 실명이 아니거나 타인의 명의를 이용한 경우\n   • 허위의 정보를 기재하거나, 회사가 제시하는 내용을 기재하지 않은 경우\n   • 기타 이용신청 요건을 충족하지 못한 경우';

  @override
  String get termsSection6Title => '제6조 (이용자의 의무)';

  @override
  String get termsSection6Content =>
      '이용자는 다음 행위를 하여서는 안 됩니다:\n1. 타인의 정보를 도용하는 행위\n2. 회사의 지적재산권을 침해하는 행위\n3. 서비스의 운영을 고의로 방해하는 행위\n4. 기타 관계법령에 위배되는 행위';

  @override
  String get termsSection7Title => '제7조 (서비스 이용요금)';

  @override
  String get termsSection7Content =>
      '1. 기본 서비스는 무료로 제공됩니다.\n2. 프리미엄 서비스는 별도의 이용요금을 지불하여야 합니다.\n3. 유료서비스의 이용요금은 서비스 내에 명시된 요금정책에 따릅니다.\n4. 회사는 유료서비스 이용요금을 변경할 수 있으며, 변경 시 30일 전에 공지합니다.';

  @override
  String get termsSection8Title => '제8조 (면책조항)';

  @override
  String get termsSection8Content =>
      '1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.\n2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다.\n3. 회사가 제공하는 모든 투자 정보는 참고 자료일 뿐이며, 투자 결정에 따른 책임은 전적으로 이용자에게 있습니다.';

  @override
  String get termsSection9Title => '제9조 (개인정보보호)';

  @override
  String get termsSection9Content =>
      '회사는 이용자의 개인정보를 보호하기 위하여 개인정보처리방침을 수립하고 이를 준수합니다. 자세한 내용은 개인정보처리방침을 참고하시기 바랍니다.';

  @override
  String get termsSection10Title => '제10조 (분쟁해결)';

  @override
  String get termsSection10Content =>
      '1. 회사와 이용자 간에 발생한 분쟁은 상호 협의하여 해결하는 것을 원칙으로 합니다.\n2. 협의가 이루어지지 않을 경우, 관련 법령에 따른 관할 법원에서 해결합니다.';

  @override
  String get termsSupplementary => '부칙';

  @override
  String get termsSupplementaryDate => '이 약관은 2025년 2월 21일부터 시행합니다.';

  @override
  String get privacyTitle => 'Trader App 개인정보처리방침';

  @override
  String get privacyEffectiveDate => '시행일: 2025년 2월 21일';

  @override
  String get privacySection1Title => '1. 개인정보의 수집 및 이용목적';

  @override
  String get privacySection1Content =>
      'Trader App은 다음의 목적을 위하여 개인정보를 수집하고 있습니다:\n• 회원 가입 및 관리\n• 맞춤형 투자 정보 제공\n• 서비스 개선 및 신규 서비스 개발\n• 고객 문의 대응';

  @override
  String get privacySection2Title => '2. 수집하는 개인정보의 항목';

  @override
  String get privacySection2Content =>
      '• 필수항목: 이메일, 비밀번호\n• 선택항목: 이름, 전화번호, 투자 관심사\n• 자동수집항목: 기기정보, 앱 사용 기록, IP 주소';

  @override
  String get privacySection3Title => '3. 개인정보의 보유 및 이용기간';

  @override
  String get privacySection3Content =>
      '• 회원 탈퇴 시까지\n• 단, 관련 법령에 따라 보존이 필요한 경우 해당 기간 동안 보관\n• 전자상거래법에 따른 계약 또는 청약철회 기록: 5년\n• 소비자 불만 또는 분쟁처리 기록: 3년';

  @override
  String get privacySection4Title => '4. 개인정보의 제3자 제공';

  @override
  String get privacySection4Content =>
      'Trader App은 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다.\n다만, 다음의 경우에는 예외로 합니다:\n• 이용자의 동의가 있는 경우\n• 법령의 규정에 의한 경우';

  @override
  String get privacySection5Title => '5. 개인정보의 보호조치';

  @override
  String get privacySection5Content =>
      '• 개인정보 암호화\n• 해킹 등에 대비한 기술적 대책\n• 개인정보 접근 권한 제한\n• 개인정보 취급 직원의 최소화 및 교육';

  @override
  String get privacySection6Title => '6. 이용자의 권리';

  @override
  String get privacySection6Content =>
      '이용자는 언제든지 다음의 권리를 행사할 수 있습니다:\n• 개인정보 열람 요구\n• 개인정보 정정·삭제 요구\n• 개인정보 처리정지 요구\n• 개인정보 이동 요구';

  @override
  String get privacySection7Title => '7. 개인정보보호책임자';

  @override
  String get privacySection7Content =>
      '개인정보보호책임자: 홍길동\n이메일: privacy@traderapp.com\n전화: 02-1234-5678';

  @override
  String get privacySection8Title => '8. 개인정보처리방침의 변경';

  @override
  String get privacySection8Content =>
      '이 개인정보처리방침은 법령 및 서비스 변경사항을 반영하기 위해 수정될 수 있습니다.\n변경사항은 앱 내 공지사항을 통해 안내드립니다.';

  @override
  String get totalPortfolioValue => '총 포트폴리오 가치';

  @override
  String get portfolioPerformance30Days => '포트폴리오 성과 (30일)';

  @override
  String get performanceStatistics => '성과 통계';

  @override
  String get avgReturn => '평균 수익률';

  @override
  String get totalTrades => '총 거래 수';

  @override
  String get bestTrade => '최고의 거래';

  @override
  String get recentTrades => '최근 거래';

  @override
  String get monthlyReturns => '월별 수익률';

  @override
  String get jan => '1월';

  @override
  String get feb => '2월';

  @override
  String get mar => '3월';

  @override
  String get apr => '4월';

  @override
  String get may => '5월';

  @override
  String get jun => '6월';

  @override
  String get marketSummary => '시장 요약';

  @override
  String get addStock => '종목 추가';

  @override
  String get stocks => '종목';

  @override
  String get searchStocks => '종목 검색...';

  @override
  String get nothingInWatchlist => '관심 종목이 없습니다';

  @override
  String get addStocksToWatchlist => '성과를 추적할 종목을 추가하세요';

  @override
  String get remove => '삭제';

  @override
  String get addToWatchlist => '관심 종목에 추가';

  @override
  String get stockAddedToWatchlist => '관심 종목에 추가되었습니다';

  @override
  String get stockRemovedFromWatchlist => '관심 종목에서 삭제되었습니다';

  @override
  String get chooseTrader => '당신의 트레이딩 마스터를 선택하세요';

  @override
  String get performance => '성과';

  @override
  String get keyStrategy => '핵심 전략';

  @override
  String get selected => '선택됨';

  @override
  String get continueWithSelection => '선택 항목으로 계속하기';
}
