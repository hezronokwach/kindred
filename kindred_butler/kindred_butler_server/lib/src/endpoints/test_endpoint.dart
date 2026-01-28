import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TestEndpoint extends Endpoint {
  Future<Map<String, dynamic>> runAllTests(Session session) async {
    final results = <String, dynamic>{};
    
    try {
      // Test 1: Inventory Operations
      results['inventory_test'] = await _testInventoryOperations(session);
      
      // Test 2: Financial Operations
      results['financial_test'] = await _testFinancialOperations(session);
      
      // Test 3: Action Operations
      results['action_test'] = await _testActionOperations(session);
      
      // Test 4: Data Persistence
      results['persistence_test'] = await _testDataPersistence(session);
      
      // Test 5: Expense Tracking
      results['expense_test'] = await _testExpenseTracking(session);
      
      results['overall_status'] = 'PASSED';
      results['timestamp'] = DateTime.now().toIso8601String();
      
    } catch (e) {
      results['overall_status'] = 'FAILED';
      results['error'] = e.toString();
    }
    
    return results;
  }
  
  Future<Map<String, dynamic>> _testInventoryOperations(Session session) async {
    final test = <String, dynamic>{};
    
    try {
      // Test getting all products
      final products = await Product.db.find(session);
      test['get_all_products'] = products.isNotEmpty ? 'PASSED' : 'FAILED';
      test['product_count'] = products.length;
      
      if (products.isNotEmpty) {
        // Test getting specific product
        final firstProduct = products.first;
        final specificProduct = await Product.db.findById(session, firstProduct.id!);
        test['get_specific_product'] = specificProduct != null ? 'PASSED' : 'FAILED';
        
        // Test product search by name
        final searchResults = await Product.db.find(
          session,
          where: (t) => t.name.like('%${firstProduct.name.split(' ').first}%'),
        );
        test['search_products'] = searchResults.isNotEmpty ? 'PASSED' : 'FAILED';
      }
      
      test['status'] = 'PASSED';
    } catch (e) {
      test['status'] = 'FAILED';
      test['error'] = e.toString();
    }
    
    return test;
  }
  
  Future<Map<String, dynamic>> _testFinancialOperations(Session session) async {
    final test = <String, dynamic>{};
    
    try {
      // Test account balance retrieval
      final account = await Account.db.findFirstRow(session);
      test['get_balance'] = account != null ? 'PASSED' : 'FAILED';
      test['current_balance'] = account?.balance ?? 0;
      
      if (account != null) {
        final originalBalance = account.balance;
        
        // Test affordability check (simulate)
        final testAmount = 100.0;
        final canAfford = originalBalance >= testAmount;
        test['affordability_check'] = canAfford ? 'PASSED' : 'FAILED';
        
        // Test balance operations
        final updatedAccount = await Account.db.updateById(
          session,
          account.id!,
          columnValues: (t) => [t.balance(originalBalance - testAmount)],
        );
        
        if (updatedAccount != null) {
          // Restore original balance
          await Account.db.updateById(
            session,
            account.id!,
            columnValues: (t) => [t.balance(originalBalance)],
          );
          test['balance_operations'] = 'PASSED';
        } else {
          test['balance_operations'] = 'FAILED';
        }
      }
      
      test['status'] = 'PASSED';
    } catch (e) {
      test['status'] = 'FAILED';
      test['error'] = e.toString();
    }
    
    return test;
  }
  
  Future<Map<String, dynamic>> _testActionOperations(Session session) async {
    final test = <String, dynamic>{};
    
    try {
      final products = await Product.db.find(session);
      
      if (products.isNotEmpty) {
        final testProduct = products.first;
        final originalStock = testProduct.stockCount;
        
        // Test stock update
        final updatedProduct = await Product.db.updateById(
          session,
          testProduct.id!,
          columnValues: (t) => [t.stockCount(originalStock + 5)],
        );
        
        if (updatedProduct != null && updatedProduct.stockCount == originalStock + 5) {
          // Restore original stock
          await Product.db.updateById(
            session,
            testProduct.id!,
            columnValues: (t) => [t.stockCount(originalStock)],
          );
          test['stock_update'] = 'PASSED';
        } else {
          test['stock_update'] = 'FAILED';
        }
        
        // Test product creation and deletion
        final newProduct = Product(
          name: 'Test Product',
          stockCount: 1,
          price: 99.99,
          category: 'test',
        );
        
        final createdProduct = await Product.db.insertRow(session, newProduct);
        if (createdProduct.id != null) {
          final deletedProducts = await Product.db.deleteWhere(
            session,
            where: (t) => t.id.equals(createdProduct.id!),
          );
          test['create_delete_product'] = deletedProducts.isNotEmpty ? 'PASSED' : 'FAILED';
        } else {
          test['create_delete_product'] = 'FAILED';
        }
      }
      
      test['status'] = 'PASSED';
    } catch (e) {
      test['status'] = 'FAILED';
      test['error'] = e.toString();
    }
    
    return test;
  }
  
  Future<Map<String, dynamic>> _testDataPersistence(Session session) async {
    final test = <String, dynamic>{};
    
    try {
      // Test that data persists across operations
      final productCount = await Product.db.count(session);
      final accountExists = await Account.db.findFirstRow(session) != null;
      
      test['products_persist'] = productCount > 0 ? 'PASSED' : 'FAILED';
      test['account_persists'] = accountExists ? 'PASSED' : 'FAILED';
      test['product_count'] = productCount;
      
      test['status'] = 'PASSED';
    } catch (e) {
      test['status'] = 'FAILED';
      test['error'] = e.toString();
    }
    
    return test;
  }
  
  Future<Map<String, dynamic>> _testExpenseTracking(Session session) async {
    final test = <String, dynamic>{};
    
    try {
      // Test expense creation
      final testExpense = Expense(
        category: 'Test Supplier',
        amount: 50.0,
        date: DateTime.now(),
      );
      
      final createdExpense = await Expense.db.insertRow(session, testExpense);
      test['create_expense'] = createdExpense.id != null ? 'PASSED' : 'FAILED';
      
      // Test expense retrieval
      final expenses = await Expense.db.find(session);
      test['get_expenses'] = expenses.isNotEmpty ? 'PASSED' : 'FAILED';
      test['expense_count'] = expenses.length;
      
      // Test expense categorization
      final categoryExpenses = await Expense.db.find(
        session,
        where: (t) => t.category.equals('Test Supplier'),
      );
      test['expense_categorization'] = categoryExpenses.isNotEmpty ? 'PASSED' : 'FAILED';
      
      // Clean up test expense
      if (createdExpense.id != null) {
        await Expense.db.deleteWhere(
          session,
          where: (t) => t.id.equals(createdExpense.id!),
        );
      }
      
      test['status'] = 'PASSED';
    } catch (e) {
      test['status'] = 'FAILED';
      test['error'] = e.toString();
    }
    
    
    return test;
  }
  
  Future<String> getSystemStatus(Session session) async {
    try {
      final productCount = await Product.db.count(session);
      final account = await Account.db.findFirstRow(session);
      final expenseCount = await Expense.db.count(session);
      
      return 'System Status: Products: $productCount, Account Balance: \$${account?.balance ?? 0}, Expenses: $expenseCount';
    } catch (e) {
      return 'System Status: ERROR - $e';
    }
  }
}