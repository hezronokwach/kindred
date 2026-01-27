import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AccountEndpoint extends Endpoint {
  Future<Account?> getAccount(Session session) async {
    return await Account.db.findFirstRow(session);
  }

  Future<Account> updateBalance(Session session, double newBalance) async {
    var account = await Account.db.findFirstRow(session);
    if (account == null) {
      // Create initial account if none exists
      account = Account(balance: newBalance, updatedAt: DateTime.now());
      return await Account.db.insertRow(session, account);
    }
    
    account.balance = newBalance;
    account.updatedAt = DateTime.now();
    return await Account.db.updateRow(session, account);
  }

  Future<Account> addToBalance(Session session, double amount) async {
    var account = await Account.db.findFirstRow(session);
    if (account == null) {
      account = Account(balance: amount, updatedAt: DateTime.now());
      return await Account.db.insertRow(session, account);
    }
    
    account.balance += amount;
    account.updatedAt = DateTime.now();
    return await Account.db.updateRow(session, account);
  }

  Future<Account?> subtractFromBalance(Session session, double amount) async {
    var account = await Account.db.findFirstRow(session);
    if (account == null || account.balance < amount) {
      return null; // Insufficient funds or no account
    }
    
    account.balance -= amount;
    account.updatedAt = DateTime.now();
    return await Account.db.updateRow(session, account);
  }
}