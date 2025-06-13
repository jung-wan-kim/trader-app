import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/services/trading_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SupabaseClient, FunctionsClient, FunctionResponse])
import 'trading_service_test.mocks.dart';

void main() {
  group('TradingService Tests', () {
    late TradingService tradingService;
    late MockSupabaseClient mockSupabaseClient;
    late MockFunctionsClient mockFunctionsClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockFunctionsClient = MockFunctionsClient();
      
      when(mockSupabaseClient.functions).thenReturn(mockFunctionsClient);
      
      tradingService = TradingService(mockSupabaseClient);
    });

    group('Trading Signals', () {
      test('should get trading signal successfully', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final signalData = <String, dynamic>{
          'signal': <String, dynamic>{
            'action': 'buy',
            'confidence': 0.85,
            'entry_price': 150.0,
            'target_price': 160.0,
            'stop_loss': 145.0,
            'reasoning': 'Strong bullish momentum detected',
            'indicators': <String, dynamic>{
              'rsi': 65.0,
              'macd': 'bullish',
              'volume': 'above_average'
            }
          }
        };
        
        when( mockResponse.data).thenReturn(signalData);
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final signal = await tradingService.getSignal(
          symbol: 'AAPL',
          strategy: TradingStrategy.jesseLivermore,
          timeframe: 'D',
        );

        // Assert
        expect(signal, isA<TradingSignal>());
        expect(signal.action, equals(SignalAction.buy));
        expect(signal.confidence, equals(0.85));
        expect(signal.entryPrice, equals(150.0));
        expect(signal.targetPrice, equals(160.0));
        expect(signal.stopLoss, equals(145.0));
        expect(signal.reasoning, equals('Strong bullish momentum detected'));
        expect(signal.indicators['rsi'], equals(65.0));
      });

      test('should handle sell signal', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final signalData = <String, dynamic>{
          'signal': <String, dynamic>{
            'action': 'sell',
            'confidence': 0.75,
            'entry_price': 200.0,
            'target_price': 180.0,
            'stop_loss': 210.0,
            'reasoning': 'Overbought conditions',
            'indicators': <String, dynamic>{
              'rsi': 85.0,
              'macd': 'bearish'
            }
          }
        };
        
        when( mockResponse.data).thenReturn(signalData);
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final signal = await tradingService.getSignal(
          symbol: 'TSLA',
          strategy: TradingStrategy.larryWilliams,
        );

        // Assert
        expect(signal.action, equals(SignalAction.sell));
        expect(signal.confidence, equals(0.75));
      });

      test('should handle hold signal', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final signalData = <String, dynamic>{
          'signal': <String, dynamic>{
            'action': 'hold',
            'confidence': 0.5,
            'reasoning': 'No clear trend',
            'indicators': <String, dynamic>{}
          }
        };
        
        when( mockResponse.data).thenReturn(signalData);
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final signal = await tradingService.getSignal(
          symbol: 'GOOGL',
          strategy: TradingStrategy.stanWeinstein,
        );

        // Assert
        expect(signal.action, equals(SignalAction.hold));
        expect(signal.confidence, equals(0.5));
      });

      test('should handle error when no signal received', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        when( mockResponse.data).thenReturn(null);
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => tradingService.getSignal(
            symbol: 'AAPL',
            strategy: TradingStrategy.jesseLivermore,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No signal received'),
          )),
        );
      });

      test('should handle API error', () async {
        // Arrange
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => tradingService.getSignal(
            symbol: 'AAPL',
            strategy: TradingStrategy.jesseLivermore,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to fetch signal'),
          )),
        );
      });
    });

    group('Multiple Signals', () {
      test('should get multiple signals successfully', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final signalData = <String, dynamic>{
          'signal': <String, dynamic>{
            'action': 'buy',
            'confidence': 0.8,
            'entry_price': 150.0,
            'target_price': 160.0,
            'stop_loss': 145.0,
            'reasoning': 'Bullish signal',
            'indicators': <String, dynamic>{}
          }
        };
        
        when( mockResponse.data).thenReturn(signalData);
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final signals = await tradingService.getMultipleSignals(
          symbols: ['AAPL', 'GOOGL', 'MSFT'],
          strategy: TradingStrategy.jesseLivermore,
        );

        // Assert
        expect(signals.length, equals(3));
        expect(signals[0].symbol, equals('AAPL'));
        expect(signals[1].symbol, equals('GOOGL'));
        expect(signals[2].symbol, equals('MSFT'));
      });

      test('should handle partial failures in multiple signals', () async {
        // Arrange
        int callCount = 0;
        
        when( mockFunctionsClient.invoke(
          'trading-signals',
          body: anyNamed('body'),
        )).thenAnswer((_) async {
          callCount++;
          if (callCount == 2) {
            throw Exception('API error for second symbol');
          }
          
          final mockResponse = MockFunctionResponse();
          final signalData = <String, dynamic>{
            'signal': <String, dynamic>{
              'action': 'buy',
              'confidence': 0.8,
              'reasoning': 'Bullish signal',
              'indicators': <String, dynamic>{}
            }
          };
          when( mockResponse.data).thenReturn(signalData);
          return mockResponse;
        });

        // Act
        final signals = await tradingService.getMultipleSignals(
          symbols: ['AAPL', 'GOOGL', 'MSFT'],
          strategy: TradingStrategy.jesseLivermore,
        );

        // Assert
        expect(signals.length, equals(2)); // Only 2 successful
        expect(signals.any((s) => s.symbol == 'GOOGL'), isFalse);
      });
    });

    group('TradingSignal Model', () {
      test('should calculate confidence percentage', () {
        final signal = TradingSignal(
          action: SignalAction.buy,
          confidence: 0.85,
          reasoning: 'Test',
          indicators: {},
        );

        expect(signal.confidencePercent, equals('85%'));
      });

      test('should calculate expected return', () {
        final signal = TradingSignal(
          action: SignalAction.buy,
          confidence: 0.8,
          entryPrice: 100.0,
          targetPrice: 110.0,
          reasoning: 'Test',
          indicators: {},
        );

        expect(signal.expectedReturn, equals(10.0));
      });

      test('should handle null expected return', () {
        final signal = TradingSignal(
          action: SignalAction.hold,
          confidence: 0.5,
          reasoning: 'Test',
          indicators: {},
        );

        expect(signal.expectedReturn, isNull);
      });

      test('should calculate risk percentage', () {
        final signal = TradingSignal(
          action: SignalAction.buy,
          confidence: 0.8,
          entryPrice: 100.0,
          stopLoss: 95.0,
          reasoning: 'Test',
          indicators: {},
        );

        expect(signal.riskPercent, equals(5.0));
      });

      test('should handle null risk percentage', () {
        final signal = TradingSignal(
          action: SignalAction.hold,
          confidence: 0.5,
          reasoning: 'Test',
          indicators: {},
        );

        expect(signal.riskPercent, isNull);
      });
    });

    group('TradingStrategy Enum', () {
      test('should have correct values', () {
        expect(TradingStrategy.jesseLivermore.value, equals('jesse_livermore'));
        expect(TradingStrategy.jesseLivermore.displayName, equals('Jesse Livermore'));
        expect(TradingStrategy.jesseLivermore.description, equals('추세 추종 전략'));

        expect(TradingStrategy.larryWilliams.value, equals('larry_williams'));
        expect(TradingStrategy.larryWilliams.displayName, equals('Larry Williams'));
        expect(TradingStrategy.larryWilliams.description, equals('단기 모멘텀 전략'));

        expect(TradingStrategy.stanWeinstein.value, equals('stan_weinstein'));
        expect(TradingStrategy.stanWeinstein.displayName, equals('Stan Weinstein'));
        expect(TradingStrategy.stanWeinstein.description, equals('스테이지 분석 전략'));
      });
    });

    group('SignalAction Enum', () {
      test('should convert from string correctly', () {
        expect(SignalAction.fromString('buy'), equals(SignalAction.buy));
        expect(SignalAction.fromString('sell'), equals(SignalAction.sell));
        expect(SignalAction.fromString('hold'), equals(SignalAction.hold));
        expect(SignalAction.fromString('unknown'), equals(SignalAction.hold)); // Default
      });

      test('should have correct Korean translations', () {
        expect(SignalAction.buy.korean, equals('매수'));
        expect(SignalAction.sell.korean, equals('매도'));
        expect(SignalAction.hold.korean, equals('보유'));
      });
    });
  });
}