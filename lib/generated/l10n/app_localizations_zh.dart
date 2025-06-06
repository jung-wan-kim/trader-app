// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '交易员应用';

  @override
  String get appSubtitle => 'AI驱动的股票推荐';

  @override
  String get subscription => '订阅';

  @override
  String get chooseLanguage => '选择您的语言';

  @override
  String get selectLanguageDescription => '请选择您在应用中使用的语言';

  @override
  String get continueButton => '继续';

  @override
  String get onboardingTitle1 => '传奇交易员策略';

  @override
  String get onboardingDesc1 => '利用杰西·利弗莫尔、威廉·奥尼尔等\\n历史上最成功交易员的\\n经过验证的投资策略';

  @override
  String get onboardingTitle2 => 'AI驱动的股票推荐';

  @override
  String get onboardingDesc2 => '通过先进的AI技术分析市场\\n获得符合传奇交易员策略的\\n最佳股票推荐';

  @override
  String get onboardingTitle3 => '风险管理';

  @override
  String get onboardingDesc3 => '通过仓位大小计算器\\n和止损/止盈策略\\n实现安全投资';

  @override
  String get onboardingTitle4 => '实时市场分析';

  @override
  String get onboardingDesc4 => '通过实时图表和技术指标\\n了解市场趋势\\n把握最佳时机';

  @override
  String get getStarted => '开始使用';

  @override
  String get next => '下一步';

  @override
  String get skip => '跳过';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get login => '登录';

  @override
  String get or => '或';

  @override
  String get signInWithApple => '使用Apple登录';

  @override
  String get demoModeNotice => '演示模式：测试账户已自动填写';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get investmentWarning => '仅供参考，非投资建议';

  @override
  String get profile => '个人资料';

  @override
  String get trader => '交易员';

  @override
  String get subscriptionManagement => '订阅管理';

  @override
  String subscribedPlan(String planName) {
    return '$planName 活跃中';
  }

  @override
  String daysRemaining(int days) {
    return '剩余$days天';
  }

  @override
  String get upgradeToPremiun => '升级到高级版';

  @override
  String get freePlan => '免费计划';

  @override
  String get investmentPerformance => '投资表现';

  @override
  String get performanceDescription => '查看收益率和交易历史';

  @override
  String get watchlist => '关注列表';

  @override
  String get watchlistDescription => '管理保存的股票';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notificationDescription => '管理推荐和市场提醒';

  @override
  String get legalInformation => '法律信息';

  @override
  String get customerSupport => '客户支持';

  @override
  String get appInfo => '应用信息';

  @override
  String get versionInfo => '版本信息';

  @override
  String get logout => '退出登录';

  @override
  String get investmentWarningTitle => '投资风险警告';

  @override
  String get investmentWarningText =>
      '本应用提供的所有信息仅供参考，不构成投资建议。所有投资决定必须在您自己的判断和责任下做出。';

  @override
  String get settings => '设置';

  @override
  String get tradingSignals => '交易信号';

  @override
  String get realTimeRecommendations => '专业交易员的实时推荐';

  @override
  String get investmentReferenceNotice => '投资参考信息。投资决定由您自行承担责任。';

  @override
  String get currentPlan => '当前计划';

  @override
  String get nextBilling => '下次计费';

  @override
  String get amount => '金额';

  @override
  String get notScheduled => '未安排';

  @override
  String get subscriptionInfo => '订阅信息';

  @override
  String get subscriptionTerms => '订阅条款';

  @override
  String get subscriptionTermsText =>
      '• 订阅在购买确认时向您的iTunes账户收费\\n• 除非在当前期间结束前至少24小时关闭自动续订，否则订阅会自动续订\\n• 续订费用在当前期间结束前24小时内收取\\n• 购买后可在账户设置中管理订阅\\n• 购买订阅时，免费试用期的任何未使用部分将被没收';

  @override
  String get dataDelayWarning => '实时数据可能延迟15分钟';

  @override
  String get dataSource => '数据提供方：Finnhub';

  @override
  String get poweredBy => '由传奇交易员提供支持';

  @override
  String get errorLoadingSubscription => '加载订阅时出错';

  @override
  String get active => '活跃中';

  @override
  String get inactive => '非活跃';

  @override
  String autoRenewalOff(String date) {
    return '自动续费已关闭。您的计划将在$date到期';
  }

  @override
  String get availablePlans => '可用计划';

  @override
  String get popular => '热门';

  @override
  String savePercent(int percent) {
    return '节省$percent%';
  }

  @override
  String get upgrade => '升级';

  @override
  String get downgrade => '降级';

  @override
  String get billingHistory => '计费历史';

  @override
  String get upgradePlan => '升级计划';

  @override
  String upgradePlanConfirm(String planName) {
    return '升级到$planName？';
  }

  @override
  String get price => '价格';

  @override
  String upgradeSuccessful(String planName) {
    return '成功升级到$planName';
  }

  @override
  String get tierDescFree => '从基本功能开始';

  @override
  String get tierDescBasic => '适合个人交易者';

  @override
  String get tierDescPro => '为专业交易者提供高级工具';

  @override
  String get tierDescPremium => '成功所需的一切';

  @override
  String get tierDescEnterprise => '针对团队的定制解决方案';

  @override
  String get errorLoadingRecommendations => '加载推荐时出错';

  @override
  String get retry => '重试';

  @override
  String get allActions => '所有操作';

  @override
  String get buy => '买入';

  @override
  String get sell => '卖出';

  @override
  String get hold => '持有';

  @override
  String get latest => '最新';

  @override
  String get confidence => '置信度';

  @override
  String get profitPotential => '盈利潜力';

  @override
  String get noRecommendationsFound => '未找到推荐';

  @override
  String get portfolio => '投资组合';

  @override
  String get errorLoadingPositions => '加载仓位时出错';

  @override
  String get today => '今天';

  @override
  String get winRate => '胜率';

  @override
  String get positions => '仓位';

  @override
  String get dayPL => '日盈亏';

  @override
  String get noOpenPositions => '无持仓';

  @override
  String get startTradingToSeePositions => '开始交易以查看您的仓位';

  @override
  String get quantity => '数量';

  @override
  String get avgCost => '平均成本';

  @override
  String get current => '当前价';

  @override
  String get pl => '盈亏';

  @override
  String get close => '平仓';

  @override
  String get edit => '编辑';

  @override
  String get closePosition => '平仓';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return '平仓$stockCode $quantity股？';
  }

  @override
  String get cancel => '取消';

  @override
  String get positionClosedSuccessfully => '仓位已成功平仓';

  @override
  String get sl => '止损';

  @override
  String get tp => '止盈';

  @override
  String get upload => '上传';

  @override
  String get uploadVideo => '上传视频';

  @override
  String get uploadDescription => '从相册选择或用相机拍摄';

  @override
  String get gallery => '相册';

  @override
  String get camera => '相机';

  @override
  String get inbox => '收件箱';

  @override
  String get activity => '活动';

  @override
  String get newLikes => '新的喜欢';

  @override
  String get lastWeek => '上周';

  @override
  String get yesterday => '昨天';

  @override
  String get newFollowers => '新的关注者';

  @override
  String get newComments => '新的评论';

  @override
  String hoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String get messages => '消息';

  @override
  String get search => '搜索';

  @override
  String get signals => '信号';

  @override
  String get discover => '发现';

  @override
  String get premium => '高级';

  @override
  String get planFeatureBasicRecommendations => '基本推荐';

  @override
  String planFeatureLimitedPositions(int count) {
    return '限制为$count个仓位';
  }

  @override
  String get planFeatureCommunitySupport => '社区支持';

  @override
  String get planFeatureAllFreeFeatures => '所有免费功能';

  @override
  String planFeatureUpToPositions(int count) {
    return '最多$count个仓位';
  }

  @override
  String get planFeatureEmailSupport => '邮件支持';

  @override
  String get planFeatureBasicAnalytics => '基本分析';

  @override
  String get planFeatureAllBasicFeatures => '所有基本功能';

  @override
  String get planFeatureRealtimeRecommendations => '实时推荐';

  @override
  String get planFeatureAdvancedAnalytics => '高级分析';

  @override
  String get planFeaturePrioritySupport => '优先支持';

  @override
  String get planFeatureRiskManagementTools => '风险管理工具';

  @override
  String get planFeatureCustomAlerts => '自定义警报';

  @override
  String get planFeatureAllProFeatures => '所有Pro月度功能';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count个月免费';
  }

  @override
  String get planFeatureAnnualReview => '年度绩效评估';

  @override
  String get planFeatureAllProFeaturesUnlimited => '所有Pro功能';

  @override
  String get planFeatureUnlimitedPositions => '无限仓位';

  @override
  String get planFeatureApiAccess => 'API访问';

  @override
  String get planFeatureDedicatedManager => '专属客户经理';

  @override
  String get planFeatureCustomStrategies => '自定义策略';

  @override
  String get planFeatureWhiteLabelOptions => '白牌选项';

  @override
  String get termsTitle => 'Trader App Terms of Service';

  @override
  String get termsEffectiveDate => 'Effective Date: February 21, 2025';

  @override
  String get termsSection1Title => 'Article 1 (Purpose)';

  @override
  String get termsSection1Content =>
      'These terms are intended to stipulate the rights, obligations, and responsibilities of the company and users regarding the use of mobile application services (hereinafter referred to as \"Services\") provided by Trader App (hereinafter referred to as \"Company\").';

  @override
  String get termsSection2Title => 'Article 2 (Definitions)';

  @override
  String get termsSection2Content =>
      '1. \"Service\" refers to the AI-based stock recommendation and investment information service provided by the Company.\n2. \"User\" refers to members and non-members who receive services provided by the Company under these terms.\n3. \"Member\" refers to a person who has registered as a member by providing personal information to the Company, continuously receives Company information, and can continuously use the Service.';

  @override
  String get termsSection3Title =>
      'Article 3 (Effectiveness and Changes to Terms)';

  @override
  String get termsSection3Content =>
      '1. These terms become effective by posting them on the service screen or notifying users through other means.\n2. The Company may change these terms when deemed necessary, and changed terms will be announced 7 days before the application date.';

  @override
  String get termsSection4Title => 'Article 4 (Provision of Services)';

  @override
  String get termsSection4Content =>
      '1. The Company provides the following services:\n   • AI-based stock recommendation service\n   • Legendary trader strategy information\n   • Real-time stock price information\n   • Portfolio management tools\n   • Risk calculator\n\n2. Services are provided 24 hours a day, 365 days a year in principle. However, they may be temporarily suspended due to system maintenance.';

  @override
  String get termsFinancialDisclaimer =>
      'All information provided by this service is for reference only and does not constitute investment advice or investment recommendations.\n\n• All investment decisions must be made under the user\'s own judgment and responsibility.\n• Stock investment carries the risk of principal loss.\n• Past returns do not guarantee future profits.\n• The Company assumes no responsibility for investment results based on the information provided.';

  @override
  String get termsSection5Title => 'Article 5 (Membership Registration)';

  @override
  String get termsSection5Content =>
      '1. Membership registration is concluded when the user agrees to the contents of the terms and applies for membership registration, and the Company approves such application.\n2. The Company may not approve or later terminate the usage contract for applications that fall under the following:\n   • Using a false name or another person\'s name\n   • Providing false information or not providing information requested by the Company\n   • Not meeting other application requirements';

  @override
  String get termsSection6Title => 'Article 6 (User Obligations)';

  @override
  String get termsSection6Content =>
      'Users must not engage in the following activities:\n1. Stealing others\' information\n2. Infringing on the Company\'s intellectual property rights\n3. Intentionally interfering with service operations\n4. Other activities that violate relevant laws and regulations';

  @override
  String get termsSection7Title => 'Article 7 (Service Usage Fees)';

  @override
  String get termsSection7Content =>
      '1. Basic services are provided free of charge.\n2. Premium services require payment of separate usage fees.\n3. Usage fees for paid services follow the fee policy specified within the service.\n4. The Company may change paid service usage fees and will notify 30 days in advance of changes.';

  @override
  String get termsSection8Title => 'Article 8 (Disclaimer)';

  @override
  String get termsSection8Content =>
      '1. The Company is exempt from responsibility for providing services when unable to provide services due to natural disasters or force majeure equivalent thereto.\n2. The Company is not responsible for service usage obstacles due to user\'s fault.\n3. All investment information provided by the Company is for reference only, and the responsibility for investment decisions lies entirely with the user.';

  @override
  String get termsSection9Title => 'Article 9 (Privacy Protection)';

  @override
  String get termsSection9Content =>
      'The Company establishes and complies with a privacy policy to protect users\' personal information. For details, please refer to the Privacy Policy.';

  @override
  String get termsSection10Title => 'Article 10 (Dispute Resolution)';

  @override
  String get termsSection10Content =>
      '1. Disputes between the Company and users shall be resolved through mutual consultation in principle.\n2. If consultation cannot be reached, it shall be resolved in the competent court according to relevant laws.';

  @override
  String get termsSupplementary => 'Supplementary Provisions';

  @override
  String get termsSupplementaryDate =>
      'These terms are effective from February 21, 2025.';

  @override
  String get privacyTitle => 'Trader App Privacy Policy';

  @override
  String get privacyEffectiveDate => 'Effective Date: February 21, 2025';

  @override
  String get privacySection1Title =>
      '1. Purpose of Collection and Use of Personal Information';

  @override
  String get privacySection1Content =>
      'Trader App collects personal information for the following purposes:\n• Member registration and management\n• Providing customized investment information\n• Service improvement and new service development\n• Customer inquiry response';

  @override
  String get privacySection2Title =>
      '2. Items of Personal Information Collected';

  @override
  String get privacySection2Content =>
      '• Required items: Email, password\n• Optional items: Name, phone number, investment interests\n• Automatically collected items: Device information, app usage history, IP address';

  @override
  String get privacySection3Title =>
      '3. Retention and Use Period of Personal Information';

  @override
  String get privacySection3Content =>
      '• Until membership withdrawal\n• However, retained for the required period if preservation is necessary according to relevant laws\n• Contract or subscription withdrawal records under e-commerce law: 5 years\n• Consumer complaint or dispute handling records: 3 years';

  @override
  String get privacySection4Title =>
      '4. Provision of Personal Information to Third Parties';

  @override
  String get privacySection4Content =>
      'Trader App does not provide users\' personal information to third parties in principle.\nHowever, exceptions are made in the following cases:\n• When user consent is obtained\n• When required by laws and regulations';

  @override
  String get privacySection5Title =>
      '5. Personal Information Protection Measures';

  @override
  String get privacySection5Content =>
      '• Personal information encryption\n• Technical measures against hacking\n• Limiting access to personal information\n• Minimizing and training personnel handling personal information';

  @override
  String get privacySection6Title => '6. User Rights';

  @override
  String get privacySection6Content =>
      'Users can exercise the following rights at any time:\n• Request to view personal information\n• Request to correct or delete personal information\n• Request to stop processing personal information\n• Request to transfer personal information';

  @override
  String get privacySection7Title =>
      '7. Personal Information Protection Officer';

  @override
  String get privacySection7Content =>
      'Personal Information Protection Officer: Hong Gil-dong\nEmail: privacy@traderapp.com\nPhone: 02-1234-5678';

  @override
  String get privacySection8Title => '8. Changes to Privacy Policy';

  @override
  String get privacySection8Content =>
      'This privacy policy may be modified to reflect changes in laws and services.\nChanges will be announced through in-app notifications.';
}
