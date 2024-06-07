import 'package:money_manage/data/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static Future<void> saveUserInfo(UserInfo userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', userInfo.name ?? '');
    await prefs.setString('gender', userInfo.gender ?? '');
    await prefs.setString('birthday', userInfo.birthday ?? '');
    await prefs.setString('totalBalance', userInfo.totalBalance ?? '');
    await prefs.setString('inflow', userInfo.inflow ?? '');
    await prefs.setString('outflow', userInfo.outflow ?? '');

    final transactions = userInfo.transactions;
    if (transactions != null) {
      await prefs.setInt('transactionCount', transactions.length);
      for (int i = 0; i < transactions.length; i++) {
        await saveTransaction(transactions[i], index: i);
      }
    }
  }

  static Future<UserInfo?> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    if (name != null) {
      String? gender = prefs.getString('gender');
      String? birthday = prefs.getString('birthday');
      String? totalBalance = prefs.getString('totalBalance');
      String? inflow = prefs.getString('inflow');
      String? outflow = prefs.getString('outflow');

      // Load transactions
      int? transactionCount = prefs.getInt('transactionCount');
      List<Transaction> transactions = [];
      if (transactionCount != null) {
        for (int i = 0; i < transactionCount; i++) {
          Transaction? transaction = await loadTransaction(index: i);
          if (transaction != null) {
            transactions.add(transaction);
          }
        }
      }

      return UserInfo(
        name: name,
        gender: gender,
        birthday: birthday,
        totalBalance: totalBalance,
        inflow: inflow,
        outflow: outflow,
        transactions: transactions,
      );
    }
    return null;
  }

  static Future<void> saveTransaction(Transaction transaction,
      {required int index}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'transactionType$index', transaction.transactionType ?? '');
    await prefs.setString(
        'itemCategoryType$index', transaction.itemCategoryType ?? '');
    await prefs.setString('itemName$index', transaction.itemName ?? '');
    await prefs.setString('amount$index', transaction.amount ?? '');
    await prefs.setString('date$index', transaction.date ?? '');
  }

  static Future<Transaction?> loadTransaction({required int index}) async {
    final prefs = await SharedPreferences.getInstance();
    String? transactionType = prefs.getString('transactionType$index');
    String? itemCategoryType = prefs.getString('itemCategoryType$index');
    String? itemName = prefs.getString('itemName$index');
    String? amount = prefs.getString('amount$index');
    String? date = prefs.getString('date$index');
    if (transactionType != null &&
        itemCategoryType != null &&
        itemName != null &&
        amount != null &&
        date != null) {
      return Transaction(
        transactionType: transactionType,
        itemCategoryType: itemCategoryType,
        itemName: itemName,
        amount: amount,
        date: date,
      );
    }
    return null;
  }
}
