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
  String get subscription => 'Subscription';

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
}
