import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/real_time_price_service.dart';

class RealTimePriceIndicator extends ConsumerWidget {
  const RealTimePriceIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceStreamAsync = ref.watch(priceStreamProvider);
    
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priceStreamAsync.when(
                data: (_) => const Color(0xFF00D632),
                loading: () => Colors.orange,
                error: (_, __) => Colors.red,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            priceStreamAsync.when(
              data: (_) => 'Live Prices',
              loading: () => 'Connecting...',
              error: (_, __) => 'Price Update Failed',
            ),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const Spacer(),
          priceStreamAsync.when(
            data: (prices) => Text(
              'Updated: ${DateTime.now().toString().substring(11, 19)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
            loading: () => SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
              ),
            ),
            error: (_, __) => const Icon(
              Icons.refresh,
              size: 16,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}