import 'package:flutter/material.dart';
import '../models/stock_recommendation.dart';
import '../generated/l10n/app_localizations.dart';

class RecommendationCard extends StatelessWidget {
  final StockRecommendation recommendation;
  final VoidCallback onTap;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actionColor = _getActionColor(recommendation.action);
    final riskColor = _getRiskColor(recommendation.riskLevel);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[800]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: actionColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getLocalizedAction(recommendation.action, l10n),
                        style: TextStyle(
                          color: actionColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      recommendation.stockCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getLocalizedRiskLevel(recommendation.riskLevel, l10n),
                        style: TextStyle(
                          color: riskColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${recommendation.confidence.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Stock Name
            Text(
              recommendation.stockName,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Price Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.current ?? 'Current',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${recommendation.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n?.target ?? 'Target',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${recommendation.targetPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n?.potential ?? 'Potential',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${recommendation.potentialProfit > 0 ? '+' : ''}${recommendation.potentialProfit.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: recommendation.potentialProfit > 0 
                            ? const Color(0xFF00D632)
                            : const Color(0xFFFF3B30),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Reasoning
            Text(
              recommendation.reasoning,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Footer
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF00D632),
                      child: Text(
                        recommendation.traderName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      recommendation.traderName,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getTimeAgo(recommendation.recommendedAt, l10n),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'BUY':
        return const Color(0xFF00D632);
      case 'SELL':
        return const Color(0xFFFF3B30);
      case 'HOLD':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'LOW':
        return const Color(0xFF00D632);
      case 'MEDIUM':
        return Colors.orange;
      case 'HIGH':
        return const Color(0xFFFF3B30);
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime dateTime, AppLocalizations? l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return l10n?.daysAgo(difference.inDays) ?? '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return l10n?.hoursAgo(difference.inHours) ?? '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return l10n?.minutesAgo(difference.inMinutes) ?? '${difference.inMinutes}m ago';
    } else {
      return l10n?.justNow ?? 'Just now';
    }
  }

  String _getLocalizedAction(String action, AppLocalizations? l10n) {
    switch (action) {
      case 'BUY':
        return l10n?.buy ?? 'Buy';
      case 'SELL':
        return l10n?.sell ?? 'Sell';
      case 'HOLD':
        return l10n?.hold ?? 'Hold';
      default:
        return action;
    }
  }

  String _getLocalizedRiskLevel(String riskLevel, AppLocalizations? l10n) {
    switch (riskLevel) {
      case 'LOW':
        return l10n?.low ?? 'Low';
      case 'MEDIUM':
        return l10n?.medium ?? 'Medium';
      case 'HIGH':
        return l10n?.high ?? 'High';
      default:
        return riskLevel;
    }
  }
}