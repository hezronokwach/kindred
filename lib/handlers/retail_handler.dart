import '../models/morphic_state.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import 'intent_handler.dart';

class RetailHandler implements IntentHandler {
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

    if (entities.containsKey('add_sale')) {
      final productName = entities['product_name']?.toString() ?? '';
      final product = products.firstWhere(
        (p) => p.name.toLowerCase().contains(productName.toLowerCase()),
        orElse: () => products.first,
      );
      
      final quantity = int.tryParse(entities['quantity']?.toString() ?? '1') ?? 1;

      data['action_type'] = 'addSale';
      data['action_data'] = {
        'product_name': product.name,
        'product_id': product.id?.toString() ?? '0',
        'quantity': quantity,
        'price': product.sellingPrice,
      };
      
      return MorphicState(
        intent: intent,
        uiMode: UIMode.action,
        headerText: 'Record Sale',
        narrative: 'Confirming sale of $quantity units of **${product.name}**.',
        data: data,
        confidence: 1.0,
      );
    }

    if (intent == Intent.retail && entities.containsKey('product_name') && products.isNotEmpty) {
      final productName = entities['product_name'].toString();
      final product = products.firstWhere(
        (p) => p.name.toLowerCase().contains(productName.toLowerCase()),
        orElse: () => products.first,
      );
      data['product'] = product;
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
