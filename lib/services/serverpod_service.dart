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
      // Check if products exist
      final products = await _client.product.getAllProducts();
      if (products.isEmpty) {
        await _insertSampleProducts();
      }

      // Check if account exists
      final account = await _client.account.getAccount();
      if (account == null) {
        await _client.account.updateBalance(10000.00);
      }
    } catch (e) {
      // Silently handle initialization errors
    }
  }

  static Future<void> _insertSampleProducts() async {
    final sampleProducts = [
      Product(
        name: 'Nike Air Max 270',
        stockCount: 15,
        price: 120.00,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
        category: 'shoes',
      ),
      Product(
        name: 'Adidas Ultraboost 22',
        stockCount: 8,
        price: 180.00,
        imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa',
        category: 'shoes',
      ),
      Product(
        name: 'Converse Chuck Taylor',
        stockCount: 25,
        price: 65.00,
        imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772',
        category: 'shoes',
      ),
      Product(
        name: 'Vans Old Skool',
        stockCount: 12,
        price: 60.00,
        imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77',
        category: 'shoes',
      ),
      Product(
        name: 'Puma RS-X',
        stockCount: 6,
        price: 110.00,
        imageUrl: 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519',
        category: 'shoes',
      ),
    ];

    for (final product in sampleProducts) {
      await _client.product.createProduct(product);
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