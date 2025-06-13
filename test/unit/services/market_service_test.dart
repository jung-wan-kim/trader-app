import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/services/market_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SupabaseClient, FunctionsClient, FunctionResponse])
import 'market_service_test.mocks.dart';

void main() {
  group('MarketService Tests', () {
    late MarketService marketService;
    late MockSupabaseClient mockSupabaseClient;
    late MockFunctionsClient mockFunctionsClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockFunctionsClient = MockFunctionsClient();
      
      when(mockSupabaseClient.functions).thenReturn(mockFunctionsClient);
      
      marketService = MarketService(mockSupabaseClient);
    });

    group('Stock Quote', () {
      test('should get stock quote successfully', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final quoteData = <String, dynamic>{
          'data': <String, dynamic>{
            'c': 150.25,
            'd': 2.50,
            'dp': 1.69,
            'h': 152.00,
            'l': 148.50,
            'o': 149.00,
            'pc': 147.75,
            't': 1704067200,
          }
        };
        
        when(mockResponse.data).thenReturn(quoteData);
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final quote = await marketService.getQuote('AAPL');

        // Assert
        expect(quote, isA<StockQuote>());
        expect(quote.symbol, equals('AAPL'));
        expect(quote.currentPrice, equals(150.25));
        expect(quote.change, equals(2.50));
        expect(quote.changePercent, equals(1.69));
        expect(quote.high, equals(152.00));
        expect(quote.low, equals(148.50));
        expect(quote.open, equals(149.00));
        expect(quote.previousClose, equals(147.75));
      });

      test('should handle negative price change', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final quoteData = <String, dynamic>{
          'data': <String, dynamic>{
            'c': 145.00,
            'd': -2.75,
            'dp': -1.86,
            'h': 148.50,
            'l': 144.50,
            'o': 147.75,
            'pc': 147.75,
            't': 1704067200,
          }
        };
        
        when(mockResponse.data).thenReturn(quoteData);
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final quote = await marketService.getQuote('AAPL');

        // Assert
        expect(quote.isPositive, isFalse);
        expect(quote.formattedChange, equals('-2.75'));
        expect(quote.formattedChangePercent, equals('-1.86%'));
      });

      test('should handle error when no data received', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        when(mockResponse.data).thenReturn(null);
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => marketService.getQuote('AAPL'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No data received'),
          )),
        );
      });

      test('should handle API error', () async {
        // Arrange
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => marketService.getQuote('AAPL'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to fetch quote'),
          )),
        );
      });
    });

    group('Multiple Quotes', () {
      test('should get multiple quotes successfully', () async {
        // Arrange
        final quoteData = <String, dynamic>{
          'data': <String, dynamic>{
            'c': 150.25,
            'd': 2.50,
            'dp': 1.69,
            'h': 152.00,
            'l': 148.50,
            'o': 149.00,
            'pc': 147.75,
            't': 1704067200,
          }
        };
        
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async {
          final mockResponse = MockFunctionResponse();
          when(mockResponse.data).thenReturn(quoteData);
          return mockResponse;
        });

        // Act
        final quotes = await marketService.getMultipleQuotes(['AAPL', 'GOOGL', 'MSFT']);

        // Assert
        expect(quotes.length, equals(3));
        expect(quotes[0].symbol, equals('AAPL'));
        expect(quotes[1].symbol, equals('GOOGL'));
        expect(quotes[2].symbol, equals('MSFT'));
      });

      test('should handle partial failures in multiple quotes', () async {
        // Arrange
        int callCount = 0;
        
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async {
          callCount++;
          if (callCount == 2) {
            throw Exception('API error for second symbol');
          }
          
          final mockResponse = MockFunctionResponse();
          final quoteData = <String, dynamic>{
            'data': <String, dynamic>{
              'c': 150.25,
              'd': 2.50,
              'dp': 1.69,
              'h': 152.00,
              'l': 148.50,
              'o': 149.00,
              'pc': 147.75,
              't': 1704067200,
            }
          };
          when(mockResponse.data).thenReturn(quoteData);
          return mockResponse;
        });

        // Act
        final quotes = await marketService.getMultipleQuotes(['AAPL', 'GOOGL', 'MSFT']);

        // Assert
        expect(quotes.length, equals(2)); // Only 2 successful
      });
    });

    group('Company Profile', () {
      test('should get company profile successfully', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final profileData = <String, dynamic>{
          'data': <String, dynamic>{
            'ticker': 'AAPL',
            'name': 'Apple Inc',
            'country': 'US',
            'currency': 'USD',
            'exchange': 'NASDAQ',
            'finnhubIndustry': 'Technology',
            'logo': 'https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png',
            'weburl': 'https://www.apple.com/',
            'marketCapitalization': 3000000.0,
          }
        };
        
        when(mockResponse.data).thenReturn(profileData);
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final profile = await marketService.getCompanyProfile('AAPL');

        // Assert
        expect(profile, isA<CompanyProfile>());
        expect(profile.ticker, equals('AAPL'));
        expect(profile.name, equals('Apple Inc'));
        expect(profile.country, equals('US'));
        expect(profile.currency, equals('USD'));
        expect(profile.exchange, equals('NASDAQ'));
        expect(profile.industry, equals('Technology'));
        expect(profile.marketCap, equals(3000000.0));
      });

      test('should handle missing profile data', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final profileData = <String, dynamic>{
          'data': <String, dynamic>{
            'ticker': 'XYZ',
            'name': 'Unknown Company',
            // Missing other fields
          }
        };
        
        when(mockResponse.data).thenReturn(profileData);
        when(mockFunctionsClient.invoke(
          'market-data',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final profile = await marketService.getCompanyProfile('XYZ');

        // Assert
        expect(profile.ticker, equals('XYZ'));
        expect(profile.name, equals('Unknown Company'));
        expect(profile.country, equals(''));
        expect(profile.currency, equals('USD')); // Default value
        expect(profile.marketCap, equals(0.0));
      });
    });

    group('StockQuote Model', () {
      test('should format positive price correctly', () {
        final quote = StockQuote(
          symbol: 'AAPL',
          currentPrice: 150.25,
          change: 2.50,
          changePercent: 1.69,
          high: 152.00,
          low: 148.50,
          open: 149.00,
          previousClose: 147.75,
          timestamp: 1704067200,
        );

        expect(quote.isPositive, isTrue);
        expect(quote.formattedPrice, equals('\$150.25'));
        expect(quote.formattedChange, equals('+2.50'));
        expect(quote.formattedChangePercent, equals('+1.69%'));
      });

      test('should format negative price correctly', () {
        final quote = StockQuote(
          symbol: 'AAPL',
          currentPrice: 145.00,
          change: -2.75,
          changePercent: -1.86,
          high: 148.50,
          low: 144.50,
          open: 147.75,
          previousClose: 147.75,
          timestamp: 1704067200,
        );

        expect(quote.isPositive, isFalse);
        expect(quote.formattedPrice, equals('\$145.00'));
        expect(quote.formattedChange, equals('-2.75'));
        expect(quote.formattedChangePercent, equals('-1.86%'));
      });

      test('should handle zero change', () {
        final quote = StockQuote(
          symbol: 'AAPL',
          currentPrice: 150.00,
          change: 0.0,
          changePercent: 0.0,
          high: 150.50,
          low: 149.50,
          open: 150.00,
          previousClose: 150.00,
          timestamp: 1704067200,
        );

        expect(quote.isPositive, isTrue); // 0 is considered positive
        expect(quote.formattedChange, equals('+0.00'));
        expect(quote.formattedChangePercent, equals('+0.00%'));
      });
    });

    group('CompanyProfile Model', () {
      test('should format market cap in trillions', () {
        final profile = CompanyProfile(
          ticker: 'AAPL',
          name: 'Apple Inc',
          country: 'US',
          currency: 'USD',
          exchange: 'NASDAQ',
          industry: 'Technology',
          logo: 'logo.png',
          weburl: 'apple.com',
          marketCap: 3000000.0, // 3T
        );

        expect(profile.formattedMarketCap, equals('\$3.00T'));
      });

      test('should format market cap in billions', () {
        final profile = CompanyProfile(
          ticker: 'XYZ',
          name: 'XYZ Corp',
          country: 'US',
          currency: 'USD',
          exchange: 'NYSE',
          industry: 'Finance',
          logo: 'logo.png',
          weburl: 'xyz.com',
          marketCap: 50000.0, // 50B
        );

        expect(profile.formattedMarketCap, equals('\$50.00B'));
      });

      test('should format market cap in millions', () {
        final profile = CompanyProfile(
          ticker: 'ABC',
          name: 'ABC Ltd',
          country: 'US',
          currency: 'USD',
          exchange: 'NASDAQ',
          industry: 'Healthcare',
          logo: 'logo.png',
          weburl: 'abc.com',
          marketCap: 500.0, // 500M
        );

        expect(profile.formattedMarketCap, equals('\$500.00M'));
      });
    });
  });
}