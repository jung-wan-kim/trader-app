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
  String get onboardingDesc1 =>
      '利用杰西·利弗莫尔、威廉·奥尼尔等\\\\n历史上最成功交易员的\\\\n经过验证的投资策略';

  @override
  String get onboardingTitle2 => 'AI驱动的股票推荐';

  @override
  String get onboardingDesc2 => '通过先进的AI技术分析市场\\\\n获得符合传奇交易员策略的\\\\n最佳股票推荐';

  @override
  String get onboardingTitle3 => '风险管理';

  @override
  String get onboardingDesc3 => '通过仓位大小计算器\\\\n和止损/止盈策略\\\\n实现安全投资';

  @override
  String get onboardingTitle4 => '实时市场分析';

  @override
  String get onboardingDesc4 => '通过实时图表和技术指标\\\\n了解市场趋势\\\\n把握最佳时机';

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
  String get signInWithGoogle => '使用Google登录';

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
  String get accountManagement => '账户管理';

  @override
  String get cancelSubscription => '取消订阅';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get cancelSubscriptionTitle => '取消订阅';

  @override
  String get cancelSubscriptionMessage => '您确定要取消订阅吗？您将在当前计费周期结束前继续享有访问权限。';

  @override
  String get cancelSubscriptionConfirm => '是的，取消';

  @override
  String get deleteAccountTitle => '删除账户';

  @override
  String get deleteAccountMessage => '您确定要删除您的账户吗？此操作无法撤销，您的所有数据将被永久删除。';

  @override
  String get deleteAccountConfirm => '是的，删除账户';

  @override
  String get subscriptionCancelledSuccessfully => '订阅已成功取消';

  @override
  String get accountDeletedSuccessfully => '账户已成功删除';

  @override
  String get languageSettings => '语言设置';

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
      '• 订阅在购买确认时向您的iTunes账户收费\\\\n• 除非在当前期间结束前至少24小时关闭自动续订，否则订阅会自动续订\\\\n• 续订费用在当前期间结束前24小时内收取\\\\n• 购买后可在账户设置中管理订阅\\\\n• 购买订阅时，免费试用期的任何未使用部分将被没收';

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
  String get current => '当前价';

  @override
  String get target => 'Target';

  @override
  String get potential => 'Potential';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

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
  String get jesseKeyStrategy => '趋势跟踪，金字塔式加仓';

  @override
  String get jesseBestTrade => '预测1929年股灣崩盘';

  @override
  String get jesseDescription => '历史上最伟大的投机者。解读市场趋势并捕捉大动作的策略';

  @override
  String get larryKeyStrategy => '短期动量，波动性';

  @override
  String get larryBestTrade => '1987年世界交易冠军赛冠军';

  @override
  String get larryDescription => '利用短期价格动量和市场波动性的积极交易';

  @override
  String get stanKeyStrategy => '阶段分析，长期投资';

  @override
  String get stanBestTrade => '30年持续回报';

  @override
  String get stanDescription => '结合技术分析和市场阶段的系统投资策略';

  @override
  String get termsTitle => '交易员应用服务条款';

  @override
  String get termsEffectiveDate => '生效日期：2025年2月21日';

  @override
  String get termsSection1Title => '第1条（目的）';

  @override
  String get termsSection1Content =>
      '本条款旨在规定交易员应用（以下简称\\\"公司\\\"）提供的移动应用服务（以下简称\\\"服务\\\"）使用中公司与用户的权利、义务和责任事项。';

  @override
  String get termsSection2Title => '第2条（定义）';

  @override
  String get termsSection2Content =>
      '1. \\\"服务\\\"是指公司提供的基于AI的股票推荐和投资信息服务。\\\\n2. \\\"用户\\\"是指根据本条款接受公司提供服务的会员和非会员。\\\\n3. \\\"会员\\\"是指向公司提供个人信息进行会员注册，持续接收公司信息并能持续使用服务的人员。';

  @override
  String get termsSection3Title => '第3条（条款的效力和变更）';

  @override
  String get termsSection3Content =>
      '1. 本条款通过在服务界面发布或通过其他方式通知用户而生效。\\\\n2. 公司在认为必要时可以变更本条款，变更后的条款将在适用日期前7天公布。';

  @override
  String get termsSection4Title => '第4条（服务提供）';

  @override
  String get termsSection4Content =>
      '1. 公司提供以下服务：\\\\n   • 基于AI的股票推荐服务\\\\n   • 传奇交易员策略信息\\\\n   • 实时股票价格信息\\\\n   • 投资组合管理工具\\\\n   • 风险计算器\\\\n\\\\n2. 服务原则上全年无休，每天24小时提供。但由于系统维护等需要可能暂时中断。';

  @override
  String get termsFinancialDisclaimer =>
      '本服务提供的所有信息仅供参考，不构成投资建议或投资推荐。\\\\n\\\\n• 所有投资决策应在您自己的判断和责任下做出。\\\\n• 股票投资存在本金损失风险。\\\\n• 过去的收益不保证未来利润。\\\\n• 公司对基于所提供信息的投资结果不承担任何责任。';

  @override
  String get termsSection5Title => '第5条（会员注册）';

  @override
  String get termsSection5Content =>
      '1. 会员注册在用户同意条款内容并申请会员注册后，公司批准此类申请时完成。\\\\n2. 公司可能不批准或事后终止符合以下条件的申请使用合同：\\\\n   • 使用虚假姓名或他人姓名\\\\n   • 提供虚假信息或未提供公司要求的信息\\\\n   • 不符合其他申请要求';

  @override
  String get termsSection6Title => '第6条（用户义务）';

  @override
  String get termsSection6Content =>
      '用户不得从事以下活动：\\\\n1. 盗取他人信息\\\\n2. 侵犯公司知识产权\\\\n3. 故意干扰服务运营\\\\n4. 其他违反相关法律法规的活动';

  @override
  String get termsSection7Title => '第7条（服务使用费）';

  @override
  String get termsSection7Content =>
      '1. 基础服务免费提供。\\\\n2. 高级服务需要支付单独的使用费。\\\\n3. 付费服务的使用费遵循服务内规定的费用政策。\\\\n4. 公司可以更改付费服务使用费，变更时将提前30天通知。';

  @override
  String get termsSection8Title => '第8条（免责声明）';

  @override
  String get termsSection8Content =>
      '1. 公司因自然灾害或相当的不可抗力无法提供服务时，免除服务提供责任。\\\\n2. 公司对因用户过错导致的服务使用障碍不承担责任。\\\\n3. 公司提供的所有投资信息仅供参考，投资决策责任完全由用户承担。';

  @override
  String get termsSection9Title => '第9条（隐私保护）';

  @override
  String get termsSection9Content => '公司制定并遵守隐私政策以保护用户个人信息。详情请参阅隐私政策。';

  @override
  String get termsSection10Title => '第10条（争议解决）';

  @override
  String get termsSection10Content =>
      '1. 公司与用户之间发生的争议原则上通过相互协商解决。\\\\n2. 如无法达成协商，将根据相关法律在管辖法院解决。';

  @override
  String get termsSupplementary => '附则';

  @override
  String get termsSupplementaryDate => '本条款自2025年2月21日起生效。';

  @override
  String get privacyTitle => '交易员应用隐私政策';

  @override
  String get privacyEffectiveDate => '生效日期：2025年2月21日';

  @override
  String get privacySection1Title => '1. 个人信息收集和使用目的';

  @override
  String get privacySection1Content =>
      '交易员应用为以下目的收集个人信息：\\\\n• 会员注册和管理\\\\n• 提供个性化投资信息\\\\n• 服务改进和新服务开发\\\\n• 客户咨询响应';

  @override
  String get privacySection2Title => '2. 收集的个人信息项目';

  @override
  String get privacySection2Content =>
      '• 必需项目：邮箱、密码\\\\n• 可选项目：姓名、电话号码、投资兴趣\\\\n• 自动收集项目：设备信息、应用使用记录、IP地址';

  @override
  String get privacySection3Title => '3. 个人信息保留和使用期限';

  @override
  String get privacySection3Content =>
      '• 直到会员退出\\\\n• 但如相关法律要求保存，则在要求期间内保留\\\\n• 电子商务法下的合同或订阅取消记录：5年\\\\n• 消费者投诉或争议处理记录：3年';

  @override
  String get privacySection4Title => '4. 向第三方提供个人信息';

  @override
  String get privacySection4Content =>
      '交易员应用原则上不向第三方提供用户个人信息。\\\\n但在以下情况下例外：\\\\n• 获得用户同意时\\\\n• 法律法规要求时';

  @override
  String get privacySection5Title => '5. 个人信息保护措施';

  @override
  String get privacySection5Content =>
      '• 个人信息加密\\\\n• 防黑客技术措施\\\\n• 限制个人信息访问权限\\\\n• 最小化和培训处理个人信息的人员';

  @override
  String get privacySection6Title => '6. 用户权利';

  @override
  String get privacySection6Content =>
      '用户可随时行使以下权利：\\\\n• 要求查看个人信息\\\\n• 要求更正或删除个人信息\\\\n• 要求停止处理个人信息\\\\n• 要求转移个人信息';

  @override
  String get privacySection7Title => '7. 个人信息保护负责人';

  @override
  String get privacySection7Content =>
      '个人信息保护负责人：洪吉东\\\\n邮箱：privacy@traderapp.com\\\\n电话：02-1234-5678';

  @override
  String get privacySection8Title => '8. 隐私政策变更';

  @override
  String get privacySection8Content => '本隐私政策可能因法律和服务变更而修改。\\\\n变更将通过应用内通知公布。';

  @override
  String get totalPortfolioValue => '投资组合总价值';

  @override
  String get portfolioPerformance30Days => '投资组合表现（30天）';

  @override
  String get performanceStatistics => '表现统计';

  @override
  String get avgReturn => '平均回报';

  @override
  String get totalTrades => '总交易数';

  @override
  String get bestTrade => '最佳交易';

  @override
  String get recentTrades => '最近交易';

  @override
  String get monthlyReturns => '月度回报';

  @override
  String get jan => '1月';

  @override
  String get feb => '2月';

  @override
  String get mar => '3月';

  @override
  String get apr => '4月';

  @override
  String get may => '5月';

  @override
  String get jun => '6月';

  @override
  String get marketSummary => '市场摘要';

  @override
  String get addStock => '添加股票';

  @override
  String get stocks => '股票';

  @override
  String get searchStocks => '搜索股票...';

  @override
  String get nothingInWatchlist => '关注列表中没有股票';

  @override
  String get addStocksToWatchlist => '添加股票以追踪其表现';

  @override
  String get remove => '删除';

  @override
  String get addToWatchlist => '添加到关注列表';

  @override
  String get stockAddedToWatchlist => '股票已添加到关注列表';

  @override
  String get stockRemovedFromWatchlist => '股票已从关注列表移除';

  @override
  String get chooseTrader => '选择您的交易大师';

  @override
  String get performance => '业绩表现';

  @override
  String get keyStrategy => '核心策略';

  @override
  String get selected => '已选择';

  @override
  String get continueWithSelection => '继续选择';
}
