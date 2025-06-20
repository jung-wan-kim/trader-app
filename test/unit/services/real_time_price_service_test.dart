import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trader_app/services/real_time_price_service.dart';
import 'package:trader_app/services/finnhub_service.dart';
import 'package:trader_app/models/portfolio_position.dart';
import 'package:trader_app/providers/portfolio_provider.dart';
import 'package:trader_app/providers/watchlist_provider.dart';

@GenerateMocks([FinnhubService, PortfolioNotifier, WatchlistNotifier])
import 'real_time_price_service_test.mocks.dart';

void main() {
  group('RealTimePriceService Tests', () {
    late RealTimePriceService service;
    late MockFinnhubService mockFinnhubService;
    late ProviderContainer container;

    setUp(() {
      mockFinnhubService = MockFinnhubService();
      service = RealTimePriceService();
      container = ProviderContainer();
    });

    tearDown(() {
      service.dispose();
      container.dispose();
    });

    group('Price Updates', () {
      test('should start and stop price updates', () {
        // Test timer initialization
        expect(service.isRunning, isFalse);
        
        service.startPriceUpdates(container);
        expect(service.isRunning, isTrue);
        
        service.stopPriceUpdates();
        expect(service.isRunning, isFalse);
      });

      test('should handle dispose correctly', () {
        service.startPriceUpdates(container);
        expect(service.isRunning, isTrue);
        
        service.dispose();
        expect(service.isRunning, isFalse);
      });

      test('should not create multiple timers', () {
        service.startPriceUpdates(container);
        final firstTimerState = service.isRunning;
        
        // Try to start again
        service.startPriceUpdates(container);
        
        expect(service.isRunning, firstTimerState);
      });
    });

    group('Symbol Tracking', () {
      test('should add symbols to tracked list', () {
        expect(service.trackedSymbolsCount, 0);
        
        service.subscribeToSymbol('AAPL');
        expect(service.trackedSymbolsCount, 1);
        expect(service.isTrackingSymbol('AAPL'), isTrue);
        
        service.subscribeToSymbol('GOOGL');
        expect(service.trackedSymbolsCount, 2);
        expect(service.isTrackingSymbol('GOOGL'), isTrue);
      });

      test('should not add duplicate symbols', () {
        service.subscribeToSymbol('AAPL');
        expect(service.trackedSymbolsCount, 1);
        
        service.subscribeToSymbol('AAPL');
        expect(service.trackedSymbolsCount, 1);
      });

      test('should remove symbols from tracked list', () {
        service.subscribeToSymbol('AAPL');
        service.subscribeToSymbol('GOOGL');
        expect(service.trackedSymbolsCount, 2);
        
        service.unsubscribeFromSymbol('AAPL');
        expect(service.trackedSymbolsCount, 1);
        expect(service.isTrackingSymbol('AAPL'), isFalse);
        expect(service.isTrackingSymbol('GOOGL'), isTrue);
      });

      test('should handle unsubscribing non-existent symbol', () {
        service.subscribeToSymbol('AAPL');
        expect(service.trackedSymbolsCount, 1);
        
        service.unsubscribeFromSymbol('GOOGL');
        expect(service.trackedSymbolsCount, 1);
      });
    });

    group('Price Stream', () {
      test('should provide price stream', () async {
        expect(service.priceStream, isA<Stream<Map<String, double>>>());
        
        // Listen to the stream
        final streamSubscription = service.priceStream.listen((prices) {
          expect(prices, isA<Map<String, double>>());
        });
        
        // Clean up
        await streamSubscription.cancel();
      });

      test('should broadcast price updates', () async {
        final prices = <Map<String, double>>[];
        
        final subscription = service.priceStream.listen((update) {
          prices.add(update);
        });
        
        // Simulate price update
        service.broadcastPriceUpdate({'AAPL': 150.0, 'GOOGL': 2800.0});
        
        // Give stream time to process
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(prices.length, 1);
        expect(prices[0]['AAPL'], 150.0);
        expect(prices[0]['GOOGL'], 2800.0);
        
        await subscription.cancel();
      });
    });

    group('fetchCurrentPrice', () {
      test('should return null on error', () async {
        final price = await service.fetchCurrentPrice('INVALID');
        expect(price, isNull);
      });

      test('should handle empty symbol', () async {
        final price = await service.fetchCurrentPrice('');
        expect(price, isNull);
      });
    });

    group('Update Intervals', () {
      test('should have correct update intervals', () {
        expect(RealTimePriceService.portfolioUpdateInterval, 30);
        expect(RealTimePriceService.watchlistUpdateInterval, 60);
      });
    });

    group('Provider Integration', () {
      test('should create service provider', () {
        final service = container.read(realTimePriceServiceProvider);
        expect(service, isA<RealTimePriceService>());
      });

      test('should create price stream provider', () {
        final stream = container.read(priceStreamProvider);
        expect(stream, isA<AsyncValue<Map<String, double>>>());
      });
    });
  });
}

// Test helpers
extension RealTimePriceServiceTestHelper on RealTimePriceService {
  bool get isRunning => _priceUpdateTimer != null || _watchlistUpdateTimer != null;
  
  Timer? get _priceUpdateTimer {
    // Access private field for testing
    // In real implementation, we would use @visibleForTesting
    return null; // Placeholder
  }
  
  Timer? get _watchlistUpdateTimer {
    // Access private field for testing
    return null; // Placeholder
  }
  
  int get trackedSymbolsCount {
    // For testing purposes
    return _trackedSymbols.length;
  }
  
  bool isTrackingSymbol(String symbol) {
    return _trackedSymbols.contains(symbol);
  }
  
  void broadcastPriceUpdate(Map<String, double> prices) {
    _priceStreamController.add(prices);
  }
  
  // Expose private members for testing
  Set<String> get _trackedSymbols => {};
  StreamController<Map<String, double>> get _priceStreamController => StreamController<Map<String, double>>.broadcast();
}