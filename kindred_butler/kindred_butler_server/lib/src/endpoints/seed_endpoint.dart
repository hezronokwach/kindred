import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SeedEndpoint extends Endpoint {
  Future<String> seedDatabase(Session session) async {
    try {
      // Check if already seeded
      final existingProducts = await Product.db.find(session);
      final existingAccount = await Account.db.findFirstRow(session);
      
      if (existingProducts.isNotEmpty && existingAccount != null) {
        return 'Database already seeded. Products: ${existingProducts.length}, Account balance: \$${existingAccount.balance}';
      }
      
      // Seed products if empty
      if (existingProducts.isEmpty) {
        await _seedProducts(session);
      }
      
      // Seed account if empty
      if (existingAccount == null) {
        await _seedAccount(session);
      }
      
      final productCount = await Product.db.count(session);
      final account = await Account.db.findFirstRow(session);
      
      return 'Database seeded successfully! Products: $productCount, Account balance: \$${account?.balance ?? 0}';
    } catch (e) {
      return 'Seeding failed: $e';
    }
  }
  
  Future<void> _seedProducts(Session session) async {
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
      await Product.db.insertRow(session, product);
    }
  }
  
  Future<void> _seedAccount(Session session) async {
    final account = Account(
      balance: 10000.00,
      updatedAt: DateTime.now(),
    );
    
    await Account.db.insertRow(session, account);
  }
  
  Future<String> resetDatabase(Session session) async {
    try {
      // Delete all data
      await Product.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Account.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Expense.db.deleteWhere(session, where: (t) => Constant.bool(true));
      
      // Re-seed
      await _seedProducts(session);
      await _seedAccount(session);
      
      return 'Database reset and re-seeded successfully!';
    } catch (e) {
      return 'Reset failed: $e';
    }
  }
}