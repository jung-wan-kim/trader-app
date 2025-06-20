import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_provider.dart';
import '../generated/l10n/app_localizations.dart';

class EditPositionDialog extends ConsumerStatefulWidget {
  final Position position;

  const EditPositionDialog({
    super.key,
    required this.position,
  });

  @override
  ConsumerState<EditPositionDialog> createState() => _EditPositionDialogState();
}

class _EditPositionDialogState extends ConsumerState<EditPositionDialog> {
  late TextEditingController _stopLossController;
  late TextEditingController _takeProfitController;
  late TextEditingController _quantityController;
  
  bool _isLoading = false;
  String? _stopLossError;
  String? _takeProfitError;
  String? _quantityError;

  @override
  void initState() {
    super.initState();
    _stopLossController = TextEditingController(
      text: widget.position.stopLoss?.toStringAsFixed(2) ?? '',
    );
    _takeProfitController = TextEditingController(
      text: widget.position.takeProfit?.toStringAsFixed(2) ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.position.quantity.toString(),
    );
  }

  @override
  void dispose() {
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    setState(() {
      _stopLossError = null;
      _takeProfitError = null;
      _quantityError = null;
    });

    bool isValid = true;

    // Validate quantity
    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      setState(() {
        _quantityError = 'Invalid quantity';
      });
      isValid = false;
    }

    // Validate stop loss
    if (_stopLossController.text.isNotEmpty) {
      final stopLoss = double.tryParse(_stopLossController.text);
      if (stopLoss == null || stopLoss <= 0) {
        setState(() {
          _stopLossError = 'Invalid stop loss price';
        });
        isValid = false;
      } else if (stopLoss >= widget.position.currentPrice) {
        setState(() {
          _stopLossError = 'Stop loss must be below current price';
        });
        isValid = false;
      }
    }

    // Validate take profit
    if (_takeProfitController.text.isNotEmpty) {
      final takeProfit = double.tryParse(_takeProfitController.text);
      if (takeProfit == null || takeProfit <= 0) {
        setState(() {
          _takeProfitError = 'Invalid take profit price';
        });
        isValid = false;
      } else if (takeProfit <= widget.position.currentPrice) {
        setState(() {
          _takeProfitError = 'Take profit must be above current price';
        });
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _saveChanges() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPosition = widget.position.copyWith(
        quantity: int.parse(_quantityController.text),
        stopLoss: _stopLossController.text.isEmpty 
            ? null 
            : double.parse(_stopLossController.text),
        takeProfit: _takeProfitController.text.isEmpty 
            ? null 
            : double.parse(_takeProfitController.text),
      );

      await ref.read(portfolioProvider.notifier).updatePosition(updatedPosition);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.positionUpdatedSuccessfully),
            backgroundColor: const Color(0xFF00D632),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update position: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentPrice = widget.position.currentPrice;

    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n?.editPosition ?? 'Edit Position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.position.stockCode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.position.stockName,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Current: \$${currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Entry: \$${widget.position.entryPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quantity
            _buildInputField(
              label: l10n?.quantity ?? 'Quantity',
              controller: _quantityController,
              error: _quantityError,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              suffix: 'shares',
            ),
            
            const SizedBox(height: 16),
            
            // Stop Loss
            _buildInputField(
              label: l10n?.stopLoss ?? 'Stop Loss',
              controller: _stopLossController,
              error: _stopLossError,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              prefix: '\$',
              hint: 'Optional',
              helperText: 'Price to automatically sell if stock drops',
            ),
            
            const SizedBox(height: 16),
            
            // Take Profit
            _buildInputField(
              label: l10n?.takeProfit ?? 'Take Profit',
              controller: _takeProfitController,
              error: _takeProfitError,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              prefix: '\$',
              hint: 'Optional',
              helperText: 'Price to automatically sell if stock rises',
            ),
            
            const SizedBox(height: 24),
            
            // Risk/Reward Info
            if (_stopLossController.text.isNotEmpty || _takeProfitController.text.isNotEmpty)
              _buildRiskRewardInfo(),
            
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      l10n?.cancel ?? 'Cancel',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D632),
                      disabledBackgroundColor: Colors.grey[700],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            l10n?.saveChanges ?? 'Save Changes',
                            style: const TextStyle(color: Colors.black),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? error,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefix,
    String? suffix,
    String? hint,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[850],
            prefixText: prefix,
            suffixText: suffix,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            errorText: error,
            errorStyle: const TextStyle(color: Colors.red),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00D632)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRiskRewardInfo() {
    final currentPrice = widget.position.currentPrice;
    final stopLoss = double.tryParse(_stopLossController.text);
    final takeProfit = double.tryParse(_takeProfitController.text);
    
    double? riskPercent;
    double? rewardPercent;
    double? riskRewardRatio;
    
    if (stopLoss != null && stopLoss > 0) {
      riskPercent = ((currentPrice - stopLoss) / currentPrice) * 100;
    }
    
    if (takeProfit != null && takeProfit > 0) {
      rewardPercent = ((takeProfit - currentPrice) / currentPrice) * 100;
    }
    
    if (riskPercent != null && rewardPercent != null && riskPercent > 0) {
      riskRewardRatio = rewardPercent / riskPercent;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        children: [
          if (riskPercent != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Risk',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  '-${riskPercent.toStringAsFixed(2)}%',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          if (rewardPercent != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reward',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  '+${rewardPercent.toStringAsFixed(2)}%',
                  style: const TextStyle(
                    color: Color(0xFF00D632),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (riskRewardRatio != null) ...[
            const SizedBox(height: 8),
            const Divider(color: Colors.grey, height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Risk/Reward Ratio',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  '1:${riskRewardRatio.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: riskRewardRatio >= 2 
                        ? const Color(0xFF00D632) 
                        : riskRewardRatio >= 1 
                            ? Colors.orange 
                            : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}