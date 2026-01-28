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
        
        final totalCost = quantity.toDouble() * product.price;
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
        final productFilter = entities['product_filter'].toString();
        filteredExpenses = filteredExpenses.where((e) {
          final productName = e.productName ?? '';
          return productName.toLowerCase().contains(productFilter.toLowerCase());
        }).toList();
      }
      
      if (entities.containsKey('category_filter')) {
        final categoryFilter = entities['category_filter'].toString();
        filteredExpenses = filteredExpenses.where((e) {
          return e.category.toLowerCase().contains(categoryFilter.toLowerCase());
        }).toList();
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
