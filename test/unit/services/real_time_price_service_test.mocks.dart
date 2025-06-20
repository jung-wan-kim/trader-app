// Mocks generated by Mockito 5.0.0 from annotations
// in trader_app/test/unit/services/real_time_price_service_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:trader_app/services/finnhub_service.dart' as _i2;
import 'package:trader_app/providers/portfolio_provider.dart' as _i4;
import 'package:trader_app/providers/watchlist_provider.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [FinnhubService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFinnhubService extends _i1.Mock implements _i2.FinnhubService {
  MockFinnhubService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<String, dynamic>> getStockQuote(String? symbol) =>
      (super.noSuchMethod(
        Invocation.method(
          #getStockQuote,
          [symbol],
        ),
        returnValue: _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);
}

/// A class which mocks [PortfolioNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockPortfolioNotifier extends _i1.Mock implements _i4.PortfolioNotifier {
  MockPortfolioNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> updatePositionPrice(String symbol, double price) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePositionPrice,
          [symbol, price],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [WatchlistNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistNotifier extends _i1.Mock implements _i5.WatchlistNotifier {
  MockWatchlistNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> refresh() =>
      (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}