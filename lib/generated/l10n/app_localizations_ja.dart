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
  String get subscription => 'サブスクリプション';

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
  String get errorLoadingSubscription => 'サブスクリプションの読み込み中にエラーが発生しました';

  @override
  String get active => 'アクティブ';

  @override
  String get inactive => '非アクティブ';

  @override
  String autoRenewalOff(String date) {
    return '自動更新がオフになっています。プランは$dateに期限切れとなります';
  }

  @override
  String get availablePlans => '利用可能なプラン';

  @override
  String get popular => '人気';

  @override
  String savePercent(int percent) {
    return '$percent%節約';
  }

  @override
  String get upgrade => 'アップグレード';

  @override
  String get downgrade => 'ダウングレード';

  @override
  String get billingHistory => '請求履歴';

  @override
  String get upgradePlan => 'プランをアップグレード';

  @override
  String upgradePlanConfirm(String planName) {
    return '$planNameにアップグレードしますか？';
  }

  @override
  String get price => '価格';

  @override
  String upgradeSuccessful(String planName) {
    return '$planNameへのアップグレードが完了しました';
  }

  @override
  String get tierDescFree => '基本機能から始める';

  @override
  String get tierDescBasic => '個人トレーダー向け';

  @override
  String get tierDescPro => '真剣なトレーダー向けの高度なツール';

  @override
  String get tierDescPremium => '成功に必要なすべてが揃っています';

  @override
  String get tierDescEnterprise => 'チーム向けのカスタムソリューション';

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
  String get planFeatureBasicRecommendations => '基本的な推奨';

  @override
  String planFeatureLimitedPositions(int count) {
    return '$countポジションまで制限';
  }

  @override
  String get planFeatureCommunitySupport => 'コミュニティサポート';

  @override
  String get planFeatureAllFreeFeatures => 'すべての無料機能';

  @override
  String planFeatureUpToPositions(int count) {
    return '最大$countポジション';
  }

  @override
  String get planFeatureEmailSupport => 'メールサポート';

  @override
  String get planFeatureBasicAnalytics => '基本分析';

  @override
  String get planFeatureAllBasicFeatures => 'すべてのベーシック機能';

  @override
  String get planFeatureRealtimeRecommendations => 'リアルタイム推奨';

  @override
  String get planFeatureAdvancedAnalytics => '高度な分析';

  @override
  String get planFeaturePrioritySupport => '優先サポート';

  @override
  String get planFeatureRiskManagementTools => 'リスク管理ツール';

  @override
  String get planFeatureCustomAlerts => 'カスタムアラート';

  @override
  String get planFeatureAllProFeatures => 'すべてのPro月額機能';

  @override
  String planFeatureMonthsFree(int count) {
    return '$countヶ月無料';
  }

  @override
  String get planFeatureAnnualReview => '年次パフォーマンスレビュー';

  @override
  String get planFeatureAllProFeaturesUnlimited => 'すべてのPro機能';

  @override
  String get planFeatureUnlimitedPositions => '無制限ポジション';

  @override
  String get planFeatureApiAccess => 'APIアクセス';

  @override
  String get planFeatureDedicatedManager => '専属アカウントマネージャー';

  @override
  String get planFeatureCustomStrategies => 'カスタム戦略';

  @override
  String get planFeatureWhiteLabelOptions => 'ホワイトラベルオプション';

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
