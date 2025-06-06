// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Trader App';

  @override
  String get appSubtitle => 'Recomendações de Ações com IA';

  @override
  String get subscription => 'Subscription';

  @override
  String get chooseLanguage => 'Escolha seu idioma';

  @override
  String get selectLanguageDescription =>
      'Selecione seu idioma preferido para o aplicativo';

  @override
  String get continueButton => 'Continuar';

  @override
  String get onboardingTitle1 => 'Estratégias de Traders Lendários';

  @override
  String get onboardingDesc1 =>
      'Utilize estratégias de investimento comprovadas dos traders mais bem-sucedidos da história como Jesse Livermore e William O\'Neil';

  @override
  String get onboardingTitle2 => 'Recomendações de Ações com IA';

  @override
  String get onboardingDesc2 =>
      'Obtenha recomendações ótimas de ações que combinam com estratégias de traders lendários através de análise avançada de mercado com IA';

  @override
  String get onboardingTitle3 => 'Gestão de Risco';

  @override
  String get onboardingDesc3 =>
      'Alcance investimentos seguros com calculadora de tamanho de posição e estratégias de stop-loss/take-profit';

  @override
  String get onboardingTitle4 => 'Análise de Mercado em Tempo Real';

  @override
  String get onboardingDesc4 =>
      'Entenda tendências de mercado e capture o momento ideal com gráficos em tempo real e indicadores técnicos';

  @override
  String get getStarted => 'Começar';

  @override
  String get next => 'Próximo';

  @override
  String get skip => 'Pular';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get login => 'Entrar';

  @override
  String get or => 'ou';

  @override
  String get signInWithApple => 'Entrar com Apple';

  @override
  String get demoModeNotice =>
      'Modo Demo: Conta de teste preenchida automaticamente';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get investmentWarning =>
      'Apenas para referência, não é conselho de investimento';

  @override
  String get profile => 'Perfil';

  @override
  String get trader => 'Trader';

  @override
  String get subscriptionManagement => 'Gestão de Assinatura';

  @override
  String subscribedPlan(String planName) {
    return '$planName Ativo';
  }

  @override
  String daysRemaining(int days) {
    return '$days dias restantes';
  }

  @override
  String get upgradeToPremiun => 'Atualizar para Premium';

  @override
  String get freePlan => 'Plano Gratuito';

  @override
  String get investmentPerformance => 'Performance de Investimento';

  @override
  String get performanceDescription =>
      'Verificar retornos e histórico de negociações';

  @override
  String get watchlist => 'Lista de Observação';

  @override
  String get watchlistDescription => 'Gerenciar ações salvas';

  @override
  String get notificationSettings => 'Configurações de Notificação';

  @override
  String get notificationDescription =>
      'Gerenciar recomendações e alertas de mercado';

  @override
  String get legalInformation => 'Informações Legais';

  @override
  String get customerSupport => 'Suporte ao Cliente';

  @override
  String get appInfo => 'Informações do app';

  @override
  String get versionInfo => 'Informações da Versão';

  @override
  String get logout => 'Sair';

  @override
  String get investmentWarningTitle => 'Aviso de Risco de Investimento';

  @override
  String get investmentWarningText =>
      'Todas as informações fornecidas neste aplicativo são apenas para referência e não constituem conselho de investimento. Todas as decisões de investimento devem ser tomadas sob seu próprio julgamento e responsabilidade.';

  @override
  String get settings => 'Configurações';

  @override
  String get tradingSignals => 'Sinais de Trading';

  @override
  String get realTimeRecommendations =>
      'Recomendações em tempo real dos melhores traders';

  @override
  String get investmentReferenceNotice =>
      'Para referência de investimento. Decisões de investimento são sua responsabilidade.';

  @override
  String get currentPlan => 'Plano Atual';

  @override
  String get nextBilling => 'Próxima Cobrança';

  @override
  String get amount => 'Valor';

  @override
  String get notScheduled => 'Não agendado';

  @override
  String get subscriptionInfo => 'Informações de Assinatura';

  @override
  String get subscriptionTerms => 'Termos de Assinatura';

  @override
  String get subscriptionTermsText =>
      '• As assinaturas são cobradas em sua conta do iTunes na confirmação da compra\\n• As assinaturas renovam automaticamente a menos que a renovação automática seja desativada pelo menos 24 horas antes do final do período atual\\n• As taxas de renovação são cobradas dentro de 24 horas do final do período atual\\n• As assinaturas podem ser gerenciadas nas configurações de sua conta após a compra\\n• Qualquer parte não utilizada do período de teste gratuito será perdida ao comprar uma assinatura';

  @override
  String get dataDelayWarning =>
      'Dados em tempo real podem ter atraso de 15 minutos';

  @override
  String get dataSource => 'Dados fornecidos pela Finnhub';

  @override
  String get poweredBy => 'Alimentado por Traders Lendários';

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
  String get errorLoadingRecommendations => 'Erro ao carregar recomendações';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get allActions => 'Todas as ações';

  @override
  String get buy => 'Comprar';

  @override
  String get sell => 'Vender';

  @override
  String get hold => 'Manter';

  @override
  String get latest => 'Mais recente';

  @override
  String get confidence => 'Confiança';

  @override
  String get profitPotential => 'Potencial de lucro';

  @override
  String get noRecommendationsFound => 'Nenhuma recomendação encontrada';

  @override
  String get portfolio => 'Portfólio';

  @override
  String get errorLoadingPositions => 'Erro ao carregar posições';

  @override
  String get today => 'hoje';

  @override
  String get winRate => 'Taxa de acerto';

  @override
  String get positions => 'Posições';

  @override
  String get dayPL => 'L&P do dia';

  @override
  String get noOpenPositions => 'Sem posições abertas';

  @override
  String get startTradingToSeePositions =>
      'Comece a negociar para ver suas posições';

  @override
  String get quantity => 'Quantidade';

  @override
  String get avgCost => 'Custo médio';

  @override
  String get current => 'Atual';

  @override
  String get pl => 'L&P';

  @override
  String get close => 'Fechar';

  @override
  String get edit => 'Editar';

  @override
  String get closePosition => 'Fechar posição';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return 'Fechar $quantity ações de $stockCode?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get positionClosedSuccessfully => 'Posição fechada com sucesso';

  @override
  String get sl => 'SL';

  @override
  String get tp => 'TP';

  @override
  String get upload => 'Carregar';

  @override
  String get uploadVideo => 'Carregar vídeo';

  @override
  String get uploadDescription =>
      'Selecionar da galeria ou gravar com a câmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get camera => 'Câmera';

  @override
  String get inbox => 'Caixa de entrada';

  @override
  String get activity => 'Atividade';

  @override
  String get newLikes => 'Novas curtidas';

  @override
  String get lastWeek => 'Semana passada';

  @override
  String get yesterday => 'Ontem';

  @override
  String get newFollowers => 'Novos seguidores';

  @override
  String get newComments => 'Novos comentários';

  @override
  String hoursAgo(int hours) {
    return '$hours horas atrás';
  }

  @override
  String get messages => 'Mensagens';

  @override
  String get search => 'Pesquisar';

  @override
  String get signals => 'Sinais';

  @override
  String get discover => 'Descobrir';

  @override
  String get premium => 'Premium';

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
