import 'package:flutter/material.dart';
import '../models/morphic_state.dart' as morphic;
import 'inventory_table.dart';
import 'finance_chart.dart';
import 'product_image_card.dart';
import 'action_card.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;

class MorphicContainer extends StatelessWidget {
  final morphic.MorphicState state;
  final Function(String, Map<String, dynamic>)? onActionConfirm;
  final VoidCallback? onActionCancel;

  const MorphicContainer({
    super.key,
    required this.state,
    this.onActionConfirm,
    this.onActionCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: _buildContentForMode(),
    );
  }

  Widget _buildContentForMode() {
    return Container(
      key: ValueKey('${state.intent}_${state.uiMode}'),
      child: Column(
        children: [
          if (state.headerText != null && state.headerText!.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                state.headerText!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(child: _getWidgetForMode()),
        ],
      ),
    );
  }

  Widget _getWidgetForMode() {
    switch (state.uiMode) {
      case morphic.UIMode.table:
        final products = state.data['products'] as List<client.Product>? ?? [];
        return InventoryTable(products: products);

      case morphic.UIMode.chart:
        final expenses = state.data['expenses'] as List<client.Expense>? ?? [];
        final isTrend = state.data['is_trend'] as bool? ?? false;
        return FinanceChart(expenses: expenses, isTrend: isTrend);

      case morphic.UIMode.image:
        final product = state.data['product'] as client.Product?;
        if (product != null) {
          return ProductImageCard(product: product);
        }
        return _buildNarrativeView();

      case morphic.UIMode.action:
        final actionType = state.data['action_type'] as String?;
        final actionData = state.data['action_data'] as Map<String, dynamic>?;
        if (actionType != null && actionData != null) {
          return ActionCard(
            actionType: actionType,
            actionData: actionData,
            onConfirm: () => onActionConfirm?.call(actionType, actionData),
            onCancel: () => onActionCancel?.call(),
          );
        }
        return _buildNarrativeView();

      case morphic.UIMode.narrative:
        return _buildNarrativeView();
        
      case morphic.UIMode.dashboard:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    final components = state.data['components'] as List<dynamic>? ?? [];
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: components.length,
      itemBuilder: (context, index) {
        final componentData = components[index] as Map<String, dynamic>;
        final type = componentData['type'] as String;
        final title = componentData['title'] as String;
        
        Widget content;
        
        switch (type) {
          case 'chart':
            final expenses = (componentData['data'] as List).cast<client.Expense>();
            final isTrend = componentData['is_trend'] as bool? ?? false;
            final isComparison = componentData['is_comparison'] as bool? ?? false;
            final comparisonData = componentData['comparison_data'] as Map<String, dynamic>?;
            
            content = SizedBox(
              height: 300,
              child: FinanceChart(
                expenses: expenses, 
                isTrend: isTrend,
                isComparison: isComparison,
                comparisonData: comparisonData,
              ),
            );
            break;
            
          case 'table':
            final products = (componentData['data'] as List).cast<client.Product>();
            content = SizedBox(
              height: 400,
              child: InventoryTable(products: products),
            );
            break;
            
          default:
            content = const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Important due to SizedBox constraints above
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              content,
            ],
          ),
        );
      },
    );
  }

  Widget _buildNarrativeView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.narrative.isEmpty) ...[
              _buildWelcomeAnimation(),
            ] else ...[
              if (state.confidence < 0.7 && state.intent == morphic.Intent.unknown) ...[
                const Icon(Icons.help_outline, size: 48, color: Color(0xFF10B981)),
                const SizedBox(height: 16),
                const Text(
                  "I'm not quite sure. Could you rephrase?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
              Text(
                state.narrative,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeAnimation() {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(seconds: 2),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0x4D10B981), Color(0x1A10B981)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, size: 60, color: Color(0xFF10B981)),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: const Column(
                children: [
                  Text(
                    'Welcome to Kindred AI',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the mic to start speaking',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
