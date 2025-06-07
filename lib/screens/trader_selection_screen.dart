import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/trading_service.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/stock_data_provider.dart';

class TraderSelectionScreen extends ConsumerStatefulWidget {
  const TraderSelectionScreen({super.key});

  @override
  ConsumerState<TraderSelectionScreen> createState() => _TraderSelectionScreenState();
}

class _TraderSelectionScreenState extends ConsumerState<TraderSelectionScreen> {
  TradingStrategy? selectedStrategy;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TraderInfo> traders = [
    TraderInfo(
      strategy: TradingStrategy.jesseLivermore,
      imageAsset: 'assets/images/jesse_livermore.jpg',
      performance: '+3,000%',
      keyStrategy: '추세 추종, 피라미딩',
      bestTrade: '1929년 대공황 예측',
      description: '역사상 가장 위대한 투기꾼. 시장의 추세를 읽고 큰 움직임을 포착하는 전략',
    ),
    TraderInfo(
      strategy: TradingStrategy.larryWilliams,
      imageAsset: 'assets/images/larry_williams.jpg',
      performance: '+11,376%',
      keyStrategy: '단기 모멘텀, 변동성 활용',
      bestTrade: '1987년 세계 트레이딩 챔피언십 우승',
      description: '단기 가격 모멘텀과 시장 변동성을 활용한 공격적 트레이딩',
    ),
    TraderInfo(
      strategy: TradingStrategy.stanWeinstein,
      imageAsset: 'assets/images/stan_weinstein.jpg',
      performance: '연평균 +25%',
      keyStrategy: '스테이지 분석, 장기 투자',
      bestTrade: '30년간 일관된 수익',
      description: '기술적 분석과 시장 단계를 결합한 체계적 투자 전략',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          l10n.chooseTrader,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: traders.length,
              itemBuilder: (context, index) {
                return _buildTraderCard(traders[index], l10n);
              },
            ),
          ),
          _buildPageIndicator(),
          _buildSelectionButton(l10n),
        ],
      ),
    );
  }

  Widget _buildTraderCard(TraderInfo trader, AppLocalizations l10n) {
    final isSelected = selectedStrategy == trader.strategy;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStrategy = trader.strategy;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF00D632).withOpacity(0.1)
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF00D632)
                : Colors.grey[800]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // 트레이더 이미지
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      trader.strategy.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 트레이더 정보
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trader.description,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildInfoRow(
                      icon: Icons.trending_up,
                      label: l10n.performance,
                      value: trader.performance,
                      valueColor: const Color(0xFF00D632),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildInfoRow(
                      icon: Icons.psychology,
                      label: l10n.keyStrategy,
                      value: trader.keyStrategy,
                    ),
                    const SizedBox(height: 12),
                    
                    _buildInfoRow(
                      icon: Icons.star,
                      label: l10n.bestTrade,
                      value: trader.bestTrade,
                    ),
                    
                    const Spacer(),
                    
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D632),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.selected,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          traders.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index 
                  ? const Color(0xFF00D632)
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: selectedStrategy != null 
            ? () {
                // 선택한 전략을 저장하고 다음 화면으로 이동
                ref.read(selectedTradingStrategyProvider.notifier).state = selectedStrategy!;
                Navigator.pop(context, selectedStrategy);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D632),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Colors.grey[800],
        ),
        child: Text(
          l10n.continueWithSelection,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TraderInfo {
  final TradingStrategy strategy;
  final String imageAsset;
  final String performance;
  final String keyStrategy;
  final String bestTrade;
  final String description;

  TraderInfo({
    required this.strategy,
    required this.imageAsset,
    required this.performance,
    required this.keyStrategy,
    required this.bestTrade,
    required this.description,
  });
}