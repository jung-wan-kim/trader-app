import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RiskCalculator extends StatefulWidget {
  final double currentPrice;
  final double stopLoss;
  final double takeProfit;

  const RiskCalculator({
    super.key,
    required this.currentPrice,
    required this.stopLoss,
    required this.takeProfit,
  });

  @override
  State<RiskCalculator> createState() => _RiskCalculatorState();
}

class _RiskCalculatorState extends State<RiskCalculator> {
  final _accountSizeController = TextEditingController(text: '10000');
  final _riskPercentController = TextEditingController(text: '2');
  
  double get accountSize => double.tryParse(_accountSizeController.text) ?? 0;
  double get riskPercent => double.tryParse(_riskPercentController.text) ?? 0;
  double get riskAmount => accountSize * (riskPercent / 100);
  double get stopLossAmount => (widget.currentPrice - widget.stopLoss).abs();
  double get stopLossPercent => (stopLossAmount / widget.currentPrice) * 100;
  double get positionSize => stopLossAmount > 0 ? riskAmount / stopLossAmount : 0;
  double get totalInvestment => positionSize * widget.currentPrice;
  double get potentialProfit => (widget.takeProfit - widget.currentPrice) * positionSize;
  double get potentialLoss => stopLossAmount * positionSize;
  double get riskRewardRatio => potentialLoss > 0 ? potentialProfit / potentialLoss : 0;

  @override
  void dispose() {
    _accountSizeController.dispose();
    _riskPercentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                color: const Color(0xFF00D632),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Risk Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Input Fields
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Account Size',
                  controller: _accountSizeController,
                  prefix: '\$',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Risk per Trade',
                  controller: _riskPercentController,
                  suffix: '%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Results
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildResultRow(
                  label: 'Risk Amount',
                  value: '\$${riskAmount.toStringAsFixed(2)}',
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildResultRow(
                  label: 'Position Size',
                  value: '${positionSize.toStringAsFixed(0)} shares',
                ),
                const SizedBox(height: 8),
                _buildResultRow(
                  label: 'Total Investment',
                  value: '\$${totalInvestment.toStringAsFixed(2)}',
                ),
                const Divider(color: Colors.grey),
                _buildResultRow(
                  label: 'Potential Profit',
                  value: '\$${potentialProfit.toStringAsFixed(2)}',
                  color: const Color(0xFF00D632),
                ),
                const SizedBox(height: 8),
                _buildResultRow(
                  label: 'Potential Loss',
                  value: '\$${potentialLoss.toStringAsFixed(2)}',
                  color: const Color(0xFFFF3B30),
                ),
                const SizedBox(height: 8),
                _buildResultRow(
                  label: 'Risk/Reward Ratio',
                  value: '1:${riskRewardRatio.toStringAsFixed(2)}',
                  color: riskRewardRatio >= 2 
                      ? const Color(0xFF00D632)
                      : riskRewardRatio >= 1 
                          ? Colors.orange
                          : const Color(0xFFFF3B30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Warning
          if (riskRewardRatio < 1)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 16,
                    color: Colors.red[400],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Risk/Reward ratio is below 1:1. Consider adjusting your targets.',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixText: prefix,
            suffixText: suffix,
            prefixStyle: TextStyle(color: Colors.grey[400]),
            suffixStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[850],
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF00D632)),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildResultRow({
    required String label,
    required String value,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}