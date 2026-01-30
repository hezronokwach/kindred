import 'package:kindred_butler_client/kindred_butler_client.dart';

class ServerpodService {
  static late Client _client;
  
  static Client get client => _client;
  
  static Future<void> initialize(String serverUrl) async {
    _client = Client(serverUrl);
    await _initializeSampleData();
  }

  static Future<void> _initializeSampleData() async {
    try {
      await _client.seed.seedDatabase();
    } catch (e) {
      // Seeding failure
    }
  }

  // Product operations
  static Future<List<Product>> getProducts() async {
    try {
      return await _client.product.getAllProducts();
    } catch (e) {
      return [];
    }
  }

  static Future<Product?> getProductById(int id) async {
    try {
      return await _client.product.getProductById(id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Product>> getProductsByName(String name) async {
    try {
      return await _client.product.getProductsByName(name);
    } catch (e) {
      return [];
    }
  }

  static Future<Product?> updateProductStock(int id, int newStock) async {
    try {
      return await _client.product.updateStock(id, newStock);
    } catch (e) {
      return null;
    }
  }

  static Future<Product> addProduct(Product product) async {
    return await _client.product.createProduct(product);
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      return await _client.product.deleteProduct(id);
    } catch (e) {
      return false;
    }
  }

  // Account operations
  static Future<double> getAccountBalance() async {
    try {
      final account = await _client.account.getAccount();
      if (account != null) {
        return account.balance;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  static Future<Account> updateAccountBalance(double newBalance) async {
    return await _client.account.updateBalance(newBalance);
  }

  static Future<Account> addToBalance(double amount) async {
    return await _client.account.addToBalance(amount);
  }

  static Future<Account?> subtractFromBalance(double amount) async {
    try {
      return await _client.account.subtractFromBalance(amount);
    } catch (e) {
      return null;
    }
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
      return await _client.expense.getAllExpenses();
    } catch (e) {
      return [];
    }
  }

  static Future<List<Expense>> getExpensesByCategory(String category) async {
    try {
      return await _client.expense.getExpensesByCategory(category);
    } catch (e) {
      return [];
    }
  }

  static Future<Expense> addExpense(Expense expense) async {
    return await _client.expense.createExpense(expense);
  }

  static Future<bool> deleteExpense(int id) async {
    try {
      return await _client.expense.deleteExpense(id);
    } catch (e) {
      return false;
    }
  }
}
