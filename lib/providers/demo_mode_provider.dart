import 'package:flutter_riverpod/flutter_riverpod.dart';

// Demo 모드 상태를 관리하는 Provider
final demoModeProvider = StateProvider<bool>((ref) => false);

// Demo 모드 설정을 변경하는 Notifier
class DemoModeNotifier extends StateNotifier<bool> {
  DemoModeNotifier() : super(false);

  void toggleDemoMode() {
    state = !state;
  }

  void setDemoMode(bool value) {
    state = value;
  }
}

final demoModeNotifierProvider = StateNotifierProvider<DemoModeNotifier, bool>((ref) {
  return DemoModeNotifier();
});

// Demo 모드일 때 제한된 기능을 나타내는 Helper Provider
final isFeatureAvailableProvider = Provider.family<bool, String>((ref, feature) {
  final isDemoMode = ref.watch(demoModeProvider);
  
  if (!isDemoMode) return true;
  
  // Demo 모드에서 허용되는 기능들
  const allowedFeaturesInDemo = [
    'view_recommendations',
    'view_portfolio',
    'view_charts',
    'view_positions',
  ];
  
  return allowedFeaturesInDemo.contains(feature);
});