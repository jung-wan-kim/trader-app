// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Trader App';

  @override
  String get appSubtitle => 'Recommandations d\'Actions Alimentées par l\'IA';

  @override
  String get subscription => 'Abonnement';

  @override
  String get chooseLanguage => 'Choisissez votre langue';

  @override
  String get selectLanguageDescription =>
      'Sélectionnez votre langue préférée pour l\'application';

  @override
  String get continueButton => 'Continuer';

  @override
  String get onboardingTitle1 => 'Stratégies de Traders Légendaires';

  @override
  String get onboardingDesc1 =>
      'Utilisez des stratégies d\'investissement éprouvées des traders les plus réussis de l\'histoire comme Jesse Livermore et William O\'Neil';

  @override
  String get onboardingTitle2 => 'Recommandations d\'Actions par IA';

  @override
  String get onboardingDesc2 =>
      'Obtenez des recommandations d\'actions optimales qui correspondent aux stratégies de traders légendaires grâce à une analyse de marché IA avancée';

  @override
  String get onboardingTitle3 => 'Gestion des Risques';

  @override
  String get onboardingDesc3 =>
      'Réalisez des investissements sûrs avec un calculateur de taille de position et des stratégies de stop-loss/take-profit';

  @override
  String get onboardingTitle4 => 'Analyse de Marché en Temps Réel';

  @override
  String get onboardingDesc4 =>
      'Comprenez les tendances du marché et capturez le moment optimal avec des graphiques en temps réel et des indicateurs techniques';

  @override
  String get getStarted => 'Commencer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Se connecter';

  @override
  String get or => 'ou';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get demoModeNotice =>
      'Mode Démo : Compte de test rempli automatiquement';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get termsOfService => 'Conditions de Service';

  @override
  String get investmentWarning =>
      'Pour référence seulement, pas un conseil d\'investissement';

  @override
  String get profile => 'Profil';

  @override
  String get trader => 'Trader';

  @override
  String get subscriptionManagement => 'Gestion d\'Abonnement';

  @override
  String subscribedPlan(String planName) {
    return '$planName Actif';
  }

  @override
  String daysRemaining(int days) {
    return '$days jours restants';
  }

  @override
  String get upgradeToPremiun => 'Passer à Premium';

  @override
  String get freePlan => 'Plan Gratuit';

  @override
  String get investmentPerformance => 'Performance d\'Investissement';

  @override
  String get performanceDescription =>
      'Vérifier les retours et l\'historique des transactions';

  @override
  String get watchlist => 'Liste de Surveillance';

  @override
  String get watchlistDescription => 'Gérer les actions sauvegardées';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get notificationDescription =>
      'Gérer les recommandations et alertes de marché';

  @override
  String get legalInformation => 'Informations Légales';

  @override
  String get customerSupport => 'Support Client';

  @override
  String get appInfo => 'Infos de l\'app';

  @override
  String get versionInfo => 'Informations de Version';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get investmentWarningTitle =>
      'Avertissement de Risque d\'Investissement';

  @override
  String get investmentWarningText =>
      'Toutes les informations fournies dans cette application sont uniquement à des fins de référence et ne constituent pas des conseils d\'investissement. Toutes les décisions d\'investissement doivent être prises sous votre propre jugement et responsabilité.';

  @override
  String get settings => 'Paramètres';

  @override
  String get tradingSignals => 'Signaux de Trading';

  @override
  String get realTimeRecommendations =>
      'Recommandations en temps réel des meilleurs traders';

  @override
  String get investmentReferenceNotice =>
      'Pour référence d\'investissement. Les décisions d\'investissement sont de votre responsabilité.';

  @override
  String get currentPlan => 'Plan Actuel';

  @override
  String get nextBilling => 'Prochaine Facturation';

  @override
  String get amount => 'Montant';

  @override
  String get notScheduled => 'Non programmé';

  @override
  String get subscriptionInfo => 'Informations d\'Abonnement';

  @override
  String get subscriptionTerms => 'Conditions d\'Abonnement';

  @override
  String get subscriptionTermsText =>
      '• Les abonnements sont facturés à votre compte iTunes lors de la confirmation d\'achat\\n• Les abonnements se renouvellent automatiquement sauf si le renouvellement automatique est désactivé au moins 24 heures avant la fin de la période actuelle\\n• Les frais de renouvellement sont prélevés dans les 24 heures précédant la fin de la période actuelle\\n• Les abonnements peuvent être gérés dans les paramètres de votre compte après achat\\n• Toute partie inutilisée de la période d\'essai gratuite sera perdue lors de l\'achat d\'un abonnement';

  @override
  String get dataDelayWarning =>
      'Les données en temps réel peuvent être retardées de 15 minutes';

  @override
  String get dataSource => 'Données fournies par Finnhub';

  @override
  String get poweredBy => 'Alimenté par des Traders Légendaires';

  @override
  String get errorLoadingSubscription =>
      'Erreur lors du chargement de l\'abonnement';

  @override
  String get active => 'Actif';

  @override
  String get inactive => 'Inactif';

  @override
  String autoRenewalOff(String date) {
    return 'Le renouvellement automatique est désactivé. Votre plan expirera le $date';
  }

  @override
  String get availablePlans => 'Plans Disponibles';

  @override
  String get popular => 'POPULAIRE';

  @override
  String savePercent(int percent) {
    return 'Économisez $percent%';
  }

  @override
  String get upgrade => 'Mettre à niveau';

  @override
  String get downgrade => 'Rétrograder';

  @override
  String get billingHistory => 'Historique de Facturation';

  @override
  String get upgradePlan => 'Mettre à Niveau le Plan';

  @override
  String upgradePlanConfirm(String planName) {
    return 'Passer à $planName ?';
  }

  @override
  String get price => 'Prix';

  @override
  String upgradeSuccessful(String planName) {
    return 'Mise à niveau réussie vers $planName';
  }

  @override
  String get tierDescFree => 'Commencez avec les fonctionnalités de base';

  @override
  String get tierDescBasic => 'Pour les traders individuels';

  @override
  String get tierDescPro => 'Outils avancés pour les traders sérieux';

  @override
  String get tierDescPremium => 'Tout ce dont vous avez besoin pour réussir';

  @override
  String get tierDescEnterprise => 'Solutions personnalisées pour les équipes';

  @override
  String get errorLoadingRecommendations =>
      'Erreur lors du chargement des recommandations';

  @override
  String get retry => 'Réessayer';

  @override
  String get allActions => 'Toutes les actions';

  @override
  String get buy => 'Acheter';

  @override
  String get sell => 'Vendre';

  @override
  String get hold => 'Conserver';

  @override
  String get latest => 'Dernières';

  @override
  String get confidence => 'Confiance';

  @override
  String get profitPotential => 'Potentiel de profit';

  @override
  String get noRecommendationsFound => 'Aucune recommandation trouvée';

  @override
  String get portfolio => 'Portefeuille';

  @override
  String get errorLoadingPositions => 'Erreur lors du chargement des positions';

  @override
  String get today => 'aujourd\'hui';

  @override
  String get winRate => 'Taux de réussite';

  @override
  String get positions => 'Positions';

  @override
  String get dayPL => 'P&P du jour';

  @override
  String get noOpenPositions => 'Aucune position ouverte';

  @override
  String get startTradingToSeePositions =>
      'Commencez à trader pour voir vos positions';

  @override
  String get quantity => 'Quantité';

  @override
  String get avgCost => 'Coût moyen';

  @override
  String get current => 'Actuel';

  @override
  String get pl => 'P&P';

  @override
  String get close => 'Fermer';

  @override
  String get edit => 'Modifier';

  @override
  String get closePosition => 'Fermer la position';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return 'Fermer $quantity actions de $stockCode ?';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get positionClosedSuccessfully => 'Position fermée avec succès';

  @override
  String get sl => 'SL';

  @override
  String get tp => 'TP';

  @override
  String get upload => 'Télécharger';

  @override
  String get uploadVideo => 'Télécharger une vidéo';

  @override
  String get uploadDescription =>
      'Sélectionner dans la galerie ou filmer avec la caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Caméra';

  @override
  String get inbox => 'Boîte de réception';

  @override
  String get activity => 'Activité';

  @override
  String get newLikes => 'Nouveaux j\'aime';

  @override
  String get lastWeek => 'Semaine dernière';

  @override
  String get yesterday => 'Hier';

  @override
  String get newFollowers => 'Nouveaux abonnés';

  @override
  String get newComments => 'Nouveaux commentaires';

  @override
  String hoursAgo(int hours) {
    return 'il y a $hours heures';
  }

  @override
  String get messages => 'Messages';

  @override
  String get search => 'Rechercher';

  @override
  String get signals => 'Signaux';

  @override
  String get discover => 'Découvrir';

  @override
  String get premium => 'Premium';

  @override
  String get planFeatureBasicRecommendations => 'Recommandations de base';

  @override
  String planFeatureLimitedPositions(int count) {
    return 'Limité à $count positions';
  }

  @override
  String get planFeatureCommunitySupport => 'Support communautaire';

  @override
  String get planFeatureAllFreeFeatures =>
      'Toutes les fonctionnalités gratuites';

  @override
  String planFeatureUpToPositions(int count) {
    return 'Jusqu\'à $count positions';
  }

  @override
  String get planFeatureEmailSupport => 'Support par e-mail';

  @override
  String get planFeatureBasicAnalytics => 'Analyses de base';

  @override
  String get planFeatureAllBasicFeatures =>
      'Toutes les fonctionnalités de base';

  @override
  String get planFeatureRealtimeRecommendations =>
      'Recommandations en temps réel';

  @override
  String get planFeatureAdvancedAnalytics => 'Analyses avancées';

  @override
  String get planFeaturePrioritySupport => 'Support prioritaire';

  @override
  String get planFeatureRiskManagementTools => 'Outils de gestion des risques';

  @override
  String get planFeatureCustomAlerts => 'Alertes personnalisées';

  @override
  String get planFeatureAllProFeatures =>
      'Toutes les fonctionnalités Pro mensuelles';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count mois gratuits';
  }

  @override
  String get planFeatureAnnualReview => 'Révision annuelle des performances';

  @override
  String get planFeatureAllProFeaturesUnlimited =>
      'Toutes les fonctionnalités Pro';

  @override
  String get planFeatureUnlimitedPositions => 'Positions illimitées';

  @override
  String get planFeatureApiAccess => 'Accès API';

  @override
  String get planFeatureDedicatedManager => 'Gestionnaire de compte dédié';

  @override
  String get planFeatureCustomStrategies => 'Stratégies personnalisées';

  @override
  String get planFeatureWhiteLabelOptions => 'Options de marque blanche';

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
