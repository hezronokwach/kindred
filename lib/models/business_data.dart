import '../services/serverpod_service.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;

// Re-export Serverpod models for compatibility
export 'package:kindred_butler_client/kindred_butler_client.dart' show Product, Expense, Account;

class BusinessData {
  static Future<List<client.Product>> getProducts() async {
    return await ServerpodService.getProducts();
  }

  static Future<client.Product?> updateStock(int productId, int newStock) async {
    return await ServerpodService.updateProductStock(productId, newStock);
  }

  static Future<bool> deleteProduct(int productId) async {
    return await ServerpodService.deleteProduct(productId);
  }

  static Future<client.Product> addProduct(client.Product product) async {
    return await ServerpodService.addProduct(product);
  }

  static Future<List<client.Expense>> getExpenses() async {
    return await ServerpodService.getExpenses();
  }
}

class AccountHelper {
  static Future<double> getAvailableFunds() async {
    return await ServerpodService.getAccountBalance();
  }
  
  static Future<void> debit(double amount, String description, String productName) async {
    final result = await ServerpodService.subtractFromBalance(amount);
    if (result == null) {
      throw Exception('Insufficient funds');
    }
    
    // Extract brand/supplier from product name
    String supplier = 'General Supplier';
    final words = productName.split(' ');
    if (words.isNotEmpty) {
      final brand = words[0];
      supplier = '$brand Supplier';
    }
    
    final expense = client.Expense(
      category: supplier,
      amount: amount,
      type: 'expense',
      productName: productName,
      description: description,
      date: DateTime.now(),
    );
    
    await ServerpodService.addExpense(expense);
  }

  static Future<void> recordExpense({
    required double amount, 
    required String category, 
    String? description
  }) async {
    final result = await ServerpodService.subtractFromBalance(amount);
    if (result == null) {
      throw Exception('Insufficient funds');
    }
    
    final expense = client.Expense(
      category: category,
      amount: amount,
      type: 'expense',
      productName: null,
      description: description ?? 'Operational expense for $category',
      date: DateTime.now(),
    );
    
    await ServerpodService.addExpense(expense);
  }
  
  static Future<bool> canAfford(double amount) async {
    final balance = await getAvailableFunds();
    return balance >= amount;
  }
}
