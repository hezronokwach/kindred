import '../models/morphic_state.dart';
import '../models/business_data.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import 'intent_handler.dart';

class InventoryHandler implements IntentHandler {
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
    String? actionType;


    if (intent == Intent.updateStock || intent == Intent.deleteProduct || intent == Intent.addProduct) {
      actionType = intent.name;
      final productName = entities['product_name'];

      if (intent == Intent.addProduct) {
        data['action_type'] = actionType;
        data['action_data'] = {
          'product_name': productName,
          'product_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'current_stock': 0,
          'quantity': int.tryParse(entities['quantity']?.toString() ?? '1') ?? 1,
          'price': double.tryParse(entities['price']?.toString() ?? '100.0') ?? 100.0,
          'stock': int.tryParse(entities['quantity']?.toString() ?? '1') ?? 1,
          'product_price': double.tryParse(entities['price']?.toString() ?? '100.0') ?? 100.0,
        };
      } else if (products.isNotEmpty) {
        final productName = entities['product_name']?.toString() ?? '';
        final product = products.firstWhere(
          (p) => p.name.toLowerCase().contains(productName.toLowerCase()),
          orElse: () => products.first,
        );

        final quantityValue = entities['quantity'];
        int quantity = 0;
        if (quantityValue is int) {
          quantity = quantityValue;
        } else if (quantityValue is double) {
          quantity = quantityValue.toInt();
        } else if (quantityValue is String) {
          quantity = int.tryParse(quantityValue) ?? 1;
        } else {
          quantity = 1;
        }

        data['action_type'] = actionType;
        data['action_data'] = {
          'product_name': product.name,
          'product_id': product.id?.toString() ?? '0',
          'current_stock': product.stockCount,
          'quantity': quantity,
          'price': product.sellingPrice,
          'stock': 0,
          'product_price': product.sellingPrice,
        };
      }
    } else if (intent == Intent.inventory) {
      if (entities.containsKey('predict_stock')) {
        final productName = entities['product_name']?.toString() ?? '';
        final product = products.firstWhere(
          (p) => p.name.toLowerCase().contains(productName.toLowerCase()),
          orElse: () => products.first,
        );

        // Calculate velocity from sale history (type == 'sale')
        final sales = expenses.where((e) =>
          e.type == 'sale' && (e.productName?.toLowerCase().contains(product.name.toLowerCase()) ?? false)
        ).toList();

        if (sales.isEmpty) {
          return MorphicState(
            intent: intent,
            uiMode: UIMode.narrative,
            narrative: 'I don\'t have enough sales history for ${product.name} to make a prediction yet.',
            headerText: '⏳ Prediction Unavailable',
            confidence: 1.0,
          );
        }

        // Logic: Total units sold / days since first sale
        final totalUnits = sales.length; // 1 expense = 1 sale in our simplified seed
        final oldestSale = sales.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
        final daysSpan = DateTime.now().difference(oldestSale).inDays.clamp(1, 365);
        final unitsPerDay = totalUnits / daysSpan;
        final daysUntilEmpty = (product.stockCount / (unitsPerDay > 0 ? unitsPerDay : 0.01)).round();
        final depletionDate = DateTime.now().add(Duration(days: daysUntilEmpty));

        return MorphicState(
          intent: intent,
          uiMode: UIMode.narrative,
          headerText: '⏳ Stock Prediction',
          narrative: 'Based on current sales of ${unitsPerDay.toStringAsFixed(1)} units/day, your ${product.name} will run out in **$daysUntilEmpty days** (around ${depletionDate.month}/${depletionDate.day}).',
          confidence: 1.0,
        );
      }

      if (entities.containsKey('smart_reorder')) {
        final urgent = products.where((p) => p.stockCount <= p.minStockThreshold).toList();
        final popular = products.where((p) {
          final salesCount = expenses.where((e) => e.type == 'sale' && e.productName == p.name).length;
          return salesCount > 10; // High popularity threshold
        }).toList();

        final recommendations = {...urgent, ...popular}.toList();
        recommendations.sort((a, b) => a.stockCount.compareTo(b.stockCount));

        return MorphicState(
          intent: intent,
          uiMode: UIMode.table,
          headerText: '🎯 Smart Reorder List',
          narrative: 'I recommend reordering these ${recommendations.length} items. ${urgent.length} are at or below their minimum stock threshold, and others are high-velocity items.',
          data: {'products': recommendations.take(5).toList()},
          confidence: 1.0,
        );
      }

      var filteredProducts = products;

      if (entities.containsKey('stock_filter')) {
        final filter = entities['stock_filter'].toString();
        if (filter.startsWith('<')) {
          final threshold = int.tryParse(filter.substring(1)) ?? 0;
          filteredProducts = filteredProducts.where((p) => p.stockCount < threshold).toList();
        } else if (filter.startsWith('>')) {
          final threshold = int.tryParse(filter.substring(1)) ?? 0;
          filteredProducts = filteredProducts.where((p) => p.stockCount > threshold).toList();
        } else {
          // Default to less than if no prefix
          final threshold = int.tryParse(filter) ?? 999;
          filteredProducts = filteredProducts.where((p) => p.stockCount < threshold).toList();
        }
      }

      if (entities.containsKey('price_filter')) {
        final filter = entities['price_filter'].toString();
        if (filter.startsWith('<')) {
          final threshold = double.tryParse(filter.substring(1)) ?? 0;
          filteredProducts = filteredProducts.where((p) => p.sellingPrice < threshold).toList();
        } else if (filter.startsWith('>')) {
          final threshold = double.tryParse(filter.substring(1)) ?? 0;
          filteredProducts = filteredProducts.where((p) => p.sellingPrice > threshold).toList();
        } else {
          // Default to less than if no prefix
          final threshold = double.tryParse(filter) ?? 99999.0;
          filteredProducts = filteredProducts.where((p) => p.sellingPrice < threshold).toList();
        }
      }

      if (entities.containsKey('product_name')) {
        final productName = entities['product_name'].toString().toLowerCase();
        final genericWords = ['product', 'shoe', 'item', 'inventory', 'sneaker'];
        if (!genericWords.contains(productName)) {
          filteredProducts = filteredProducts.where(
            (p) => p.name.toLowerCase().contains(productName)
          ).toList();
        }
      }

      if (entities.containsKey('sort_by')) {
        final sortBy = entities['sort_by'].toString();
        switch (sortBy) {
          case 'stock_asc':
            filteredProducts.sort((a, b) => a.stockCount.compareTo(b.stockCount));
            break;
          case 'stock_desc':
            filteredProducts.sort((a, b) => b.stockCount.compareTo(a.stockCount));
            break;
          case 'price_asc':
            filteredProducts.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
            break;
          case 'price_desc':
            filteredProducts.sort((a, b) => b.sellingPrice.compareTo(a.sellingPrice));
            break;
        }
      }

      if (entities.containsKey('limit')) {
        final limit = entities['limit'];
        if (limit is int && limit > 0 && filteredProducts.isNotEmpty) {
          filteredProducts = filteredProducts.take(limit).toList();
        } else if (limit is String) {
          final limitInt = int.tryParse(limit);
          if (limitInt != null && limitInt > 0 && filteredProducts.isNotEmpty) {
            filteredProducts = filteredProducts.take(limitInt).toList();
          }
        }
      }

      data['products'] = filteredProducts;
    }

    return MorphicState(
      intent: intent,
      uiMode: uiMode,
      narrative: narrative,
      headerText: headerText,
      data: data,
      confidence: 1.0,
    );
  }
}
