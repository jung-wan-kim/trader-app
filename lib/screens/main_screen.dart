import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'position_screen.dart';
import 'investment_performance_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/real_time_price_service.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const PositionScreen(),
    const InvestmentPerformanceScreen(),
    const WatchlistScreen(),
    const ProfileScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    // 실시간 가격 업데이트 서비스 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(realTimePriceProvider);
    });
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // 상태 표시줄 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade800,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xFF00D632),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.show_chart_outlined, size: 26),
              activeIcon: const Icon(Icons.show_chart, size: 26),
              label: l10n?.signals ?? 'Signals',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 26),
              activeIcon: const Icon(Icons.account_balance_wallet, size: 26),
              label: l10n?.portfolio ?? 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.analytics_outlined, size: 26),
              activeIcon: const Icon(Icons.analytics, size: 26),
              label: l10n?.investmentPerformance ?? 'Performance',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark_outline, size: 26),
              activeIcon: const Icon(Icons.bookmark, size: 26),
              label: l10n?.watchlist ?? 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline, size: 26),
              activeIcon: const Icon(Icons.person, size: 26),
              label: l10n?.profile ?? 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}