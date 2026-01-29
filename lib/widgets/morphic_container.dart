import 'package:flutter/material.dart';
import '../models/morphic_state.dart' as morphic;
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_animations.dart';
import 'inventory_table.dart';
import 'finance_chart.dart';
import 'product_image_card.dart';
import 'action_card.dart';
import 'glassmorphic_card.dart';
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
      duration: AppAnimations.medium,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: AppAnimations.slideUpTween.animate(
              CurvedAnimation(
                parent: animation,
                curve: AppAnimations.standardCurve,
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: GlassmorphicCard(
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  state.headerText!,
                  style: AppTypography.title.copyWith(fontSize: 14, letterSpacing: 1),
                  textAlign: TextAlign.center,
                ),
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
        return GlassmorphicCard(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: InventoryTable(products: products),
        );

      case morphic.UIMode.chart:
        final expenses = state.data['expenses'] as List<client.Expense>? ?? [];
        final isTrend = state.data['is_trend'] as bool? ?? false;
        return GlassmorphicCard(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: FinanceChart(expenses: expenses, isTrend: isTrend),
        );

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
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
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
              height: 260,
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
              height: 350,
              child: InventoryTable(products: products),
            );
            break;
            
          default:
            content = const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GlassmorphicCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    title,
                    style: AppTypography.title.copyWith(fontSize: 18),
                  ),
                ),
                content,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNarrativeView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.narrative.isEmpty) ...[
              _buildWelcomeAnimation(),
            ] else ...[
              if (state.confidence < 0.7 && state.intent == morphic.Intent.unknown) ...[
                const Icon(Icons.help_outline, size: 56, color: AppColors.amber),
                const SizedBox(height: 24),
                Text(
                  "Business Query Unclear",
                  style: AppTypography.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "I couldn't confidently interpret that request. Could you please specify if you're asking about inventory or finances?",
                  style: AppTypography.body.copyWith(color: AppColors.gray400),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                GlassmorphicCard(
                  child: Text(
                    state.narrative,
                    style: AppTypography.body.copyWith(
                      fontSize: 18,
                      color: AppColors.white.withOpacity(0.9),
                      height: 1.5,
                      shadows: [
                         Shadow(
                           color: AppColors.emeraldPrimary.withOpacity(0.3),
                           blurRadius: 10,
                         ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
          curve: AppAnimations.standardCurve,
          builder: (context, value, child) {
            return Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.1 * value),
                    blurRadius: 60,
                    spreadRadius: 20 * value,
                  ),
                ],
              ),
              child: GlassmorphicCard(
                borderRadius: 70,
                padding: EdgeInsets.zero,
                child: Center(
                  child: Icon(
                    Icons.auto_awesome_outlined, 
                    size: 56, 
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.3 + 0.7 * value),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 56),
        Text(
          'Strategic Butler',
          style: AppTypography.headline.copyWith(letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Intelligent voice-driven management for your retail ecosystem.',
          style: AppTypography.body.copyWith(color: AppColors.gray400),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
