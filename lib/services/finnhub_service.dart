import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candle_data.dart';
import '../config/env_config.dart';

class FinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static String get _apiKey => EnvConfig.finnhubApiKey;
  
  Future<List<CandleData>> getStockCandles({
    required String symbol,
    required DateTime from,
    required DateTime to,
    String resolution = 'D', // D=일봉, W=주봉, M=월봉, 1=1분봉, 5=5분봉 등
  }) async {
    try {
      final fromTimestamp = (from.millisecondsSinceEpoch / 1000).round();
      final toTimestamp = (to.millisecondsSinceEpoch / 1000).round();
      
      final url = Uri.parse(
        '$_baseUrl/stock/candle?symbol=$symbol&resolution=$resolution'
        '&from=$fromTimestamp&to=$toTimestamp&token=$_apiKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['s'] == 'ok' && data['t'] != null) {
          final List<CandleData> candles = [];
          
          for (int i = 0; i < data['t'].length; i++) {
            candles.add(CandleData(
              date: DateTime.fromMillisecondsSinceEpoch(
                data['t'][i] * 1000,
              ),
              open: data['o'][i].toDouble(),
              high: data['h'][i].toDouble(),
              low: data['l'][i].toDouble(),
              close: data['c'][i].toDouble(),
              volume: data['v'][i].toDouble(),
            ));
          }
          
          return candles;
        }
      }
      
      // 데이터를 가져올 수 없는 경우 빈 리스트 반환
      return [];
    } catch (e) {
      print('Error fetching stock data: $e');
      return [];
    }
  }
  
  // 실시간 가격 가져오기
  Future<double?> getCurrentPrice(String symbol) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/quote?symbol=$symbol&token=$_apiKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['c']?.toDouble(); // 현재가
      }
    } catch (e) {
      print('Error fetching current price: $e');
    }
    
    return null;
  }

  // 주식 상세 정보 가져오기
  Future<Map<String, dynamic>> getStockQuote(String symbol) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/quote?symbol=$symbol&token=$_apiKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'c': data['c']?.toDouble() ?? 0.0,  // 현재가
          'd': data['d']?.toDouble() ?? 0.0,  // 변동액
          'dp': data['dp']?.toDouble() ?? 0.0, // 변동률
          'h': data['h']?.toDouble() ?? 0.0,  // 고가
          'l': data['l']?.toDouble() ?? 0.0,  // 저가
          'o': data['o']?.toDouble() ?? 0.0,  // 시가
          'pc': data['pc']?.toDouble() ?? 0.0, // 전일 종가
          't': data['t'] ?? 0,  // 타임스탬프
          'volume': data['v'] ?? 0,  // 거래량
        };
      }
    } catch (e) {
      print('Error fetching stock quote: $e');
    }
    
    // 에러 시 기본값 반환
    return {
      'c': 0.0,
      'd': 0.0,
      'dp': 0.0,
      'h': 0.0,
      'l': 0.0,
      'o': 0.0,
      'pc': 0.0,
      't': 0,
      'volume': 0,
    };
  }

  // 주식 심볼 검색
  Future<List<Map<String, dynamic>>> searchSymbol(String query) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/search?q=$query&token=$_apiKey'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['result'] as List<dynamic>? ?? [];
        
        return results.map((item) => {
          'symbol': item['symbol'] ?? '',
          'description': item['description'] ?? '',
          'displaySymbol': item['displaySymbol'] ?? item['symbol'] ?? '',
          'type': item['type'] ?? '',
        }).toList();
      }
    } catch (e) {
      print('Error searching symbols: $e');
    }
    
    return [];
  }
}