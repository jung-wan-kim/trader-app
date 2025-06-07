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
      'ジェシー・リバモア、ウィリアム・オニールなど\\\\n歴史上最も成功したトレーダーの\\\\n実証済み投資戦略を活用';

  @override
  String get onboardingTitle2 => 'AI駆動の株式推奨';

  @override
  String get onboardingDesc2 =>
      '最新のAI技術で市場を分析し\\\\n伝説のトレーダー戦略に合った\\\\n最適な株式推奨を取得';

  @override
  String get onboardingTitle3 => 'リスク管理';

  @override
  String get onboardingDesc3 => 'ポジションサイズ計算機と\\\\n損切り/利確戦略で\\\\n安全な投資を実現';

  @override
  String get onboardingTitle4 => 'リアルタイム市場分析';

  @override
  String get onboardingDesc4 =>
      'リアルタイムチャートとテクニカル指標で\\\\n市場の流れを把握し\\\\n最適なタイミングを捉える';

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
  String get signInWithGoogle => 'Googleでサインイン';

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
  String get accountManagement => 'アカウント管理';

  @override
  String get cancelSubscription => 'サブスクリプションをキャンセル';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get cancelSubscriptionTitle => 'サブスクリプションのキャンセル';

  @override
  String get cancelSubscriptionMessage =>
      '本当にサブスクリプションをキャンセルしますか？現在の請求期間が終了するまでアクセスを継続できます。';

  @override
  String get cancelSubscriptionConfirm => 'はい、キャンセルします';

  @override
  String get deleteAccountTitle => 'アカウントの削除';

  @override
  String get deleteAccountMessage =>
      '本当にアカウントを削除しますか？この操作は元に戻すことができず、すべてのデータが永久に削除されます。';

  @override
  String get deleteAccountConfirm => 'はい、アカウントを削除します';

  @override
  String get subscriptionCancelledSuccessfully => 'サブスクリプションが正常にキャンセルされました';

  @override
  String get accountDeletedSuccessfully => 'アカウントが正常に削除されました';

  @override
  String get languageSettings => '言語設定';

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
      '• サブスクリプションは購入確認時にiTunesアカウントに請求されます\\\\n• 現在の期間終了の少なくとも24時間前に自動更新をオフにしない限り、サブスクリプションは自動的に更新されます\\\\n• 更新料金は現在の期間終了の24時間以内に請求されます\\\\n• サブスクリプションは購入後にアカウント設定で管理できます\\\\n• サブスクリプションを購入すると、無料試用期間の未使用部分は失効します';

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
  String get termsTitle => 'トレーダーアプリ利用規約';

  @override
  String get termsEffectiveDate => '施行日：2025年2月21日';

  @override
  String get termsSection1Title => '第1条（目的）';

  @override
  String get termsSection1Content =>
      '本規約は、トレーダーアプリ（以下「会社」という）が提供するモバイルアプリケーションサービス（以下「サービス」という）の利用に関して、会社と利用者の権利、義務及び責任事項を規定することを目的とします。';

  @override
  String get termsSection2Title => '第2条（定義）';

  @override
  String get termsSection2Content =>
      '1. 「サービス」とは、会社が提供するAIベースの株式推奨および投資情報提供サービスを意味します。\n2. 「利用者」とは、本規約に従って会社が提供するサービスを受ける会員および非会員を言います。\n3. 「会員」とは、会社に個人情報を提供して会員登録をした者で、会社の情報を継続的に提供されながらサービスを継続的に利用できる者を言います。';

  @override
  String get termsSection3Title => '第3条（規約の効力及び変更）';

  @override
  String get termsSection3Content =>
      '1. 本規約は、サービス画面に掲示するかその他の方法により利用者に公知することによって効力を発生します。\n2. 会社は必要があると認める場合、本規約を変更することができ、変更された規約は適用日の7日前に告知します。';

  @override
  String get termsSection4Title => '第4条（サービスの提供）';

  @override
  String get termsSection4Content =>
      '1. 会社は次のようなサービスを提供します：\n   • AIベースの株式推奨サービス\n   • 伝説的トレーダー戦略情報提供\n   • リアルタイム株式相場情報\n   • ポートフォリオ管理ツール\n   • リスク計算機\n\n2. サービスは年中無休、1日24時間提供することを原則とします。ただし、システム点検などの必要により一時的に中断される場合があります。';

  @override
  String get termsFinancialDisclaimer =>
      '本サービスで提供されるすべての情報は投資参考資料であり、投資勧誘や投資助言に該当しません。\n\n• すべての投資決定は利用者本人の判断と責任の下で行われるべきです。\n• 株式投資には元本損失のリスクがあります。\n• 過去の収益率が将来の収益を保証するものではありません。\n• 会社は提供された情報に基づく投資結果についていかなる責任も負いません。';

  @override
  String get termsSection5Title => '第5条（会員登録）';

  @override
  String get termsSection5Content =>
      '1. 会員登録は、利用者が規約の内容について同意をし、会員登録申込をした後、会社がこのような申込に対して承諾することによって締結されます。\n2. 会社は次の各号に該当する申込について承諾をしないか事後に利用契約を解約することができます：\n   • 実名でないか他人の名義を利用した場合\n   • 虚偽の情報を記載したか、会社が提示する内容を記載しなかった場合\n   • その他利用申込要件を満たしていない場合';

  @override
  String get termsSection6Title => '第6条（利用者の義務）';

  @override
  String get termsSection6Content =>
      '利用者は次の行為をしてはなりません：\n1. 他人の情報を盗用する行為\n2. 会社の知的財産権を侵害する行為\n3. サービスの運営を故意に妨害する行為\n4. その他関係法令に違反する行為';

  @override
  String get termsSection7Title => '第7条（サービス利用料金）';

  @override
  String get termsSection7Content =>
      '1. 基本サービスは無料で提供されます。\n2. プレミアムサービスは別途の利用料金を支払わなければなりません。\n3. 有料サービスの利用料金は、サービス内に明示された料金政策に従います。\n4. 会社は有料サービス利用料金を変更することができ、変更時は30日前に告知します。';

  @override
  String get termsSection8Title => '第8条（免責条項）';

  @override
  String get termsSection8Content =>
      '1. 会社は天災地変またはこれに準ずる不可抗力によりサービスを提供できない場合には、サービス提供に関する責任が免除されます。\n2. 会社は利用者の帰責事由によるサービス利用の障害については責任を負いません。\n3. 会社が提供するすべての投資情報は参考資料に過ぎず、投資決定による責任は全面的に利用者にあります。';

  @override
  String get termsSection9Title => '第9条（個人情報保護）';

  @override
  String get termsSection9Content =>
      '会社は利用者の個人情報を保護するために個人情報処理方針を策定し、これを遵守します。詳細については個人情報処理方針をご参照ください。';

  @override
  String get termsSection10Title => '第10条（紛争解決）';

  @override
  String get termsSection10Content =>
      '1. 会社と利用者間に発生した紛争は相互協議により解決することを原則とします。\n2. 協議が行われない場合、関連法令による管轄裁判所で解決します。';

  @override
  String get termsSupplementary => '附則';

  @override
  String get termsSupplementaryDate => '本規約は2025年2月21日から施行します。';

  @override
  String get privacyTitle => 'トレーダーアプリ個人情報処理方針';

  @override
  String get privacyEffectiveDate => '施行日：2025年2月21日';

  @override
  String get privacySection1Title => '1. 個人情報の収集及び利用目的';

  @override
  String get privacySection1Content =>
      'トレーダーアプリは次の目的のために個人情報を収集しています：\n• 会員登録および管理\n• カスタマイズされた投資情報提供\n• サービス改善および新規サービス開発\n• 顧客問い合わせ対応';

  @override
  String get privacySection2Title => '2. 収集する個人情報の項目';

  @override
  String get privacySection2Content =>
      '• 必須項目：メールアドレス、パスワード\n• 選択項目：氏名、電話番号、投資関心事\n• 自動収集項目：デバイス情報、アプリ使用記録、IPアドレス';

  @override
  String get privacySection3Title => '3. 個人情報の保有及び利用期間';

  @override
  String get privacySection3Content =>
      '• 会員退会時まで\n• ただし、関連法令により保存が必要な場合は該当期間中保管\n• 電子商取引法による契約または請約撤回記録：5年\n• 消費者不満または紛争処理記録：3年';

  @override
  String get privacySection4Title => '4. 個人情報の第三者提供';

  @override
  String get privacySection4Content =>
      'トレーダーアプリは原則的に利用者の個人情報を第三者に提供しません。\nただし、次の場合には例外とします：\n• 利用者の同意がある場合\n• 法令の規定による場合';

  @override
  String get privacySection5Title => '5. 個人情報の保護措置';

  @override
  String get privacySection5Content =>
      '• 個人情報暗号化\n• ハッキングなどに備えた技術的対策\n• 個人情報アクセス権限制限\n• 個人情報取扱職員の最小化及び教育';

  @override
  String get privacySection6Title => '6. 利用者の権利';

  @override
  String get privacySection6Content =>
      '利用者はいつでも次の権利を行使することができます：\n• 個人情報閲覧要求\n• 個人情報訂正・削除要求\n• 個人情報処理停止要求\n• 個人情報移動要求';

  @override
  String get privacySection7Title => '7. 個人情報保護責任者';

  @override
  String get privacySection7Content =>
      '個人情報保護責任者：洪吉東\nメールアドレス：privacy@traderapp.com\n電話：02-1234-5678';

  @override
  String get privacySection8Title => '8. 個人情報処理方針の変更';

  @override
  String get privacySection8Content =>
      '本個人情報処理方針は法令およびサービス変更事項を反映するために修正される場合があります。\n変更事項はアプリ内お知らせを通じて案内いたします。';

  @override
  String get totalPortfolioValue => 'ポートフォリオ総額';

  @override
  String get portfolioPerformance30Days => 'ポートフォリオパフォーマンス（30日）';

  @override
  String get performanceStatistics => 'パフォーマンス統計';

  @override
  String get avgReturn => '平均リターン';

  @override
  String get totalTrades => '総取引数';

  @override
  String get bestTrade => '最高の取引';

  @override
  String get recentTrades => '最近の取引';

  @override
  String get monthlyReturns => '月次リターン';

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
  String get marketSummary => 'マーケット概要';

  @override
  String get addStock => '銘柄追加';

  @override
  String get stocks => '銘柄';

  @override
  String get searchStocks => '銘柄検索...';

  @override
  String get nothingInWatchlist => 'ウォッチリストに銘柄がありません';

  @override
  String get addStocksToWatchlist => 'パフォーマンスを追跡する銘柄を追加';

  @override
  String get remove => '削除';

  @override
  String get addToWatchlist => 'ウォッチリストに追加';

  @override
  String get stockAddedToWatchlist => '銘柄をウォッチリストに追加しました';

  @override
  String get stockRemovedFromWatchlist => '銘柄をウォッチリストから削除しました';

  @override
  String get chooseTrader => 'あなたのトレーディングマスターを選択';

  @override
  String get performance => 'パフォーマンス';

  @override
  String get keyStrategy => '主要戦略';

  @override
  String get selected => '選択済み';

  @override
  String get continueWithSelection => '選択を続行';
}
