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
          'price': product.price,
          'stock': 0,
          'product_price': product.price,
        };
      }
    } else if (intent == Intent.inventory) {
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
          filteredProducts = filteredProducts.where((p) => p.price < threshold).toList();
        } else if (filter.startsWith('>')) {
          final threshold = double.tryParse(filter.substring(1)) ?? 0;
          filteredProducts = filteredProducts.where((p) => p.price > threshold).toList();
        } else {
          // Default to less than if no prefix
          final threshold = double.tryParse(filter) ?? 99999.0;
          filteredProducts = filteredProducts.where((p) => p.price < threshold).toList();
        }
      }

      if (entities.containsKey('product_name')) {
        final productName = entities['product_name'].toString();
        filteredProducts = filteredProducts.where(
          (p) => p.name.toLowerCase().contains(productName.toLowerCase())
        ).toList();
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
            filteredProducts.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 'price_desc':
            filteredProducts.sort((a, b) => b.price.compareTo(a.price));
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
