# Frontend Developer 테스트 설계

## 1. 컴포넌트 단위 테스트 설계

### 1.1 위젯 Props/State 테스트

#### RecommendationCard 위젯
```dart
// Props 테스트
- recommendation: StockRecommendation 객체의 모든 필드 검증
- onTap: 콜백 함수 호출 여부 확인
- 필수 props 누락 시 에러 처리

// State 테스트  
- 시간 경과에 따른 "time ago" 표시 업데이트
- 가격 변동에 따른 수익률 색상 변경
- 위험도에 따른 배지 색상 변경
```

#### PositionSizeCalculator 위젯
```dart
// Props 테스트
- initialCapital: 초기 자본금 설정 검증
- riskPercentage: 리스크 비율 범위 검증 (0-100%)
- stockPrice: 음수 값 처리

// State 테스트
- 입력값 변경에 따른 계산 결과 실시간 업데이트
- 유효하지 않은 입력에 대한 에러 상태 관리
- 계산 중 로딩 상태 표시
```

#### CandleChart 위젯
```dart
// Props 테스트
- candleData: 빈 배열, null 데이터 처리
- chartType: 캔들/라인 차트 전환
- indicators: 다중 인디케이터 표시

// State 테스트
- 줌/팬 제스처에 따른 차트 스케일 변경
- 실시간 데이터 추가 시 차트 업데이트
- 인디케이터 토글 상태 관리
```

### 1.2 이벤트 핸들러 테스트

```dart
// 탭 이벤트
testWidgets('recommendation card tap should navigate to detail', (tester) async {
  var navigatedToDetail = false;
  
  await tester.pumpWidget(
    RecommendationCard(
      recommendation: mockRecommendation,
      onTap: () => navigatedToDetail = true,
    ),
  );
  
  await tester.tap(find.byType(RecommendationCard));
  expect(navigatedToDetail, isTrue);
});

// 스와이프 이벤트
testWidgets('position card swipe should show delete option', (tester) async {
  await tester.pumpWidget(PositionCard(position: mockPosition));
  
  await tester.drag(
    find.byType(PositionCard),
    const Offset(-200, 0),
  );
  await tester.pumpAndSettle();
  
  expect(find.byIcon(Icons.delete), findsOneWidget);
});

// 롱프레스 이벤트
testWidgets('stock item long press should show context menu', (tester) async {
  await tester.pumpWidget(StockListItem(stock: mockStock));
  
  await tester.longPress(find.byType(StockListItem));
  await tester.pumpAndSettle();
  
  expect(find.text('Add to Watchlist'), findsOneWidget);
  expect(find.text('Set Alert'), findsOneWidget);
});
```

### 1.3 조건부 렌더링 테스트

```dart
// 로딩 상태
testWidgets('should show loading indicator when data is loading', (tester) async {
  when(mockProvider.state).thenReturn(AsyncValue.loading());
  
  await tester.pumpWidget(StockListScreen());
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.byType(StockListItem), findsNothing);
});

// 에러 상태
testWidgets('should show error message when data fetch fails', (tester) async {
  when(mockProvider.state).thenReturn(
    AsyncValue.error('Network error', StackTrace.current),
  );
  
  await tester.pumpWidget(StockListScreen());
  
  expect(find.text('Failed to load stocks'), findsOneWidget);
  expect(find.byType(RetryButton), findsOneWidget);
});

// 빈 상태
testWidgets('should show empty state when no data', (tester) async {
  when(mockProvider.state).thenReturn(AsyncValue.data([]));
  
  await tester.pumpWidget(WatchlistScreen());
  
  expect(find.text('No stocks in your watchlist'), findsOneWidget);
  expect(find.byType(AddStockButton), findsOneWidget);
});

// 권한 기반 렌더링
testWidgets('should show premium features only for subscribed users', (tester) async {
  when(mockUserProvider.isPremium).thenReturn(false);
  
  await tester.pumpWidget(StrategyDetailScreen());
  
  expect(find.text('Upgrade to Premium'), findsOneWidget);
  expect(find.byType(AdvancedChart), findsNothing);
});
```

### 1.4 에러 바운더리 테스트

```dart
// 위젯 에러 처리
testWidgets('should catch and display widget errors gracefully', (tester) async {
  await tester.pumpWidget(
    ErrorBoundary(
      child: BrokenWidget(), // 의도적으로 에러를 발생시키는 위젯
    ),
  );
  
  expect(find.text('Something went wrong'), findsOneWidget);
  expect(find.byType(ReloadButton), findsOneWidget);
});

// 비동기 에러 처리
testWidgets('should handle async errors in data fetching', (tester) async {
  final errorController = StreamController<Error>();
  
  await tester.pumpWidget(
    StreamBuilder(
      stream: errorController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return Container();
      },
    ),
  );
  
  errorController.add(Exception('API Error'));
  await tester.pump();
  
  expect(find.byType(ErrorWidget), findsOneWidget);
});
```

## 2. 상태 관리 테스트

### 2.1 Riverpod Provider 테스트

```dart
// Provider 초기화 테스트
test('portfolioProvider should initialize with loading state', () {
  final container = ProviderContainer();
  
  final state = container.read(portfolioProvider);
  expect(state, isA<AsyncLoading>());
});

// Provider 상태 변경 테스트
test('portfolioProvider should update when position is added', () async {
  final container = ProviderContainer();
  final notifier = container.read(portfolioProvider.notifier);
  
  await notifier.openPosition(mockRecommendation, 100);
  
  final state = container.read(portfolioProvider);
  state.whenData((positions) {
    expect(positions.length, equals(1));
    expect(positions.first.stockCode, equals(mockRecommendation.stockCode));
  });
});

// Provider 의존성 테스트
test('portfolioStatsProvider should update when positions change', () {
  final container = ProviderContainer(
    overrides: [
      portfolioProvider.overrideWith((ref) => 
        PortfolioNotifier(MockDataService())..state = AsyncValue.data(mockPositions)
      ),
    ],
  );
  
  final stats = container.read(portfolioStatsProvider);
  expect(stats.totalValue, greaterThan(0));
  expect(stats.openPositions, equals(mockPositions.length));
});
```

### 2.2 상태 변경에 따른 UI 업데이트

```dart
// 실시간 가격 업데이트
testWidgets('position card should update when price changes', (tester) async {
  final priceController = StreamController<double>();
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        stockPriceProvider.overrideWith((ref, stockCode) => 
          priceController.stream
        ),
      ],
      child: PositionCard(position: mockPosition),
    ),
  );
  
  expect(find.text('\$100.00'), findsOneWidget);
  
  priceController.add(105.00);
  await tester.pump();
  
  expect(find.text('\$105.00'), findsOneWidget);
  expect(find.text('+5.00%'), findsOneWidget);
});

// 다국어 변경
testWidgets('UI should update when language changes', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(),
      ),
    ),
  );
  
  expect(find.text('Watchlist'), findsOneWidget);
  
  // 언어 변경
  final container = ProviderScope.containerOf(
    tester.element(find.byType(HomeScreen)),
  );
  container.read(languageProvider.notifier).setLocale(Locale('ko'));
  await tester.pumpAndSettle();
  
  expect(find.text('관심목록'), findsOneWidget);
});
```

### 2.3 비동기 상태 처리

```dart
// 로딩 상태 관리
testWidgets('should show skeleton while loading recommendations', (tester) async {
  final completer = Completer<List<StockRecommendation>>();
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        recommendationsProvider.overrideWith((ref) =>
          RecommendationsNotifier()..loadRecommendations(completer.future)
        ),
      ],
      child: RecommendationsScreen(),
    ),
  );
  
  // 로딩 중
  expect(find.byType(SkeletonLoader), findsWidgets);
  
  // 데이터 로드 완료
  completer.complete(mockRecommendations);
  await tester.pumpAndSettle();
  
  expect(find.byType(RecommendationCard), findsWidgets);
  expect(find.byType(SkeletonLoader), findsNothing);
});

// 에러 상태 복구
testWidgets('should retry loading on error', (tester) async {
  var attemptCount = 0;
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        stockDataProvider.overrideWith((ref, stockCode) async {
          attemptCount++;
          if (attemptCount == 1) {
            throw Exception('Network error');
          }
          return mockStockData;
        }),
      ],
      child: StockDetailScreen(stockCode: 'AAPL'),
    ),
  );
  
  // 첫 시도 실패
  await tester.pumpAndSettle();
  expect(find.text('Failed to load'), findsOneWidget);
  
  // 재시도
  await tester.tap(find.text('Retry'));
  await tester.pumpAndSettle();
  
  expect(find.text('Apple Inc.'), findsOneWidget);
  expect(attemptCount, equals(2));
});
```

### 2.4 전역 상태와 로컬 상태 동기화

```dart
// 전역 상태와 폼 상태 동기화
testWidgets('form should sync with global settings', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: SettingsScreen(),
    ),
  );
  
  // 전역 설정 확인
  final container = ProviderScope.containerOf(
    tester.element(find.byType(SettingsScreen)),
  );
  final globalSettings = container.read(settingsProvider);
  
  // 폼 필드에 반영 확인
  final riskField = find.byKey(Key('risk-percentage-field'));
  expect(
    tester.widget<TextField>(riskField).controller?.text,
    equals(globalSettings.defaultRiskPercentage.toString()),
  );
  
  // 폼 변경이 전역 상태에 반영
  await tester.enterText(riskField, '5');
  await tester.tap(find.text('Save'));
  await tester.pump();
  
  expect(
    container.read(settingsProvider).defaultRiskPercentage,
    equals(5.0),
  );
});

// 캐시와 서버 데이터 동기화
test('should sync cache with server data', () async {
  final container = ProviderContainer();
  final stockCache = container.read(stockCacheProvider);
  
  // 캐시된 데이터
  stockCache.set('AAPL', oldMockData);
  
  // 서버에서 새 데이터 가져오기
  await container.read(stockDataProvider('AAPL').future);
  
  // 캐시 업데이트 확인
  final cachedData = stockCache.get('AAPL');
  expect(cachedData?.lastUpdate, isAfter(oldMockData.lastUpdate));
});
```

## 3. 성능 테스트 메트릭

### 3.1 렌더링 성능 (FPS, Jank)

```dart
// 스크롤 성능 테스트
testWidgets('list should maintain 60fps during scroll', (tester) async {
  final items = List.generate(1000, (i) => StockItem(id: i));
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => StockListTile(item: items[index]),
        ),
      ),
    ),
  );
  
  final timeline = await tester.traceAction(() async {
    await tester.fling(
      find.byType(ListView),
      const Offset(0, -5000),
      3000,
    );
    await tester.pumpAndSettle();
  });
  
  final summary = TimelineSummary.summarize(timeline);
  
  // 평균 프레임 빌드 시간이 16ms 이하여야 함 (60fps)
  expect(summary.computeAverageFrameBuildTimeMillis(), lessThan(16));
  
  // Jank 프레임이 전체의 5% 이하여야 함
  expect(summary.computePercentileFrameBuildTimeMillis(95), lessThan(16));
});

// 애니메이션 성능 테스트
testWidgets('chart animation should be smooth', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CandleChart(
        data: generateLargeCandleData(1000),
        animated: true,
      ),
    ),
  );
  
  final timeline = await tester.traceAction(() async {
    // 차트 애니메이션 트리거
    await tester.tap(find.byType(CandleChart));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });
  
  final summary = TimelineSummary.summarize(timeline);
  expect(summary.countJankyFrames(), equals(0));
});
```

### 3.2 메모리 사용량

```dart
// 메모리 릭 테스트
test('providers should not cause memory leaks', () async {
  final weakRefs = <WeakReference>[];
  
  // Provider 생성 및 참조 저장
  for (int i = 0; i < 100; i++) {
    final container = ProviderContainer();
    weakRefs.add(WeakReference(container));
    
    // Provider 사용
    await container.read(portfolioProvider.future);
    
    // 정리
    container.dispose();
  }
  
  // 가비지 컬렉션 강제 실행
  await Future.delayed(Duration(milliseconds: 100));
  
  // 모든 참조가 해제되었는지 확인
  final aliveCount = weakRefs.where((ref) => ref.target != null).length;
  expect(aliveCount, equals(0));
});

// 이미지 메모리 관리
testWidgets('images should be disposed when widget is removed', (tester) async {
  final imageCache = PaintingBinding.instance.imageCache;
  final initialCount = imageCache.currentSize;
  
  await tester.pumpWidget(
    MaterialApp(
      home: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) => Image.network(
          'https://example.com/chart_$index.png',
        ),
      ),
    ),
  );
  
  // 이미지 로드
  await tester.pump(Duration(seconds: 2));
  final loadedCount = imageCache.currentSize;
  expect(loadedCount, greaterThan(initialCount));
  
  // 위젯 제거
  await tester.pumpWidget(Container());
  await tester.pump(Duration(seconds: 1));
  
  // 메모리 해제 확인
  expect(imageCache.currentSize, lessThan(loadedCount));
});
```

### 3.3 번들 크기

```dart
// 코드 스플리팅 테스트
test('lazy loaded modules should reduce initial bundle', () async {
  final initialBundleSize = await measureBundleSize(['lib/main.dart']);
  
  final deferredBundleSize = await measureBundleSize([
    'lib/main.dart',
    '--split-debug-info=build/debug_info',
    '--obfuscate',
  ]);
  
  // 지연 로딩으로 초기 번들 크기 감소
  expect(deferredBundleSize, lessThan(initialBundleSize * 0.7));
});

// 트리 쉐이킹 효과 측정
test('unused code should be removed in production build', () async {
  final debugSize = await measureBundleSize(['--debug']);
  final releaseSize = await measureBundleSize(['--release']);
  
  // 릴리즈 빌드가 디버그 빌드의 50% 이하
  expect(releaseSize, lessThan(debugSize * 0.5));
});
```

### 3.4 초기 로딩 시간

```dart
// 앱 시작 시간 측정
testWidgets('app should start within 2 seconds', (tester) async {
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(MyApp());
  
  // 스플래시 스크린 표시
  expect(find.byType(SplashScreen), findsOneWidget);
  
  // 메인 화면 로드 대기
  await tester.pumpAndSettle(
    const Duration(seconds: 5),
    EnginePhase.build,
  );
  
  stopwatch.stop();
  
  expect(find.byType(MainScreen), findsOneWidget);
  expect(stopwatch.elapsedMilliseconds, lessThan(2000));
});

// 초기 데이터 로드 시간
testWidgets('initial data should load quickly', (tester) async {
  final loadTimes = <String, int>{};
  
  await tester.pumpWidget(
    ProviderScope(
      observers: [LoadTimeObserver(loadTimes)],
      child: MyApp(),
    ),
  );
  
  await tester.pumpAndSettle();
  
  // 각 Provider의 로드 시간 확인
  expect(loadTimes['portfolioProvider']!, lessThan(500));
  expect(loadTimes['recommendationsProvider']!, lessThan(1000));
  expect(loadTimes['marketDataProvider']!, lessThan(300));
});
```

## 4. API 통합 테스트

### 4.1 API 호출과 UI 업데이트

```dart
// 실시간 가격 업데이트
testWidgets('stock price should update in real-time', (tester) async {
  final mockWebSocket = MockWebSocketChannel();
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        webSocketProvider.overrideWithValue(mockWebSocket),
      ],
      child: StockPriceWidget(stockCode: 'AAPL'),
    ),
  );
  
  // 초기 가격
  expect(find.text('\$150.00'), findsOneWidget);
  
  // WebSocket 메시지 수신
  mockWebSocket.sink.add(json.encode({
    'type': 'price_update',
    'stockCode': 'AAPL',
    'price': 152.50,
  }));
  
  await tester.pump();
  
  // UI 업데이트 확인
  expect(find.text('\$152.50'), findsOneWidget);
  expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
});

// 페이지네이션
testWidgets('should load more items when scrolled to bottom', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: InfiniteStockList(),
    ),
  );
  
  // 초기 아이템
  expect(find.byType(StockListItem), findsNWidgets(20));
  
  // 스크롤 to bottom
  await tester.drag(find.byType(ListView), const Offset(0, -1000));
  await tester.pump();
  
  // 로딩 인디케이터
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  await tester.pumpAndSettle();
  
  // 추가 아이템 로드
  expect(find.byType(StockListItem), findsNWidgets(40));
});
```

### 4.2 로딩/에러/성공 상태 처리

```dart
// 로딩 상태 시퀀스
testWidgets('should show proper loading sequence', (tester) async {
  final controller = StreamController<ApiState>();
  
  await tester.pumpWidget(
    StreamBuilder<ApiState>(
      stream: controller.stream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? ApiState.initial();
        
        return switch (state) {
          ApiInitial() => Text('Ready'),
          ApiLoading() => CircularProgressIndicator(),
          ApiSuccess(data: var data) => Text('Success: $data'),
          ApiError(message: var msg) => Text('Error: $msg'),
        };
      },
    ),
  );
  
  // 초기 상태
  expect(find.text('Ready'), findsOneWidget);
  
  // 로딩 시작
  controller.add(ApiState.loading());
  await tester.pump();
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  // 성공
  controller.add(ApiState.success('Data loaded'));
  await tester.pump();
  expect(find.text('Success: Data loaded'), findsOneWidget);
  
  // 에러
  controller.add(ApiState.error('Network error'));
  await tester.pump();
  expect(find.text('Error: Network error'), findsOneWidget);
});

// 에러 복구 메커니즘
testWidgets('should handle API errors gracefully', (tester) async {
  var retryCount = 0;
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiServiceProvider.overrideWith((ref) => MockApiService(
          onRequest: () {
            retryCount++;
            if (retryCount < 3) throw NetworkException();
            return mockData;
          },
        )),
      ],
      child: DataScreen(),
    ),
  );
  
  // 자동 재시도 진행
  await tester.pump(Duration(seconds: 1)); // 1차 시도
  await tester.pump(Duration(seconds: 2)); // 2차 시도 (백오프)
  await tester.pump(Duration(seconds: 4)); // 3차 시도 (백오프)
  
  await tester.pumpAndSettle();
  
  // 성공 후 데이터 표시
  expect(find.text(mockData.title), findsOneWidget);
  expect(retryCount, equals(3));
});
```

### 4.3 캐싱 및 옵티미스틱 업데이트

```dart
// 옵티미스틱 업데이트
testWidgets('should update UI optimistically', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: TodoListScreen(),
    ),
  );
  
  // 새 아이템 추가
  await tester.enterText(find.byType(TextField), 'New Task');
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  // 즉시 UI 업데이트 (서버 응답 대기 안함)
  expect(find.text('New Task'), findsOneWidget);
  expect(find.byIcon(Icons.sync), findsOneWidget); // 동기화 중 표시
  
  // 서버 응답 후
  await tester.pumpAndSettle();
  expect(find.byIcon(Icons.sync), findsNothing); // 동기화 완료
});

// 캐시 우선 전략
testWidgets('should show cached data while fetching fresh data', (tester) async {
  final cache = InMemoryCache();
  cache.write('stocks', oldStockData);
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        cacheProvider.overrideWithValue(cache),
      ],
      child: StockListScreen(),
    ),
  );
  
  // 캐시된 데이터 즉시 표시
  expect(find.text('Cached: ${oldStockData.length} stocks'), findsOneWidget);
  
  // 백그라운드에서 새 데이터 가져오기
  expect(find.byType(RefreshIndicator), findsOneWidget);
  
  await tester.pumpAndSettle();
  
  // 새 데이터로 업데이트
  expect(find.text('Updated: ${newStockData.length} stocks'), findsOneWidget);
});

// 캐시 무효화
test('should invalidate cache on user action', () async {
  final container = ProviderContainer();
  final cache = container.read(cacheProvider);
  
  // 캐시에 데이터 저장
  cache.write('portfolio', mockPortfolio);
  expect(cache.read('portfolio'), isNotNull);
  
  // 포지션 수정
  await container.read(portfolioProvider.notifier).closePosition('pos1');
  
  // 관련 캐시 무효화
  expect(cache.read('portfolio'), isNull);
  expect(cache.read('portfolio_stats'), isNull);
});
```

### 4.4 실시간 데이터 업데이트

```dart
// WebSocket 연결 관리
testWidgets('should handle WebSocket lifecycle', (tester) async {
  final wsController = StreamController<dynamic>.broadcast();
  var connectionState = 'disconnected';
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        webSocketProvider.overrideWith((ref) => MockWebSocket(
          onConnect: () => connectionState = 'connected',
          onDisconnect: () => connectionState = 'disconnected',
          stream: wsController.stream,
        )),
      ],
      child: RealtimeScreen(),
    ),
  );
  
  // 자동 연결
  await tester.pumpAndSettle();
  expect(connectionState, equals('connected'));
  expect(find.byIcon(Icons.wifi), findsOneWidget);
  
  // 연결 끊김 시뮬레이션
  wsController.addError(WebSocketException('Connection lost'));
  await tester.pump();
  
  expect(find.byIcon(Icons.wifi_off), findsOneWidget);
  expect(find.text('Reconnecting...'), findsOneWidget);
  
  // 자동 재연결
  await tester.pump(Duration(seconds: 5));
  expect(connectionState, equals('connected'));
});

// 실시간 차트 업데이트
testWidgets('chart should update with streaming data', (tester) async {
  final priceStream = StreamController<CandleData>.broadcast();
  
  await tester.pumpWidget(
    StreamBuilder<List<CandleData>>(
      stream: priceStream.stream.scan(
        (accumulated, value, index) => [...accumulated, value],
        [],
      ),
      builder: (context, snapshot) {
        return CandleChart(
          data: snapshot.data ?? [],
          realtime: true,
        );
      },
    ),
  );
  
  // 초기 상태
  expect(find.byType(CandleChart), findsOneWidget);
  
  // 새 캔들 추가
  for (int i = 0; i < 5; i++) {
    priceStream.add(CandleData(
      timestamp: DateTime.now().add(Duration(minutes: i)),
      open: 100 + i,
      high: 102 + i,
      low: 99 + i,
      close: 101 + i,
      volume: 1000000,
    ));
    await tester.pump();
    
    // 차트 업데이트 확인
    final chart = tester.widget<CandleChart>(find.byType(CandleChart));
    expect(chart.data.length, equals(i + 1));
  }
});

// 실시간 알림
testWidgets('should show real-time notifications', (tester) async {
  final notificationStream = StreamController<PriceAlert>.broadcast();
  
  await tester.pumpWidget(
    NotificationListener<PriceAlert>(
      onNotification: (alert) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(alert.message)),
        );
        return true;
      },
      child: StreamBuilder<PriceAlert>(
        stream: notificationStream.stream,
        builder: (context, snapshot) => MainScreen(),
      ),
    ),
  );
  
  // 가격 알림 트리거
  notificationStream.add(PriceAlert(
    stockCode: 'AAPL',
    message: 'AAPL reached target price \$180',
    type: AlertType.targetReached,
  ));
  
  await tester.pump();
  
  // 스낵바 표시 확인
  expect(find.text('AAPL reached target price \$180'), findsOneWidget);
  expect(find.byType(SnackBar), findsOneWidget);
  
  // 자동 숨김
  await tester.pump(Duration(seconds: 4));
  expect(find.byType(SnackBar), findsNothing);
});
```

## 5. 플랫폼별 UI 차이점 테스트

### 5.1 iOS/Android Material 차이

```dart
// 플랫폼별 네비게이션
testWidgets('should use platform-specific navigation', (tester) async {
  // iOS 테스트
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  
  await tester.pumpWidget(
    MaterialApp(
      home: AdaptiveNavigationScreen(),
    ),
  );
  
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  
  // iOS는 슬라이드 전환
  expect(find.byType(CupertinoPageRoute), findsOneWidget);
  
  // Android 테스트
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  
  await tester.pumpWidget(
    MaterialApp(
      home: AdaptiveNavigationScreen(),
    ),
  );
  
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  
  // Android는 페이드 전환
  expect(find.byType(MaterialPageRoute), findsOneWidget);
  
  debugDefaultTargetPlatformOverride = null;
});

// 플랫폼별 UI 컴포넌트
testWidgets('should use platform-specific components', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AdaptiveButton(
          onPressed: () {},
          child: Text('Action'),
        ),
      ),
    ),
  );
  
  // iOS
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  await tester.pumpAndSettle();
  expect(find.byType(CupertinoButton), findsOneWidget);
  
  // Android
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  await tester.pumpAndSettle();
  expect(find.byType(ElevatedButton), findsOneWidget);
  
  debugDefaultTargetPlatformOverride = null;
});
```

### 5.2 네이티브 기능 통합

```dart
// 생체 인증
testWidgets('should handle biometric authentication', (tester) async {
  final mockAuth = MockLocalAuthentication();
  
  when(mockAuth.isDeviceSupported()).thenAnswer((_) async => true);
  when(mockAuth.canCheckBiometrics).thenAnswer((_) async => true);
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localAuthProvider.overrideWithValue(mockAuth),
      ],
      child: SecurityScreen(),
    ),
  );
  
  await tester.tap(find.text('Enable Biometric Login'));
  await tester.pump();
  
  // 생체 인증 다이얼로그 표시
  verify(mockAuth.authenticate(
    localizedReason: 'Authenticate to enable biometric login',
    options: AuthenticationOptions(biometricOnly: true),
  )).called(1);
});

// 카메라/갤러리 접근
testWidgets('should handle image picker', (tester) async {
  final mockPicker = MockImagePicker();
  
  when(mockPicker.pickImage(source: ImageSource.camera))
    .thenAnswer((_) async => XFile('path/to/image.jpg'));
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        imagePickerProvider.overrideWithValue(mockPicker),
      ],
      child: ProfileScreen(),
    ),
  );
  
  await tester.tap(find.byIcon(Icons.camera_alt));
  await tester.pump();
  
  // 플랫폼별 권한 다이얼로그
  if (Platform.isIOS) {
    expect(find.text('Allow app to access camera?'), findsOneWidget);
  } else {
    expect(find.text('Allow app to take pictures?'), findsOneWidget);
  }
});
```

### 5.3 플랫폼별 제스처

```dart
// iOS 스와이프 백
testWidgets('should support iOS swipe back gesture', (tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Navigator(
        pages: [
          MaterialPage(child: Screen1()),
          MaterialPage(child: Screen2()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    ),
  );
  
  // 오른쪽 가장자리에서 스와이프
  await tester.dragFrom(
    Offset(0, 400),
    Offset(300, 400),
  );
  await tester.pumpAndSettle();
  
  // 이전 화면으로 돌아감
  expect(find.byType(Screen1), findsOneWidget);
  expect(find.byType(Screen2), findsNothing);
  
  debugDefaultTargetPlatformOverride = null;
});

// Android 백 버튼
testWidgets('should handle Android back button', (tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  
  await tester.pumpWidget(
    MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          // 종료 확인 다이얼로그
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Exit'),
                ),
              ],
            ),
          ) ?? false;
        },
        child: MainScreen(),
      ),
    ),
  );
  
  // 백 버튼 시뮬레이션
  final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
  await widgetsAppState.didPopRoute();
  await tester.pump();
  
  // 종료 확인 다이얼로그 표시
  expect(find.text('Exit App?'), findsOneWidget);
  
  debugDefaultTargetPlatformOverride = null;
});
```

### 5.4 시스템 UI 통합

```dart
// 다크 모드 지원
testWidgets('should adapt to system theme', (tester) async {
  // 라이트 모드
  tester.binding.window.platformBrightnessTestValue = Brightness.light;
  
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: ThemedScreen(),
    ),
  );
  
  final lightBg = tester.widget<Container>(
    find.byKey(Key('themed-container'))
  ).color;
  expect(lightBg, equals(Colors.white));
  
  // 다크 모드
  tester.binding.window.platformBrightnessTestValue = Brightness.dark;
  await tester.pumpAndSettle();
  
  final darkBg = tester.widget<Container>(
    find.byKey(Key('themed-container'))
  ).color;
  expect(darkBg, equals(Colors.black));
});

// 시스템 폰트 크기
testWidgets('should respect system text scale', (tester) async {
  // 일반 크기
  tester.binding.window.textScaleFactorTestValue = 1.0;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Text(
          'Scalable Text',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
  
  final normalSize = tester.getSize(find.text('Scalable Text'));
  
  // 큰 텍스트 설정
  tester.binding.window.textScaleFactorTestValue = 1.5;
  await tester.pumpAndSettle();
  
  final largeSize = tester.getSize(find.text('Scalable Text'));
  expect(largeSize.width, greaterThan(normalSize.width));
});

// Safe Area 처리
testWidgets('should respect safe areas', (tester) async {
  // 노치가 있는 기기 시뮬레이션
  tester.binding.window.paddingTestValue = FakeWindowPadding(
    top: 44.0, // 상태바
    bottom: 34.0, // 홈 인디케이터
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            key: Key('content'),
            color: Colors.blue,
          ),
        ),
      ),
    ),
  );
  
  final contentPosition = tester.getTopLeft(find.byKey(Key('content')));
  expect(contentPosition.dy, equals(44.0));
});
```

## 테스트 실행 및 리포팅

### 테스트 커버리지 목표
- 전체 커버리지: 80% 이상
- 핵심 비즈니스 로직: 95% 이상
- UI 컴포넌트: 90% 이상
- 유틸리티 함수: 100%

### 테스트 자동화
```bash
# 단위 테스트 실행
flutter test --coverage

# 통합 테스트 실행
flutter test integration_test

# 성능 테스트 실행
flutter drive --profile --trace-timeline

# 플랫폼별 테스트
flutter test --platform chrome  # Web
flutter test --platform ios     # iOS
flutter test --platform android # Android
```

### 지속적 모니터링
- 매 커밋마다 테스트 실행
- 성능 메트릭 대시보드 구축
- 크래시 리포트 모니터링
- 사용자 피드백 수집 및 분석