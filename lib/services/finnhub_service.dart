import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candle_data.dart';

class FinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = 'cs2m9k9r01qt4r9kq970cs2m9k9r01qt4r9kq97g'; // 무료 테스트 키
  
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
}