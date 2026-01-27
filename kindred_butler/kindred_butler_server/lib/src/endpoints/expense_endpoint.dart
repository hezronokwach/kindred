import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ExpenseEndpoint extends Endpoint {
  Future<List<Expense>> getAllExpenses(Session session) async {
    return await Expense.db.find(session);
  }

  Future<List<Expense>> getExpensesByCategory(Session session, String category) async {
    return await Expense.db.find(
      session,
      where: (t) => t.category.equals(category),
    );
  }

  Future<List<Expense>> getExpensesByDateRange(
    Session session, 
    DateTime start, 
    DateTime end
  ) async {
    return await Expense.db.find(
      session,
      where: (t) => (t.date >= start) & (t.date <= end),
    );
  }

  Future<Expense> createExpense(Session session, Expense expense) async {
    return await Expense.db.insertRow(session, expense);
  }

  Future<Expense?> updateExpense(Session session, Expense expense) async {
    return await Expense.db.updateRow(session, expense);
  }

  Future<bool> deleteExpense(Session session, int id) async {
    var expense = await Expense.db.findById(session, id);
    if (expense == null) return false;
    
    await Expense.db.deleteRow(session, expense);
    return true;
  }
}