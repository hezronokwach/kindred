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
    
    // 2. Check Alerts (Manual Check)
    if (entities.containsKey('check_alerts')) {
      // Logic to scan products against "hardcoded" rules or fetched alerts from DB
      // For this hackathon scope, we'll implement the logic directly
      
      List<String> activeAlerts = [];
      
      // Stock Checks
      for (var p in products) {
        if (p.stockCount < p.minStockThreshold) {
          activeAlerts.add('⚠️ **${p.name}** is low (${p.stockCount} remaining). Reorder needed.');
        }
      }
      
      // Expense Checks (Simple monthly check)
      final now = DateTime.now();
      final thisMonthExpense = expenses.where((e) => e.type == 'expense' && e.date.month == now.month).fold(0.0, (sum, e) => sum + e.amount);
      if (thisMonthExpense > 5000) { // Example threshold
        activeAlerts.add('💸 **High Spending**: \$${thisMonthExpense.toStringAsFixed(0)} this month.');
      }

      if (activeAlerts.isEmpty) {
         return MorphicState(
          intent: intent,
          uiMode: UIMode.narrative,
          headerText: '✅ All Clear',
          narrative: 'No active alerts. Inventory and spending look stable.',
          confidence: 1.0,
        );
      }

      return MorphicState(
        intent: intent,
        uiMode: UIMode.narrative, // Could be a list in future
        headerText: '🚨 Active Alerts',
        narrative: activeAlerts.join('\n\n'),
        confidence: 1.0,
      );
    }

    return MorphicState.initial();
  }
}
