import 'package:flutter/material.dart';
import '../models/business_data.dart';
import '../utils/app_theme.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_animations.dart';
import 'glassmorphic_card.dart';
import 'markdown_text.dart';

class ActionCard extends StatelessWidget {
  final String actionType;
  final Map<String, dynamic> actionData;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ActionCard({
    super.key,
    required this.actionType,
    required this.actionData,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAffordability(),
      builder: (context, snapshot) {
        final canAfford = snapshot.data ?? true;
        
        return Center(
          child: SingleChildScrollView(
            child: GlassmorphicCard(
              margin: const EdgeInsets.all(24.0),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                TweenAnimationBuilder<double>(
                  duration: AppAnimations.slow,
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: AppAnimations.bouncyCurve,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.emeraldPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.emeraldPrimary.withOpacity(0.3), 
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _getIcon(),
                          size: 44,
                          color: AppColors.emeraldPrimary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  _getTitle(),
                  style: AppTypography.title.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FutureBuilder<String>(
                  future: _getDescription(),
                  builder: (context, descSnapshot) {
                    return MarkdownText(
                      descSnapshot.data ?? 'Analyzing request...',
                      style: AppTypography.body.copyWith(
                        color: AppColors.gray400,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                if ((actionType == 'updateStock' || actionType == 'addProduct') && !canAfford) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.rose.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.rose.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.rose, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Insufficient funds for this action',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.rose,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: AppTypography.button.copyWith(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: canAfford ? onConfirm : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: AppTheme.emeraldButton(isPressed: !canAfford),
                          child: Text(
                            'CONFIRM',
                            style: AppTypography.button.copyWith(
                              color: canAfford ? AppColors.white : AppColors.white.withOpacity(0.3),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  Future<bool> _checkAffordability() async {
    if (actionType == 'updateStock' || actionType == 'addProduct') {
      final quantity = actionData['quantity'] ?? 1;
      final productPrice = actionData['product_price'] ?? actionData['price'] ?? 0.0;
      final totalCost = quantity * productPrice;
      return await AccountHelper.canAfford(totalCost);
    } else if (actionType == 'addExpense') {
      final amount = actionData['amount'] ?? 0.0;
      return await AccountHelper.canAfford(amount);
    }
    return true;
  }

  IconData _getIcon() {
    switch (actionType) {
      case 'updateStock':
        return Icons.inventory_2_outlined;
      case 'deleteProduct':
        return Icons.delete_outline;
      case 'addProduct':
        return Icons.add_business_outlined;
      case 'addExpense':
        return Icons.receipt_long_outlined;
      default:
        return Icons.auto_awesome_outlined;
    }
  }

  String _getTitle() {
    switch (actionType) {
      case 'updateStock':
        return 'Update Inventory';
      case 'deleteProduct':
        return 'Remove Item';
      case 'addProduct':
        return 'New Product';
      case 'addExpense':
        return 'Record Expense';
      default:
        return 'Confirm Action';
    }
  }

  Future<String> _getDescription() async {
    final productName = actionData['product_name'] ?? 'Unknown Item';
    
    switch (actionType) {
      case 'addExpense':
        final amount = actionData['amount'] ?? 0.0;
        final category = actionData['category'] ?? 'Expenses';
        return 'Record a new operational expense for **$category**?\n\n'
               'Amount: \$${amount.toStringAsFixed(2)}';
      case 'updateStock':
        final quantity = actionData['quantity'] ?? 0;
        final currentStock = actionData['current_stock'] ?? 0;
        final newStock = currentStock + quantity;
        final productPrice = actionData['product_price'] ?? actionData['price'] ?? 0.0;
        final totalCost = quantity * productPrice;
        final availableFunds = await AccountHelper.getAvailableFunds();
        
        return 'Proceed to add $quantity units to $productName?\n\n'
               'Investment: \$${totalCost.toStringAsFixed(2)}\n'
               'Available: \$${availableFunds.toStringAsFixed(2)}';
      case 'deleteProduct':
        return 'Are you sure you want to remove $productName from your inventory? This cannot be undone.';
      case 'addProduct':
        final price = actionData['price'] ?? actionData['product_price'] ?? 0;
        final stock = actionData['stock'] ?? 0;
        return 'Create new listing for $productName at \$${price.toStringAsFixed(2)} with $stock units initial stock.';
      default:
        return 'Please confirm you would like to proceed with this business operation.';
    }
  }
}
