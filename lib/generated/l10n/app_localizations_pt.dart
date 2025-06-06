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
}
