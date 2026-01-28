import '../models/morphic_state.dart' as morphic;
import '../models/business_data.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;

class ActionService {
  Future<morphic.MorphicState> handleActionConfirm(
    String actionType, 
    Map<String, dynamic> actionData
  ) async {
    final productId = actionData['product_id'] as String?;
    final productName = actionData['product_name'] as String;
    
    switch (actionType) {
      case 'updateStock':
        final quantity = actionData['quantity'] as int;
        final currentStock = actionData['current_stock'] as int;
        final productPrice = actionData['product_price'] as double;
        final totalCost = quantity * productPrice;
        final newStock = currentStock + quantity;
        
        if (!(await AccountHelper.canAfford(totalCost))) {
          final availableFunds = await AccountHelper.getAvailableFunds();
          return morphic.MorphicState(
            intent: morphic.Intent.unknown,
            uiMode: morphic.UIMode.narrative,
            narrative: 'Insufficient funds! You need \$${totalCost.toStringAsFixed(2)} but only have \$${availableFunds.toStringAsFixed(2)} available.',
            headerText: 'Order Failed',
            confidence: 1.0,
          );
        } else if (productId != null) {
          final productIdInt = int.tryParse(productId) ?? 0;
          await BusinessData.updateStock(productIdInt, newStock);
          await AccountHelper.debit(totalCost, 'Purchased $quantity units of $productName', productName);
          final newBalance = await AccountHelper.getAvailableFunds();
          return morphic.MorphicState(
            intent: morphic.Intent.inventory,
            uiMode: morphic.UIMode.narrative,
            narrative: 'Order placed! $productName now has $newStock units. \$${totalCost.toStringAsFixed(2)} deducted. New balance: \$${newBalance.toStringAsFixed(2)}',
            headerText: 'Success',
            confidence: 1.0,
          );
        }
        break;
      case 'deleteProduct':
        if (productId != null) {
          final productIdInt = int.tryParse(productId) ?? 0;
          await BusinessData.deleteProduct(productIdInt);
          return morphic.MorphicState(
            intent: morphic.Intent.inventory,
            uiMode: morphic.UIMode.narrative,
            narrative: '$productName has been removed from inventory.',
            headerText: 'Product Deleted',
            confidence: 1.0,
          );
        }
        break;
      case 'addProduct':
        final quantity = actionData['quantity'] as int;
        final productPrice = actionData['product_price'] as double;
        final totalCost = quantity * productPrice;
        
        if (!(await AccountHelper.canAfford(totalCost))) {
          final availableFunds = await AccountHelper.getAvailableFunds();
          return morphic.MorphicState(
            intent: morphic.Intent.unknown,
            uiMode: morphic.UIMode.narrative,
            narrative: 'Insufficient funds! You need \$${totalCost.toStringAsFixed(2)} but only have \$${availableFunds.toStringAsFixed(2)} available.',
            headerText: 'Order Failed',
            confidence: 1.0,
          );
        } else {
          final newProduct = client.Product(
            name: productName,
            stockCount: quantity,
            price: productPrice,
            imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
            category: 'shoes',
          );
          await BusinessData.addProduct(newProduct);
          await AccountHelper.debit(totalCost, 'Purchased $quantity units of $productName', productName);
          final newBalance = await AccountHelper.getAvailableFunds();
          return morphic.MorphicState(
            intent: morphic.Intent.inventory,
            uiMode: morphic.UIMode.narrative,
            narrative: 'New product added! $productName with $quantity units. \$${totalCost.toStringAsFixed(2)} deducted. New balance: \$${newBalance.toStringAsFixed(2)}',
            headerText: 'Product Added',
            confidence: 1.0,
          );
        }
    }
    
    return morphic.MorphicState(
      intent: morphic.Intent.unknown,
      uiMode: morphic.UIMode.narrative,
      narrative: 'Action failed or unrecognized.',
      confidence: 0.0,
    );
  }
}
