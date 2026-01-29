import '../models/morphic_state.dart';
import '../models/business_data.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import 'intent_handler.dart';
import '../services/serverpod_service.dart';

class AlertHandler implements IntentHandler {
  @override
  Future<MorphicState> handle({
    required Map<String, dynamic> response,
    required List<client.Product> products,
    required List<client.Expense> expenses,
    required Intent intent,
    required UIMode uiMode,
    required String narrative,
    String? headerText,
    required double confidence,
    required Map<String, dynamic> entities,
  }) async {
    // 1. Create Alert
    if (entities.containsKey('create_alert')) {
      final type = entities['alert_type'] ?? 'stock';
      final threshold = (entities['threshold'] as num?)?.toDouble() ?? 5.0;
      final comparison = entities['comparison'] ?? 'lt';
      final productFilter = entities['product_filter'];
      
      final alert = client.Alert(
        type: type,
        threshold: threshold,
        comparison: comparison,
        productFilter: productFilter,
        isActive: true,
        createdAt: DateTime.now(),
      );
      
      // Use the endpoint to save the alert
      await ServerpodService.client.alert.addAlert(alert);
      
      return MorphicState(
        intent: intent,
        uiMode: UIMode.narrative,
        headerText: '🔔 Alert Created',
        narrative: 'I will alert you when ${productFilter != null ? '$productFilter stock' : 'any stock'} drops below ${threshold.toInt()}.',
        confidence: 1.0,
      );
    }
    
    // 2. Check Alerts (Fetch from DB and evaluate)
    if (entities.containsKey('check_alerts')) {
      List<String> activeAlerts = [];
      
      // Fetch all active alerts from database
      final savedAlerts = await ServerpodService.client.alert.getAlerts();
      
      for (var alert in savedAlerts) {
        if (alert.type == 'stock') {
          // Stock alerts
          if (alert.productFilter != null) {
            // Specific product alert
            final product = products.firstWhere(
              (p) => p.name.toLowerCase().contains(alert.productFilter!.toLowerCase()),
              orElse: () => products.first,
            );
            
            if (_checkThreshold(product.stockCount.toDouble(), alert.threshold, alert.comparison)) {
              activeAlerts.add('⚠️ **${product.name}** stock is ${product.stockCount} (threshold: ${alert.threshold.toInt()})');
            }
          } else {
            // General stock alert (any product)
            for (var p in products) {
              if (_checkThreshold(p.stockCount.toDouble(), alert.threshold, alert.comparison)) {
                activeAlerts.add('⚠️ **${p.name}** stock is ${p.stockCount} (threshold: ${alert.threshold.toInt()})');
              }
            }
          }
        } else if (alert.type == 'expense') {
          // Expense alerts
          final now = DateTime.now();
          final thisMonthExpense = expenses
              .where((e) => e.type == 'expense' && e.date.month == now.month)
              .fold(0.0, (sum, e) => sum + e.amount);
          
          if (_checkThreshold(thisMonthExpense, alert.threshold, alert.comparison)) {
            activeAlerts.add('💸 **High Spending**: \$${thisMonthExpense.toStringAsFixed(0)} this month (threshold: \$${alert.threshold.toInt()})');
          }
        }
      }

      if (activeAlerts.isEmpty) {
        return MorphicState(
          intent: intent,
          uiMode: UIMode.narrative,
          headerText: '✅ All Clear',
          narrative: 'No active alerts. All thresholds are within safe limits.',
          confidence: 1.0,
        );
      }

      return MorphicState(
        intent: intent,
        uiMode: UIMode.narrative,
        headerText: '🚨 Active Alerts',
        narrative: activeAlerts.join('\n\n'),
        confidence: 1.0,
      );
    }

    return MorphicState.initial();
  }
  
  bool _checkThreshold(double value, double threshold, String comparison) {
    switch (comparison) {
      case 'lt':
        return value < threshold;
      case 'gt':
        return value > threshold;
      case 'lte':
        return value <= threshold;
      case 'gte':
        return value >= threshold;
      default:
        return value < threshold; // Default to less than
    }
  }
}
