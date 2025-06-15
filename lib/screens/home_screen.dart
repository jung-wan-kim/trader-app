import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recommendations_provider.dart';
import '../providers/stock_data_provider.dart';
import '../models/stock_recommendation.dart';
import '../widgets/recommendation_card.dart';
import '../services/trading_service.dart';
import 'strategy_detail_screen.dart';
import 'trader_selection_screen.dart';
import '../generated/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? selectedAction;
  String? selectedRiskLevel;
  String? selectedTimeframe;
  String sortBy = 'date';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildDisclaimer(context),
            _buildFilters(context),
            Expanded(
              child: recommendationsAsync.when(
                data: (recommendations) => _buildRecommendationsList(recommendations, context),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00D632),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.errorLoadingRecommendations ?? 'Error loading recommendations',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(recommendationsProvider.notifier).refresh();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D632),
                        ),
                        child: Text(l10n?.retry ?? 'Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedStrategy = ref.watch(selectedTradingStrategyProvider);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n?.tradingSignals ?? 'Trading Signals',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 트레이더 선택 버튼
                    Flexible(
                      child: TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<TradingStrategy>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TraderSelectionScreen(),
                        ),
                      );
                      if (result != null) {
                        ref.read(selectedTradingStrategyProvider.notifier).state = result;
                      }
                    },
                    icon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF00D632),
                      size: 20,
                    ),
                    label: Text(
                      selectedStrategy.displayName,
                      style: const TextStyle(
                        color: Color(0xFF00D632),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      ),
                    ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(recommendationsProvider.notifier).refresh();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.realTimeRecommendations ?? 'Real-time recommendations from top traders',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.amber[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n?.investmentReferenceNotice ?? 'For investment reference. Investment decisions are your responsibility.',
              style: TextStyle(
                color: Colors.amber[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: l10n?.allActions ?? 'All Actions',
                  isSelected: selectedAction == null,
                  onTap: () {
                    setState(() => selectedAction = null);
                    ref.read(recommendationsProvider.notifier).filterByAction(null);
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: l10n?.buy ?? 'Buy',
                  isSelected: selectedAction == 'BUY',
                  onTap: () {
                    setState(() => selectedAction = 'BUY');
                    ref.read(recommendationsProvider.notifier).filterByAction('BUY');
                  },
                  color: const Color(0xFF00D632),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: l10n?.sell ?? 'Sell',
                  isSelected: selectedAction == 'SELL',
                  onTap: () {
                    setState(() => selectedAction = 'SELL');
                    ref.read(recommendationsProvider.notifier).filterByAction('SELL');
                  },
                  color: const Color(0xFFFF3B30),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: l10n?.hold ?? 'Hold',
                  isSelected: selectedAction == 'HOLD',
                  onTap: () {
                    setState(() => selectedAction = 'HOLD');
                    ref.read(recommendationsProvider.notifier).filterByAction('HOLD');
                  },
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSortChip(
                  label: l10n?.latest ?? 'Latest',
                  isSelected: sortBy == 'date',
                  onTap: () {
                    setState(() => sortBy = 'date');
                    ref.read(recommendationsProvider.notifier).sortByDate();
                  },
                ),
                const SizedBox(width: 8),
                _buildSortChip(
                  label: l10n?.confidence ?? 'Confidence',
                  isSelected: sortBy == 'confidence',
                  onTap: () {
                    setState(() => sortBy = 'confidence');
                    ref.read(recommendationsProvider.notifier).sortByConfidence();
                  },
                ),
                const SizedBox(width: 8),
                _buildSortChip(
                  label: l10n?.profitPotential ?? 'Profit Potential',
                  isSelected: sortBy == 'profit',
                  onTap: () {
                    setState(() => sortBy = 'profit');
                    ref.read(recommendationsProvider.notifier).sortByPotentialProfit();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (color ?? Colors.white).withOpacity(0.2)
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? (color ?? Colors.white)
                : Colors.grey[800]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? (color ?? Colors.white)
                : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[800] : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.sort,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(List<StockRecommendation> recommendations, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.noRecommendationsFound ?? 'No recommendations found',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(recommendationsProvider.notifier).refresh();
      },
      backgroundColor: Colors.grey[900],
      color: const Color(0xFF00D632),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final recommendation = recommendations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: RecommendationCard(
              recommendation: recommendation,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StrategyDetailScreen(
                      recommendation: recommendation,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}