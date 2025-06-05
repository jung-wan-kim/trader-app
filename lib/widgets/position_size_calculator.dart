import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PositionSizeCalculator extends StatefulWidget {
  final double currentPrice;
  final double stopLoss;

  const PositionSizeCalculator({
    super.key,
    required this.currentPrice,
    required this.stopLoss,
  });

  @override
  State<PositionSizeCalculator> createState() => _PositionSizeCalculatorState();
}

class _PositionSizeCalculatorState extends State<PositionSizeCalculator> {
  final _accountBalanceController = TextEditingController(text: '10000');
  final _riskAmountController = TextEditingController(text: '200');
  String _calculationMethod = 'fixed_amount'; // fixed_amount or percentage

  double get accountBalance => double.tryParse(_accountBalanceController.text) ?? 0;
  double get riskAmount => double.tryParse(_riskAmountController.text) ?? 0;
  double get stopLossDistance => (widget.currentPrice - widget.stopLoss).abs();
  double get stopLossPercent => (stopLossDistance / widget.currentPrice) * 100;
  
  double get positionSize {
    if (_calculationMethod == 'fixed_amount') {
      return stopLossDistance > 0 ? riskAmount / stopLossDistance : 0;
    } else {
      final riskAmountFromPercent = accountBalance * (riskAmount / 100);
      return stopLossDistance > 0 ? riskAmountFromPercent / stopLossDistance : 0;
    }
  }
  
  double get totalPositionValue => positionSize * widget.currentPrice;
  double get percentOfAccount => accountBalance > 0 ? (totalPositionValue / accountBalance) * 100 : 0;
  double get maxLoss => positionSize * stopLossDistance;

  @override
  void dispose() {
    _accountBalanceController.dispose();
    _riskAmountController.dispose();
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
                Icons.account_balance_wallet_outlined,
                color: const Color(0xFF00D632),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Position Size Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Account Balance Input
          _buildInputField(
            label: 'Account Balance',
            controller: _accountBalanceController,
            prefix: '\$',
          ),
          const SizedBox(height: 12),
          
          // Risk Method Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMethodButton(
                    label: 'Fixed Amount',
                    value: 'fixed_amount',
                    isSelected: _calculationMethod == 'fixed_amount',
                  ),
                ),
                Expanded(
                  child: _buildMethodButton(
                    label: 'Percentage',
                    value: 'percentage',
                    isSelected: _calculationMethod == 'percentage',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Risk Input
          _buildInputField(
            label: _calculationMethod == 'fixed_amount' 
                ? 'Risk Amount' 
                : 'Risk Percentage',
            controller: _riskAmountController,
            prefix: _calculationMethod == 'fixed_amount' ? '\$' : null,
            suffix: _calculationMethod == 'percentage' ? '%' : null,
          ),
          const SizedBox(height: 20),
          
          // Market Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  label: 'Current Price',
                  value: '\$${widget.currentPrice.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  label: 'Stop Loss',
                  value: '\$${widget.stopLoss.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  label: 'Stop Distance',
                  value: '\$${stopLossDistance.toStringAsFixed(2)} (${stopLossPercent.toStringAsFixed(2)}%)',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Results
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00D632).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00D632).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Recommended Position Size',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${positionSize.toStringAsFixed(0)} shares',
                  style: const TextStyle(
                    color: Color(0xFF00D632),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Value: \$${totalPositionValue.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Additional Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildResultRow(
                  label: '% of Account',
                  value: '${percentOfAccount.toStringAsFixed(2)}%',
                  color: percentOfAccount > 50 
                      ? Colors.red
                      : percentOfAccount > 30 
                          ? Colors.orange
                          : Colors.green,
                ),
                const SizedBox(height: 8),
                _buildResultRow(
                  label: 'Max Loss',
                  value: '\$${maxLoss.toStringAsFixed(2)}',
                  color: const Color(0xFFFF3B30),
                ),
              ],
            ),
          ),
          
          // Warning for high position size
          if (percentOfAccount > 30) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange[400],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Position size exceeds 30% of account. Consider reducing for better risk management.',
                      style: TextStyle(
                        color: Colors.orange[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodButton({
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _calculationMethod = value;
          _riskAmountController.text = value == 'fixed_amount' ? '200' : '2';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D632).withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00D632) : Colors.grey[400],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
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

  Widget _buildInfoRow({
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
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
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