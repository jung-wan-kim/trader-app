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
  String get subscription => 'Subscription';

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
  String get errorLoadingSubscription => 'Error loading subscription';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String autoRenewalOff(String date) {
    return 'Auto-renewal is off. Your plan will expire on $date';
  }

  @override
  String get availablePlans => 'Available Plans';

  @override
  String get popular => 'POPULAR';

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get upgrade => 'Upgrade';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get upgradePlan => 'Upgrade Plan';

  @override
  String upgradePlanConfirm(String planName) {
    return 'Upgrade to $planName?';
  }

  @override
  String get price => 'Price';

  @override
  String upgradeSuccessful(String planName) {
    return 'Successfully upgraded to $planName';
  }

  @override
  String get tierDescFree => 'Get started with basic features';

  @override
  String get tierDescBasic => 'For individual traders';

  @override
  String get tierDescPro => 'Advanced tools for serious traders';

  @override
  String get tierDescPremium => 'Everything you need to succeed';

  @override
  String get tierDescEnterprise => 'Custom solutions for teams';

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
}
