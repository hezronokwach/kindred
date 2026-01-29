import '../models/morphic_state.dart';
import '../models/business_data.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import 'intent_handler.dart';

class ShortcutHandler implements IntentHandler {
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
    
    // 1. Daily Routine (Smart Reorder + Daily Sales)
    if (entities.containsKey('run_daily_routine')) {
      final now = DateTime.now();
      
      // Component 1: Daily Sales
      final dailySales = expenses.where((e) => 
        e.type == 'sale' && 
        e.date.year == now.year && e.date.month == now.month && e.date.day == now.day
      ).fold(0.0, (sum, e) => sum + e.amount);

      // Component 2: Smart Reorder (Urgent Items)
      final lowStockItems = products.where((p) => p.stockCount <= p.minStockThreshold).toList();

      return MorphicState(
        intent: intent,
        uiMode: UIMode.dashboard,
        headerText: '🌞 Daily Briefing',
        narrative: 'Here is your morning update. You have generated **\$${dailySales.toStringAsFixed(0)}** in sales today. There are **${lowStockItems.length}** items needing attention.',
        data: {
          'components': [
            {
              'type': 'table',
              'title': '🚨 Urgent Restock Needed',
              'data': lowStockItems,
            },
            {
              'type': 'chart',
              'title': '💰 Today\'s Sales Trend',
              'data': expenses.where((e) => e.type == 'sale' && e.date.year == now.year && e.date.month == now.month && e.date.day == now.day).toList(),
              'is_trend': true, // Use line chart for intraday if possible, or bar for categories
            }
          ]
        },
        confidence: 1.0,
      );
    }

    // 2. Weekly Routine (Trends + Profit)
    if (entities.containsKey('run_weekly_routine')) {
      final now = DateTime.now();
      final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
      
      // Component 1: Week vs Week Data Preparation
      Map<int, double> thisWeek = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0};
      Map<int, double> lastWeek = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0};

      for (var e in expenses.where((x) => x.type == 'expense')) {
        if (e.date.isAfter(startOfThisWeek)) {
          thisWeek[e.date.weekday] = (thisWeek[e.date.weekday] ?? 0) + e.amount;
        } else if (e.date.isAfter(startOfLastWeek) && e.date.isBefore(startOfThisWeek)) {
          lastWeek[e.date.weekday] = (lastWeek[e.date.weekday] ?? 0) + e.amount;
        }
      }

      // Component 2: Top Profit Products
      // Simplified: Just sort products by an estimated profit (selling - cost) * stock (potential) or sales history
      final topProducts = List<client.Product>.from(products);
      // Mock logic: Sort by margin for simplicity as we don't have per-product sales aggregated handy here without a heavy query
      topProducts.sort((a, b) => (b.sellingPrice - b.costPrice).compareTo(a.sellingPrice - a.costPrice));

      return MorphicState(
        intent: intent,
        uiMode: UIMode.dashboard,
        headerText: '📅 Weekly Review',
        narrative: 'Your weekly performance review. Spending is compared to last week.',
        data: {
          'components': [
            {
              'type': 'chart',
              'title': '📉 Spending: This Week vs Last',
              'data': [], // Dummy, we use comparisonData
              'is_comparison': true,
              'comparison_data': {
                'this_week': thisWeek,
                'last_week': lastWeek,
              }
            },
            {
              'type': 'table',
              'title': '🏆 Highest Margin Products',
              'data': topProducts.take(5).toList(),
            }
          ]
        },
        confidence: 1.0,
      );
    }
    
    return MorphicState.initial();
  }
}
