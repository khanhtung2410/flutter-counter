// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class UserInfo extends ChangeNotifier {
  String? name;
  String? gender;
  String? birthday;
  String? totalBalance;
  String? inflow;
  String? outflow;
  List<Transaction>? transactions;
  UserInfo({
    this.name,
    this.gender,
    this.birthday,
    this.totalBalance,
    this.inflow,
    this.outflow,
    List<Transaction>? transactions,
  }) {
    this.transactions = transactions ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'birthday': birthday,
      'totalBalance': totalBalance,
      'inflow': inflow,
      'outflow': outflow,
      'transactions':
          transactions?.map((transaction) => transaction.toMap()).toList(),
    };
  }

  static UserInfo fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'],
      gender: map['gender'],
      birthday: map['birthday'],
      totalBalance: map['totalBalance'],
      inflow: map['inflow'],
      outflow: map['outflow'],
      transactions: (map['transactions'] as List<dynamic>?)
              ?.map((transactionMap) => Transaction.fromMap(transactionMap))
              .toList() ??
          [],
    );
  }

  void addTransaction(Transaction transaction) {
    transactions?.add(transaction);
    if (transaction.transactionType == 'Inflow') {
      int currentInflow = int.parse(inflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      inflow = (currentInflow + transactionAmount).toString();
    } else if (transaction.transactionType == 'Outflow') {
      int currentOutflow = int.parse(outflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      outflow = (currentOutflow + transactionAmount).toString();
    }
    updateTotalBalance();
  }

  void deleteTransaction(Transaction transaction) {
    transactions?.remove(transaction);
    if (transaction.transactionType == 'Inflow') {
      int currentInflow = int.parse(inflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      inflow = (currentInflow - transactionAmount).toString();
    } else if (transaction.transactionType == 'Outflow') {
      int currentOutflow = int.parse(outflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      outflow = (currentOutflow - transactionAmount).toString();
    }
    updateTotalBalance();
  }

  void updateTotalBalance() {
    int inflowValue = int.parse(inflow ?? '0');
    int outflowValue = int.parse(outflow ?? '0');
    int total = inflowValue - outflowValue;
    totalBalance = total.toString();
    notifyListeners();
  }
}

List<String> transactionTypes = <String>['Inflow', 'Outflow'];

List<String> itemCategoryTypes = <String>[
  'Cá nhân',
  'Già đình',
  'Quà',
  'Đồ ăn'
];

class Transaction {
  String? transactionType;
  String? itemCategoryType;
  String? itemName;
  String? amount;
  String? date;
  Transaction({
    this.transactionType,
    this.itemCategoryType,
    this.itemName,
    this.amount,
    this.date,
  });
  Map<String, dynamic> toMap() {
    return {
      'transactionType': transactionType,
      'itemCategoryType': itemCategoryType,
      'itemName': itemName,
      'amount': amount,
      'date': date,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionType: map['transactionType'],
      itemCategoryType: map['itemCategoryType'],
      itemName: map['itemName'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}

UserInfo getMockUserInfo() {
  return UserInfo(
    name: 'John Doe',
    gender: 'Male',
    birthday: '1990-01-01',
    totalBalance: '',
    inflow: '1110',
    outflow: '0',
    transactions: null, // No transactions for testing
  );
}
