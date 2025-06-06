// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'トレーダーアプリ';

  @override
  String get appSubtitle => 'AI駆動の株式推奨';

  @override
  String get subscription => 'Subscription';

  @override
  String get chooseLanguage => '言語を選択してください';

  @override
  String get selectLanguageDescription => 'アプリで使用する言語を選択してください';

  @override
  String get continueButton => '続行';

  @override
  String get onboardingTitle1 => '伝説のトレーダー戦略';

  @override
  String get onboardingDesc1 =>
      'ジェシー・リバモア、ウィリアム・オニールなど\\n歴史上最も成功したトレーダーの\\n実証済み投資戦略を活用';

  @override
  String get onboardingTitle2 => 'AI駆動の株式推奨';

  @override
  String get onboardingDesc2 => '最新のAI技術で市場を分析し\\n伝説のトレーダー戦略に合った\\n最適な株式推奨を取得';

  @override
  String get onboardingTitle3 => 'リスク管理';

  @override
  String get onboardingDesc3 => 'ポジションサイズ計算機と\\n損切り/利確戦略で\\n安全な投資を実現';

  @override
  String get onboardingTitle4 => 'リアルタイム市場分析';

  @override
  String get onboardingDesc4 =>
      'リアルタイムチャートとテクニカル指標で\\n市場の流れを把握し\\n最適なタイミングを捉える';

  @override
  String get getStarted => '始める';

  @override
  String get next => '次へ';

  @override
  String get skip => 'スキップ';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get login => 'ログイン';

  @override
  String get or => 'または';

  @override
  String get signInWithApple => 'Appleでサインイン';

  @override
  String get demoModeNotice => 'デモモード：テストアカウントが自動入力されました';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get investmentWarning => '参考情報のみ、投資助言ではありません';

  @override
  String get profile => 'プロフィール';

  @override
  String get trader => 'トレーダー';

  @override
  String get subscriptionManagement => 'サブスクリプション管理';

  @override
  String subscribedPlan(String planName) {
    return '$planName アクティブ';
  }

  @override
  String daysRemaining(int days) {
    return '残り$days日';
  }

  @override
  String get upgradeToPremiun => 'プレミアムにアップグレード';

  @override
  String get freePlan => '無料プラン';

  @override
  String get investmentPerformance => '投資パフォーマンス';

  @override
  String get performanceDescription => '収益率と取引履歴を確認';

  @override
  String get watchlist => 'ウォッチリスト';

  @override
  String get watchlistDescription => '保存した銘柄を管理';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notificationDescription => '推奨と市場アラートを管理';

  @override
  String get legalInformation => '法的情報';

  @override
  String get customerSupport => 'カスタマーサポート';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get versionInfo => 'バージョン情報';

  @override
  String get logout => 'ログアウト';

  @override
  String get investmentWarningTitle => '投資リスク警告';

  @override
  String get investmentWarningText =>
      'このアプリで提供される全ての情報は参考用であり、投資助言には該当しません。全ての投資決定はご自身の判断と責任で行ってください。';

  @override
  String get settings => '設定';

  @override
  String get tradingSignals => '取引シグナル';

  @override
  String get realTimeRecommendations => 'プロトレーダーからのリアルタイム推奨';

  @override
  String get investmentReferenceNotice => '投資参考情報です。投資決定はご自身の責任です。';

  @override
  String get currentPlan => '現在のプラン';

  @override
  String get nextBilling => '次回請求';

  @override
  String get amount => '金額';

  @override
  String get notScheduled => '予定なし';

  @override
  String get subscriptionInfo => 'サブスクリプション情報';

  @override
  String get subscriptionTerms => 'サブスクリプション条項';

  @override
  String get subscriptionTermsText =>
      '• サブスクリプションは購入確認時にiTunesアカウントに請求されます\\n• 現在の期間終了の少なくとも24時間前に自動更新をオフにしない限り、サブスクリプションは自動的に更新されます\\n• 更新料金は現在の期間終了の24時間以内に請求されます\\n• サブスクリプションは購入後にアカウント設定で管理できます\\n• サブスクリプションを購入すると、無料試用期間の未使用部分は失効します';

  @override
  String get dataDelayWarning => 'リアルタイムデータは15分遅延する場合があります';

  @override
  String get dataSource => 'データ提供：Finnhub';

  @override
  String get poweredBy => '伝説のトレーダーによる';

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
  String get upgrade => 'アップグレード';

  @override
  String get downgrade => 'ダウングレード';

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
  String get errorLoadingRecommendations => '推奨の読み込み中にエラーが発生しました';

  @override
  String get retry => '再試行';

  @override
  String get allActions => 'すべてのアクション';

  @override
  String get buy => '買い';

  @override
  String get sell => '売り';

  @override
  String get hold => '保有';

  @override
  String get latest => '最新';

  @override
  String get confidence => '信頼度';

  @override
  String get profitPotential => '利益潜在力';

  @override
  String get noRecommendationsFound => '推奨が見つかりません';

  @override
  String get portfolio => 'ポートフォリオ';

  @override
  String get errorLoadingPositions => 'ポジションの読み込み中にエラーが発生しました';

  @override
  String get today => '今日';

  @override
  String get winRate => '勝率';

  @override
  String get positions => 'ポジション';

  @override
  String get dayPL => '日次損益';

  @override
  String get noOpenPositions => 'オープンポジションはありません';

  @override
  String get startTradingToSeePositions => '取引を開始してポジションを確認してください';

  @override
  String get quantity => '数量';

  @override
  String get avgCost => '平均コスト';

  @override
  String get current => '現在値';

  @override
  String get pl => '損益';

  @override
  String get close => '決済';

  @override
  String get edit => '編集';

  @override
  String get closePosition => 'ポジション決済';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return '$stockCode $quantity株を決済しますか？';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get positionClosedSuccessfully => 'ポジションが正常に決済されました';

  @override
  String get sl => '損切り';

  @override
  String get tp => '利確';

  @override
  String get upload => 'アップロード';

  @override
  String get uploadVideo => '動画をアップロード';

  @override
  String get uploadDescription => 'ギャラリーから選択またはカメラで撮影';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get camera => 'カメラ';

  @override
  String get inbox => '受信トレイ';

  @override
  String get activity => 'アクティビティ';

  @override
  String get newLikes => '新しいいいね';

  @override
  String get lastWeek => '先週';

  @override
  String get yesterday => '昨日';

  @override
  String get newFollowers => '新しいフォロワー';

  @override
  String get newComments => '新しいコメント';

  @override
  String hoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String get messages => 'メッセージ';

  @override
  String get search => '検索';

  @override
  String get signals => 'シグナル';

  @override
  String get discover => 'ディスカバー';

  @override
  String get premium => 'プレミアム';

  @override
  String get planFeatureBasicRecommendations => 'Basic recommendations';

  @override
  String planFeatureLimitedPositions(int count) {
    return 'Limited to $count positions';
  }

  @override
  String get planFeatureCommunitySupport => 'Community support';

  @override
  String get planFeatureAllFreeFeatures => 'All Free features';

  @override
  String planFeatureUpToPositions(int count) {
    return 'Up to $count positions';
  }

  @override
  String get planFeatureEmailSupport => 'Email support';

  @override
  String get planFeatureBasicAnalytics => 'Basic analytics';

  @override
  String get planFeatureAllBasicFeatures => 'All Basic features';

  @override
  String get planFeatureRealtimeRecommendations => 'Real-time recommendations';

  @override
  String get planFeatureAdvancedAnalytics => 'Advanced analytics';

  @override
  String get planFeaturePrioritySupport => 'Priority support';

  @override
  String get planFeatureRiskManagementTools => 'Risk management tools';

  @override
  String get planFeatureCustomAlerts => 'Custom alerts';

  @override
  String get planFeatureAllProFeatures => 'All Pro Monthly features';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count months free';
  }

  @override
  String get planFeatureAnnualReview => 'Annual performance review';

  @override
  String get planFeatureAllProFeaturesUnlimited => 'All Pro features';

  @override
  String get planFeatureUnlimitedPositions => 'Unlimited positions';

  @override
  String get planFeatureApiAccess => 'API access';

  @override
  String get planFeatureDedicatedManager => 'Dedicated account manager';

  @override
  String get planFeatureCustomStrategies => 'Custom strategies';

  @override
  String get planFeatureWhiteLabelOptions => 'White-label options';
}
