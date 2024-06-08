// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

//Tạo class Userinfo liên kết với ChangeNotifier để nhận biết thay đổi
class UserInfo extends ChangeNotifier {
  String? name;
  String? gender;
  String? birthday;
  String? totalBalance;
  String? inflow;
  String? outflow;
  //Dùng danh sách để lưu nhiều dữ liệu
  List<Transaction>? transactions;
  UserInfo({
    this.name,
    this.gender,
    this.birthday,
    this.totalBalance,
    this.inflow,
    this.outflow,
    //Lấy biến lưu trữ
    List<Transaction>? transactions,
  }) {
    //Nếu không có giao dịch, mặc định là danh sách rỗng
    this.transactions = transactions ?? [];
  }
  //Chuyển thành map
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

  //Function thêm giao dịch với biến đầu vào là transaction
  void addTransaction(Transaction transaction) {
    //Thêm transaction vào danh sách
    transactions?.add(transaction);
    //Kiểm tra loại giao dịch và cập nhật dòng tiền
    if (transaction.transactionType == 'Thu') {
      int currentInflow = int.parse(inflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      inflow = (currentInflow + transactionAmount).toString();
    } else if (transaction.transactionType == 'Chi') {
      int currentOutflow = int.parse(outflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      outflow = (currentOutflow + transactionAmount).toString();
    }
    //Gọi function cập nhật tổng tiền
    updateTotalBalance();
  }

  //Function xóa giao dịch với biến đầu vào là transaction
  void deleteTransaction(Transaction transaction) {
    //Bỏ transaction khỏi danh sách
    transactions?.remove(transaction);
    //Kiểm tra loại giao dịch và cập nhật dòng tiền
    if (transaction.transactionType == 'Thu') {
      int currentInflow = int.parse(inflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      inflow = (currentInflow - transactionAmount).toString();
    } else if (transaction.transactionType == 'Chi') {
      int currentOutflow = int.parse(outflow ?? '0');
      int transactionAmount = int.parse(transaction.amount ?? '0');
      outflow = (currentOutflow - transactionAmount).toString();
    }
    //Gọi function cập nhật tổng tiền
    updateTotalBalance();
  }

  //Function cập nhật tổng tiền
  void updateTotalBalance() {
    int inflowValue = int.parse(inflow ?? '0');
    int outflowValue = int.parse(outflow ?? '0');
    //Tính lại dòng tiền
    int total = inflowValue - outflowValue;
    totalBalance = total.toString();
    //Thông báo có thay đổi
    notifyListeners();
  }
}
//Danh sách loại giao dịch
List<String> transactionTypes = <String>['Thu', 'Chi'];
//Danh sách mục giao dịch
List<String> itemCategoryTypes = <String>[
  'Cá nhân',
  'Già đình',
  'Quà',
  'Đồ ăn'
];
//Lớp giao dịch
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
//Lớp dữ liệu tạo
UserInfo getMockUserInfo() {
  return UserInfo(
    name: 'John Doe',
    gender: 'Nữ',
    birthday: '01/01/1990',
    totalBalance: '',
    inflow: '1110',
    outflow: '0',
    transactions: null, // No transactions for testing
  );
}
