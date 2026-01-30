import '../models/morphic_state.dart';
import '../models/business_data.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import 'intent_handler.dart';

class FinanceHandler implements IntentHandler {
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
    Map<String, dynamic> data = {};
    

    if (intent == Intent.accountBalance) {
      final productName = entities['product_name']?.toString();
      final quantityValue = entities['quantity'];
      
      int quantity = 1;
      if (quantityValue is int) {
        quantity = quantityValue;
      } else if (quantityValue is double) {
        quantity = quantityValue.toInt();
      } else if (quantityValue is String) {
        quantity = int.tryParse(quantityValue) ?? 1;
      }

      if (productName != null && products.isNotEmpty) {
        final product = products.firstWhere(
          (p) => p.name.toLowerCase().contains(productName.toLowerCase()),
          orElse: () => products.first,
        );
        
        final totalCost = quantity.toDouble() * product.sellingPrice;
        final balance = await AccountHelper.getAvailableFunds();
        final canAfford = balance >= totalCost;
        
        final affordabilityText = canAfford 
          ? 'Yes! $quantity ${product.name} will cost \$${totalCost.toStringAsFixed(0)}. You have \$${balance.toStringAsFixed(0)} available.'
          : 'No, unfortunately. $quantity ${product.name} costs \$${totalCost.toStringAsFixed(0)}, but your balance is \$${balance.toStringAsFixed(0)}.';
        
        return MorphicState(
          intent: intent,
          uiMode: UIMode.narrative,
          narrative: affordabilityText,
          headerText: 'Affordability Check',
          data: {},
          confidence: 1.0,
        );
      } else {
        final balance = await AccountHelper.getAvailableFunds();
        return MorphicState(
          intent: intent,
          uiMode: UIMode.narrative,
          narrative: 'Your current account balance is \$${balance.toStringAsFixed(2)}.',
          headerText: 'Account Balance',
          data: {},
          confidence: 1.0,
        );
      }
    } else if (intent == Intent.finance) {
      if (entities.containsKey('profit_analysis')) {
        final productName = entities['product_name']?.toString() ?? '';
        final relevantSales = expenses.where((e) => 
          e.type == 'sale' && 
          (productName.isEmpty || (e.productName?.toLowerCase().contains(productName.toLowerCase()) ?? false))
        ).toList();

        double totalRevenue = 0;
        double totalCost = 0;

        for (var sale in relevantSales) {
          totalRevenue += sale.amount;
          final product = products.firstWhere(
            (p) => p.name.toLowerCase() == sale.productName?.toLowerCase(),
            orElse: () => products.firstWhere((p) => p.name.contains(sale.productName ?? ''), orElse: () => products.first),
          );
          totalCost += product.costPrice * (sale.amount / product.sellingPrice);
        }

        final profit = totalRevenue - totalCost;
        final margin = totalRevenue > 0 ? (profit / totalRevenue * 100) : 0.0;

        return MorphicState(
          intent: intent,
          uiMode: UIMode.chart,
          headerText: '💰 Profit Analysis',
          narrative: 'You have generated **\$${profit.toStringAsFixed(0)}** in profit${productName.isNotEmpty ? ' from $productName' : ''} on revenue of \$${totalRevenue.toStringAsFixed(0)}. Your current margin is **${margin.toStringAsFixed(1)}%**.',
          data: {
            'expenses': relevantSales,
            'is_trend': true,
          },
          confidence: 1.0,
        );
      }

      if (entities.containsKey('trend_analysis')) {
        final now = DateTime.now();
        final thisMonth = expenses.where((e) => e.type == 'expense' && e.date.month == now.month && e.date.year == now.year).fold(0.0, (sum, e) => sum + e.amount);
        final lastMonth = expenses.where((e) => e.type == 'expense' && e.date.month == now.month - 1 && e.date.year == now.year).fold(0.0, (sum, e) => sum + e.amount);
        
        final diff = thisMonth - lastMonth;
        final percentage = lastMonth > 0 ? (diff / lastMonth * 100).abs() : 0.0;
        final trend = diff > 0 ? 'increased by' : 'decreased by';

        return MorphicState(
          intent: intent,
          uiMode: UIMode.chart,
          headerText: '📊 Spending Trend',
          narrative: 'Your operational spending this month (\$${thisMonth.toStringAsFixed(0)}) has $trend **${percentage.toStringAsFixed(1)}%** compared to last month (\$${lastMonth.toStringAsFixed(0)}).',
          data: {
            'expenses': expenses.where((e) => e.type == 'expense').toList(),
            'is_trend': true,
          },
          confidence: 1.0,
        );
      }

      if (entities.containsKey('predict_expenses') || entities.containsKey('predict_revenue')) {
        final isRevenue = entities.containsKey('predict_revenue');
        final type = isRevenue ? 'sale' : 'expense';
        final now = DateTime.now();
        // Get last 30 days data
        final last30Days = expenses.where((e) => 
          e.type == type && 
          e.date.isAfter(now.subtract(const Duration(days: 30)))
        ).toList();

        final totalAmount = last30Days.fold(0.0, (sum, e) => sum + e.amount);
        final dailyAverage = totalAmount / 30; // Simple linear projection
        final nextMonthProjection = dailyAverage * 30;

        return MorphicState(
          intent: intent,
          uiMode: UIMode.narrative,
          headerText: isRevenue ? '🔮 Revenue Forecast' : '🔮 Expense Forecast',
          narrative: 'Based on the last 30 days, your projected ${isRevenue ? 'revenue' : 'expenses'} for next month is **\$${nextMonthProjection.toStringAsFixed(0)}** (avg \$${dailyAverage.toStringAsFixed(0)}/day).',
          data: {},
          confidence: 1.0,
        );
      }

      if (entities.containsKey('compare_weekly')) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final startOfThisWeek = today.subtract(Duration(days: today.weekday - 1));
        final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
        
        // Group by Day of Week (Monday=1, Sunday=7)
        Map<int, double> thisWeek = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0};
        Map<int, double> lastWeek = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0};

        for (var e in expenses.where((x) => x.type == 'expense')) {
          if (e.date.isAfter(startOfThisWeek)) {
            thisWeek[e.date.weekday] = (thisWeek[e.date.weekday] ?? 0) + e.amount;
          } else if (e.date.isAfter(startOfLastWeek) && e.date.isBefore(startOfThisWeek)) {
            lastWeek[e.date.weekday] = (lastWeek[e.date.weekday] ?? 0) + e.amount;
          }
        }

        final thisWeekTotal = thisWeek.values.fold(0.0, (sum, v) => sum + v);
        final lastWeekTotal = lastWeek.values.fold(0.0, (sum, v) => sum + v);
        final diff = thisWeekTotal - lastWeekTotal;

        return MorphicState(
          intent: intent,
          uiMode: UIMode.chart,
          headerText: '📅 Weekly Comparison',
          narrative: 'You have spent **\$${thisWeekTotal.toStringAsFixed(0)}** this week vs **\$${lastWeekTotal.toStringAsFixed(0)}** last week (${diff >= 0 ? '+' : ''}\$${diff.toStringAsFixed(0)}).',
          data: {
            'this_week': thisWeek,
            'last_week': lastWeek,
            'is_comparison': true,
          },
          confidence: 1.0,
        );
      }

      if (entities.containsKey('calculate_total')) {
        final timeFilterRaw = entities['time_filter']?.toString().toLowerCase().replaceAll(' ', '_') ?? 'today';
        final now = DateTime.now();
        List<client.Expense> periodExpenses = [];
        String periodName = '';

        if (timeFilterRaw == 'today') {
          periodExpenses = expenses.where((e) => e.type == 'expense' && e.date.year == now.year && e.date.month == now.month && e.date.day == now.day).toList();
          periodName = 'today';
        } else if (timeFilterRaw == 'this_week' || timeFilterRaw == 'week' || timeFilterRaw == 'last_7_days') {
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          periodExpenses = expenses.where((e) => e.type == 'expense' && e.date.isAfter(startOfWeek)).toList();
          periodName = 'this week';
        } else if (timeFilterRaw == 'this_month' || timeFilterRaw == 'month') {
          periodExpenses = expenses.where((e) => e.type == 'expense' && e.date.month == now.month && e.date.year == now.year).toList();
          periodName = 'this month';
        } else {
          // Default fallback
          periodExpenses = expenses.where((e) => e.type == 'expense').toList();
          periodName = 'all time';
        }

        final total = periodExpenses.fold(0.0, (sum, e) => sum + e.amount);
        
        return MorphicState(
          intent: intent,
          uiMode: UIMode.chart,
          headerText: '💰 Total Expenses',
          narrative: 'Your total business expenses for **$periodName** are **\$${total.toStringAsFixed(2)}**.',
          data: {
            'expenses': periodExpenses,
            'is_trend': periodExpenses.length > 1,
          },
          confidence: 1.0,
        );
      }

      if (entities.containsKey('add_expense')) {
        final amount = entities['amount'];
        final category = entities['category']?.toString() ?? 'Utilities';
        
        return MorphicState(
          intent: intent,
          uiMode: UIMode.action,
          headerText: 'Record Expense',
          narrative: 'Confirming operational expense for **$category**.',
          data: {
            'action_type': 'addExpense',
            'action_data': {
              'amount': amount is num ? amount.toDouble() : double.tryParse(amount.toString()) ?? 0.0,
              'category': category,
            },
          },
          confidence: 1.0,
        );
      }

      var filteredExpenses = expenses;
      
      if (entities.containsKey('time_filter')) {
        final timeFilter = entities['time_filter'].toString();
        final now = DateTime.now();
        
        switch (timeFilter) {
          case 'today':
            filteredExpenses = filteredExpenses.where((e) {
              final expenseDate = e.date;
              return expenseDate.year == now.year &&
                     expenseDate.month == now.month &&
                     expenseDate.day == now.day;
            }).toList();
            break;
          case 'last_week':
            final weekAgo = now.subtract(const Duration(days: 7));
            filteredExpenses = filteredExpenses.where((e) => e.date.isAfter(weekAgo)).toList();
            break;
          case 'last_month':
            final monthAgo = DateTime(now.year, now.month - 1, now.day);
            filteredExpenses = filteredExpenses.where((e) => e.date.isAfter(monthAgo)).toList();
            break;
        }
      }
      
      if (entities.containsKey('product_filter')) {
        final productFilter = entities['product_filter'].toString().toLowerCase();
        final genericWords = ['product', 'shoe', 'item', 'expense', 'transaction'];
        if (!genericWords.contains(productFilter)) {
          filteredExpenses = filteredExpenses.where((e) {
            final productName = e.productName ?? '';
            return productName.toLowerCase().contains(productFilter);
          }).toList();
        }
      }
      
      if (entities.containsKey('category_filter')) {
        final categoryFilter = entities['category_filter'].toString().toLowerCase();
        final genericWords = ['category', 'expense', 'summary', 'finance'];
        if (!genericWords.contains(categoryFilter)) {
          filteredExpenses = filteredExpenses.where((e) {
            return e.category.toLowerCase().contains(categoryFilter);
          }).toList();
        }
      }
      
      if (entities.containsKey('category_extremum')) {
        // Special logic: Group by category first
        final Map<String, double> categoryTotals = {};
        for (var e in expenses) {
          categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
        }
        
        final sortedCategories = categoryTotals.entries.toList();
        final extremumType = entities['category_extremum'].toString();
        
        if (extremumType == 'lowest') {
          sortedCategories.sort((a, b) => a.value.compareTo(b.value));
        } else if (extremumType == 'highest') {
          sortedCategories.sort((a, b) => b.value.compareTo(a.value));
        }
        
        if (sortedCategories.isNotEmpty) {
          final topCategory = sortedCategories.first;
          filteredExpenses = expenses.where((e) => e.category == topCategory.key).toList();
          // We can also add specifically focused data here if needed
          data['top_category'] = topCategory.key;
          data['top_amount'] = topCategory.value;
        }
      } else if (entities.containsKey('sort_by')) {
        final sortBy = entities['sort_by'].toString();
        switch (sortBy) {
          case 'amount_desc':
            filteredExpenses.sort((a, b) => b.amount.compareTo(a.amount));
            break;
          case 'amount_asc':
            filteredExpenses.sort((a, b) => a.amount.compareTo(b.amount));
            break;
          case 'date_desc':
            filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
            break;
          case 'date_asc':
            filteredExpenses.sort((a, b) => a.date.compareTo(b.date));
            break;
        }
      }
      
      if (entities.containsKey('limit')) {
        final limit = entities['limit'];
        if (limit is int && limit > 0 && filteredExpenses.isNotEmpty) {
          filteredExpenses = filteredExpenses.take(limit).toList();
        } else if (limit is String) {
          final limitInt = int.tryParse(limit);
          if (limitInt != null && limitInt > 0 && filteredExpenses.isNotEmpty) {
            filteredExpenses = filteredExpenses.take(limitInt).toList();
          }
        }
      }
      
      data['expenses'] = filteredExpenses;
    }

    return MorphicState(
      intent: intent,
      uiMode: uiMode,
      narrative: narrative,
      headerText: headerText,
      data: data,
      confidence: confidence,
    );
  }
}
