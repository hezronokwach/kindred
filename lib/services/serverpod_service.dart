import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart';

class ServerpodService {
  static late Client _client;
  
  static Future<void> initialize(String serverUrl) async {
    _client = Client(serverUrl);
    await _initializeSampleData();
  }

  static Future<void> _initializeSampleData() async {
    try {
      await _client.seed.seedDatabase();
    } catch (e) {
      print('Seeding failed: $e');
    }
  }

  // Caching helpers
  static Future<void> _saveToCache(String key, dynamic data) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$key.cache');
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Cache save failed: $e');
    }
  }

  static Future<dynamic> _loadFromCache(String key) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$key.cache');
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      print('Cache load failed: $e');
    }
    return null;
  }

  // Product operations
  static Future<List<Product>> getProducts() async {
    try {
      final products = await _client.product.getAllProducts();
      await _saveToCache('products', products.map((p) => p.toJson()).toList());
      return products;
    } catch (e) {
      final cached = await _loadFromCache('products') as List?;
      if (cached != null) {
        return cached.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    }
  }

  static Future<Product?> getProductById(int id) async {
    return await _client.product.getProductById(id);
  }

  static Future<List<Product>> getProductsByName(String name) async {
    return await _client.product.getProductsByName(name);
  }

  static Future<Product?> updateProductStock(int id, int newStock) async {
    return await _client.product.updateStock(id, newStock);
  }

  static Future<Product> addProduct(Product product) async {
    return await _client.product.createProduct(product);
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      await _client.product.deleteProduct(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Account operations
  static Future<double> getAccountBalance() async {
    try {
      final account = await _client.account.getAccount();
      if (account != null) {
        await _saveToCache('balance', account.balance);
        return account.balance;
      }
      return 0.0;
    } catch (e) {
      final cached = await _loadFromCache('balance') as double?;
      return cached ?? 0.0;
    }
  }

  static Future<Account> updateAccountBalance(double newBalance) async {
    return await _client.account.updateBalance(newBalance);
  }

  static Future<Account> addToBalance(double amount) async {
    return await _client.account.addToBalance(amount);
  }

  static Future<Account?> subtractFromBalance(double amount) async {
    return await _client.account.subtractFromBalance(amount);
  }

  // Seed operations
  static Future<String> seedDatabase() async {
    return await _client.seed.seedDatabase();
  }

  static Future<String> resetDatabase() async {
    return await _client.seed.resetDatabase();
  }

  // Test operations
  static Future<Map<String, dynamic>> runAllTests() async {
    return await _client.test.runAllTests();
  }

  static Future<String> getSystemStatus() async {
    return await _client.test.getSystemStatus();
  }

  // Expense operations
  static Future<List<Expense>> getExpenses() async {
    try {
      final expenses = await _client.expense.getAllExpenses();
      await _saveToCache('expenses', expenses.map((e) => e.toJson()).toList());
      return expenses;
    } catch (e) {
      final cached = await _loadFromCache('expenses') as List?;
      if (cached != null) {
        return cached.map((json) => Expense.fromJson(json)).toList();
      }
      return [];
    }
  }

  static Future<List<Expense>> getExpensesByCategory(String category) async {
    return await _client.expense.getExpensesByCategory(category);
  }

  static Future<Expense> addExpense(Expense expense) async {
    return await _client.expense.createExpense(expense);
  }

  static Future<bool> deleteExpense(int id) async {
    return await _client.expense.deleteExpense(id);
  }
}