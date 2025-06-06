import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_data_service.dart';

// MockDataService를 Provider로 제공
final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});