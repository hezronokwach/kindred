import 'package:kindred_butler_client/kindred_butler_client.dart';

class ServerpodService {
  static late Client _client;
  
  static Future<void> initialize(String serverUrl) async {
    _client = Client(serverUrl);
    
    // Initialize with sample data if needed
    await _initializeSampleData();
  }

  static Future<void> _initializeSampleData() async {
    try {
      // Use the seed endpoint to initialize data
      final result = await _client.seed.seedDatabase();
      print('Seeding result: $result');
    } catch (e) {
      // Silently handle initialization errors
      print('Seeding failed: $e');
    }
  }



  // Product operations
  static Future<List<Product>> getProducts() async {
    return await _client.product.getAllProducts();
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
    final account = await _client.account.getAccount();
    return account?.balance ?? 0.0;
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

  // Expense operations
  static Future<List<Expense>> getExpenses() async {
    return await _client.expense.getAllExpenses();
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