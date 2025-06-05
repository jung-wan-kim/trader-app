import 'package:flutter_test/flutter_test.dart';

// RiskCalculator 로직을 별도 유틸리티 함수로 추출하여 테스트
class RiskCalculatorUtils {
  static double calculateRiskAmount(double accountSize, double riskPercent) {
    return accountSize * (riskPercent / 100);
  }

  static double calculateStopLossAmount(double currentPrice, double stopLoss) {
    return (currentPrice - stopLoss).abs();
  }

  static double calculateStopLossPercent(double currentPrice, double stopLoss) {
    final stopLossAmount = calculateStopLossAmount(currentPrice, stopLoss);
    return (stopLossAmount / currentPrice) * 100;
  }

  static double calculatePositionSize(double riskAmount, double stopLossAmount) {
    return stopLossAmount > 0 ? riskAmount / stopLossAmount : 0;
  }

  static double calculateTotalInvestment(double positionSize, double currentPrice) {
    return positionSize * currentPrice;
  }

  static double calculatePotentialProfit(double takeProfit, double currentPrice, double positionSize) {
    return (takeProfit - currentPrice) * positionSize;
  }

  static double calculatePotentialLoss(double stopLossAmount, double positionSize) {
    return stopLossAmount * positionSize;
  }

  static double calculateRiskRewardRatio(double potentialProfit, double potentialLoss) {
    return potentialLoss > 0 ? potentialProfit / potentialLoss : 0;
  }
}

void main() {
  group('RiskCalculatorUtils Tests', () {
    test('should calculate risk amount correctly', () {
      expect(RiskCalculatorUtils.calculateRiskAmount(10000, 2), equals(200));
      expect(RiskCalculatorUtils.calculateRiskAmount(5000, 1.5), equals(75));
      expect(RiskCalculatorUtils.calculateRiskAmount(100000, 0.5), equals(500));
      expect(RiskCalculatorUtils.calculateRiskAmount(0, 2), equals(0));
      expect(RiskCalculatorUtils.calculateRiskAmount(10000, 0), equals(0));
    });

    test('should calculate stop loss amount correctly', () {
      expect(RiskCalculatorUtils.calculateStopLossAmount(100, 95), equals(5));
      expect(RiskCalculatorUtils.calculateStopLossAmount(100, 105), equals(5));
      expect(RiskCalculatorUtils.calculateStopLossAmount(50, 50), equals(0));
      expect(RiskCalculatorUtils.calculateStopLossAmount(200, 180), equals(20));
    });

    test('should calculate stop loss percent correctly', () {
      expect(RiskCalculatorUtils.calculateStopLossPercent(100, 95), equals(5));
      expect(RiskCalculatorUtils.calculateStopLossPercent(100, 90), equals(10));
      expect(RiskCalculatorUtils.calculateStopLossPercent(50, 45), equals(10));
      expect(RiskCalculatorUtils.calculateStopLossPercent(100, 100), equals(0));
    });

    test('should calculate position size correctly', () {
      expect(RiskCalculatorUtils.calculatePositionSize(200, 5), equals(40));
      expect(RiskCalculatorUtils.calculatePositionSize(500, 10), equals(50));
      expect(RiskCalculatorUtils.calculatePositionSize(100, 2), equals(50));
      expect(RiskCalculatorUtils.calculatePositionSize(200, 0), equals(0));
      expect(RiskCalculatorUtils.calculatePositionSize(0, 5), equals(0));
    });

    test('should calculate total investment correctly', () {
      expect(RiskCalculatorUtils.calculateTotalInvestment(40, 100), equals(4000));
      expect(RiskCalculatorUtils.calculateTotalInvestment(50, 200), equals(10000));
      expect(RiskCalculatorUtils.calculateTotalInvestment(0, 100), equals(0));
      expect(RiskCalculatorUtils.calculateTotalInvestment(100, 0), equals(0));
    });

    test('should calculate potential profit correctly', () {
      expect(RiskCalculatorUtils.calculatePotentialProfit(110, 100, 40), equals(400));
      expect(RiskCalculatorUtils.calculatePotentialProfit(120, 100, 50), equals(1000));
      expect(RiskCalculatorUtils.calculatePotentialProfit(100, 100, 40), equals(0));
      expect(RiskCalculatorUtils.calculatePotentialProfit(90, 100, 40), equals(-400));
    });

    test('should calculate potential loss correctly', () {
      expect(RiskCalculatorUtils.calculatePotentialLoss(5, 40), equals(200));
      expect(RiskCalculatorUtils.calculatePotentialLoss(10, 50), equals(500));
      expect(RiskCalculatorUtils.calculatePotentialLoss(0, 40), equals(0));
      expect(RiskCalculatorUtils.calculatePotentialLoss(5, 0), equals(0));
    });

    test('should calculate risk reward ratio correctly', () {
      expect(RiskCalculatorUtils.calculateRiskRewardRatio(400, 200), equals(2.0));
      expect(RiskCalculatorUtils.calculateRiskRewardRatio(600, 200), equals(3.0));
      expect(RiskCalculatorUtils.calculateRiskRewardRatio(100, 200), equals(0.5));
      expect(RiskCalculatorUtils.calculateRiskRewardRatio(400, 0), equals(0));
      expect(RiskCalculatorUtils.calculateRiskRewardRatio(0, 200), equals(0));
    });

    test('should handle complete risk calculation scenario', () {
      // Scenario: $10,000 account, 2% risk, stock at $100, stop loss at $95, take profit at $110
      const accountSize = 10000.0;
      const riskPercent = 2.0;
      const currentPrice = 100.0;
      const stopLoss = 95.0;
      const takeProfit = 110.0;

      final riskAmount = RiskCalculatorUtils.calculateRiskAmount(accountSize, riskPercent);
      expect(riskAmount, equals(200));

      final stopLossAmount = RiskCalculatorUtils.calculateStopLossAmount(currentPrice, stopLoss);
      expect(stopLossAmount, equals(5));

      final positionSize = RiskCalculatorUtils.calculatePositionSize(riskAmount, stopLossAmount);
      expect(positionSize, equals(40));

      final totalInvestment = RiskCalculatorUtils.calculateTotalInvestment(positionSize, currentPrice);
      expect(totalInvestment, equals(4000));

      final potentialProfit = RiskCalculatorUtils.calculatePotentialProfit(takeProfit, currentPrice, positionSize);
      expect(potentialProfit, equals(400));

      final potentialLoss = RiskCalculatorUtils.calculatePotentialLoss(stopLossAmount, positionSize);
      expect(potentialLoss, equals(200));

      final riskRewardRatio = RiskCalculatorUtils.calculateRiskRewardRatio(potentialProfit, potentialLoss);
      expect(riskRewardRatio, equals(2.0));
    });

    test('should handle edge cases gracefully', () {
      // Test with very small numbers
      expect(RiskCalculatorUtils.calculateRiskAmount(0.01, 1), closeTo(0.0001, 0.00001));
      
      // Test with very large numbers
      expect(RiskCalculatorUtils.calculateRiskAmount(1000000, 2), equals(20000));
      
      // Test with decimal percentages
      expect(RiskCalculatorUtils.calculateRiskAmount(10000, 0.5), equals(50));
      expect(RiskCalculatorUtils.calculateRiskAmount(10000, 2.5), equals(250));
    });
  });
}