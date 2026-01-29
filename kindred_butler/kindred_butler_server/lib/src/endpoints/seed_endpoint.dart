import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SeedEndpoint extends Endpoint {
  Future<String> seedDatabase(Session session) async {
    try {
      // Check if already seeded
      final existingProducts = await Product.db.find(session);
      if (existingProducts.isNotEmpty) {
        return 'Database already seeded. Products: ${existingProducts.length}';
      }

      await _seedSuppliers(session);
      await _seedProducts(session);
      await _seedAccount(session);
      await _seedHistoricalData(session);

      final productCount = await Product.db.count(session);
      final supplierCount = await Supplier.db.count(session);
      final expenseCount = await Expense.db.count(session);
      final account = await Account.db.findFirstRow(session);

      return 'Database seeded successfully! \n'
          'Products: $productCount, Suppliers: $supplierCount, \n'
          'History: $expenseCount transactions, Balance: \$${account?.balance ?? 0}';
    } catch (e) {
      return 'Seeding failed: $e';
    }
  }

  Future<void> _seedSuppliers(Session session) async {
    final suppliers = [
      Supplier(
        name: 'Nike Logistics',
        contactPerson: 'Sarah Nike',
        email: 'sales@nike.com',
        phone: '+1-555-NIKE',
        leadTimeDays: 3,
      ),
      Supplier(
        name: 'Adidas Global',
        contactPerson: 'Ben Adi',
        email: 'ben@adidas.com',
        phone: '+49-555-ADI',
        leadTimeDays: 4,
      ),
      Supplier(
        name: 'Footwear Central',
        contactPerson: 'John Foot',
        email: 'john@footwear.com',
        phone: '+254-700-000000',
        leadTimeDays: 2,
      ),
    ];

    for (final s in suppliers) {
      await Supplier.db.insertRow(session, s);
    }
  }

  Future<void> _seedProducts(Session session) async {
    final suppliers = await Supplier.db.find(session);
    final nikeId = suppliers.firstWhere((s) => s.name.contains('Nike')).id;
    final adiId = suppliers.firstWhere((s) => s.name.contains('Adidas')).id;
    final centralId = suppliers.firstWhere((s) => s.name.contains('Central')).id;

    final sampleProducts = [
      Product(
        name: 'Nike Air Max 270',
        stockCount: 15,
        sellingPrice: 120.00,
        costPrice: 80.00,
        brand: 'Nike',
        sku: 'NK-AM-270-RD',
        minStockThreshold: 5,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
        category: 'shoes',
        supplierId: nikeId,
      ),
      Product(
        name: 'Adidas Ultraboost 22',
        stockCount: 8,
        sellingPrice: 180.00,
        costPrice: 120.00,
        brand: 'Adidas',
        sku: 'AD-UB-22-WH',
        minStockThreshold: 4,
        imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa',
        category: 'shoes',
        supplierId: adiId,
      ),
      Product(
        name: 'Converse Chuck Taylor',
        stockCount: 25,
        sellingPrice: 65.00,
        costPrice: 35.00,
        brand: 'Converse',
        sku: 'CV-CT-CL-BK',
        minStockThreshold: 10,
        imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772',
        category: 'shoes',
        supplierId: centralId,
      ),
      Product(
        name: 'Vans Old Skool',
        stockCount: 12,
        sellingPrice: 60.00,
        costPrice: 30.00,
        brand: 'Vans',
        sku: 'VN-OS-CL-BL',
        minStockThreshold: 6,
        imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77',
        category: 'shoes',
        supplierId: centralId,
      ),
      Product(
        name: 'Puma RS-X',
        stockCount: 6,
        sellingPrice: 110.00,
        costPrice: 70.00,
        brand: 'Puma',
        sku: 'PM-RX-01-GR',
        minStockThreshold: 3,
        imageUrl: 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519',
        category: 'shoes',
        supplierId: centralId,
      ),
    ];

    for (final product in sampleProducts) {
      await Product.db.insertRow(session, product);
    }
  }

  Future<void> _seedAccount(Session session) async {
    await Account.db.deleteWhere(session, where: (t) => Constant.bool(true));
    final account = Account(
      balance: 10000.00,
      updatedAt: DateTime.now(),
    );
    await Account.db.insertRow(session, account);
  }

  Future<void> _seedHistoricalData(Session session) async {
    final products = await Product.db.find(session);
    final random = Random();
    final now = DateTime.now();

    // Generate data for the last 30 days
    for (int i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        
        // 1. Seed some Sales (Income)
        final salesPerDay = random.nextInt(5) + 2; // 2-6 sales per day
        for (int s = 0; s < salesPerDay; s++) {
            final product = products[random.nextInt(products.length)];
            final quantity = random.nextInt(2) + 1;
            final amount = product.sellingPrice * quantity;
            
            await Expense.db.insertRow(session, Expense(
                category: 'Sales',
                amount: amount,
                type: 'sale',
                productName: product.name,
                description: 'Sold $quantity ${product.brand} units',
                paymentMethod: random.nextBool() ? 'M-Pesa' : 'Cash',
                date: date,
            ));
        }

        // 2. Seed some Expenses (Costs)
        if (random.nextInt(10) > 7) { // 20% chance of operational expense per day
            final categories = ['Rent', 'Electricity', 'Marketing', 'Internet'];
            final category = categories[random.nextInt(categories.length)];
            final amount = (random.nextInt(100) + 50).toDouble();

            await Expense.db.insertRow(session, Expense(
                category: category,
                amount: amount,
                type: 'expense',
                description: 'Monthly $category payment',
                paymentMethod: 'Bank Transfer',
                date: date,
            ));
        }
    }
  }

  Future<String> resetDatabase(Session session) async {
    try {
      await Expense.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Product.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Supplier.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Account.db.deleteWhere(session, where: (t) => Constant.bool(true));
      
      return await seedDatabase(session);
    } catch (e) {
      return 'Reset failed: $e';
    }
  }
}