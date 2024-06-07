// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserInfo {
  String? name;
  String? gender;
  String? birthday;
  String? totalBalance;
  String? inflow;
  String? outflow;
  Transaction? transactions;
  UserInfo({
    this.name,
    this.gender,
    this.birthday,
    this.totalBalance,
    this.inflow,
    this.outflow,
    this.transactions,
  });

  UserInfo copyWith({
    String? name,
    String? gender,
    String? birthday,
    String? totalBalance,
    String? inflow,
    String? outflow,
    Transaction? transactions,
  }) {
    return UserInfo(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      totalBalance: totalBalance ?? this.totalBalance,
      inflow: inflow ?? this.inflow,
      outflow: outflow ?? this.outflow,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'gender': gender,
      'birthday': birthday,
      'totalBalance': totalBalance,
      'inflow': inflow,
      'outflow': outflow,
      'transactions': transactions?.toMap(),
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'] != null ? map['name'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      birthday: map['birthday'] != null ? map['birthday'] as String : null,
      totalBalance: map['totalBalance'] != null ? map['totalBalance'] as String : null,
      inflow: map['inflow'] != null ? map['inflow'] as String : null,
      outflow: map['outflow'] != null ? map['outflow'] as String : null,
      transactions: map['transactions'] != null ? Transaction.fromMap(map['transactions'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfo(name: $name, gender: $gender, birthday: $birthday, totalBalance: $totalBalance, inflow: $inflow, outflow: $outflow, transactions: $transactions)';
  }

  @override
  bool operator ==(covariant UserInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.gender == gender &&
      other.birthday == birthday &&
      other.totalBalance == totalBalance &&
      other.inflow == inflow &&
      other.outflow == outflow &&
      other.transactions == transactions;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        gender.hashCode ^
        birthday.hashCode ^
        totalBalance.hashCode ^
        inflow.hashCode ^
        outflow.hashCode ^
        transactions.hashCode;
  }
}

class TransactionType {
  String? transactionLabel;
  String? transactionNumber;
  TransactionType({
    this.transactionLabel,
    this.transactionNumber,
  });

  TransactionType copyWith({
    String? transactionLabel,
    String? transactionNumber,
  }) {
    return TransactionType(
      transactionLabel: transactionLabel ?? this.transactionLabel,
      transactionNumber: transactionNumber ?? this.transactionNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionLabel': transactionLabel,
      'transactionNumber': transactionNumber,
    };
  }

  factory TransactionType.fromMap(Map<String, dynamic> map) {
    return TransactionType(
      transactionLabel: map['transactionLabel'] != null ? map['transactionLabel'] as String : null,
      transactionNumber: map['transactionNumber'] != null ? map['transactionNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionType.fromJson(source) =>
      TransactionType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TransactionType(transactionLabel: $transactionLabel, transactionNumber: $transactionNumber)';

  @override
  bool operator ==(covariant TransactionType other) {
    if (identical(this, other)) return true;

    return other.transactionLabel == transactionLabel &&
        other.transactionNumber == transactionNumber;
  }

  @override
  int get hashCode => transactionLabel.hashCode ^ transactionNumber.hashCode;
}

class ItemCategoryType {
  String? categoryLabel;
  String? categoryNumber;
  ItemCategoryType({
    this.categoryLabel,
    this.categoryNumber,
  });

  ItemCategoryType copyWith({
    String? categoryLabel,
    String? categoryNumber,
  }) {
    return ItemCategoryType(
      categoryLabel: categoryLabel ?? this.categoryLabel,
      categoryNumber: categoryNumber ?? this.categoryNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryLabel': categoryLabel,
      'categoryNumber': categoryNumber,
    };
  }

  factory ItemCategoryType.fromMap(Map<String, dynamic> map) {
    return ItemCategoryType(
      categoryLabel: map['categoryLabel'] != null ? map['categoryLabel'] as String : null,
      categoryNumber: map['categoryNumber'] != null ? map['categoryNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCategoryType.fromJson(String source) => ItemCategoryType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ItemCategoryType(categoryLabel: $categoryLabel, categoryNumber: $categoryNumber)';

  @override
  bool operator ==(covariant ItemCategoryType other) {
    if (identical(this, other)) return true;

    return other.categoryLabel == categoryLabel &&
        other.categoryNumber == categoryNumber;
  }

  @override
  int get hashCode => categoryLabel.hashCode ^ categoryNumber.hashCode;
}

class Transaction {
  TransactionType? transactionType;
  ItemCategoryType? categoryType;
  String? itemCategoryName;
  String? itemName;
  String? amount;
  String? date;
  Transaction({
    this.transactionType,
    this.categoryType,
    this.itemCategoryName,
    this.itemName,
    this.amount,
    this.date,
  });

  Transaction copyWith({
    TransactionType? transactionType,
    ItemCategoryType? categoryType,
    String? itemCategoryName,
    String? itemName,
    String? amount,
    String? date,
  }) {
    return Transaction(
      transactionType: transactionType ?? this.transactionType,
      categoryType: categoryType ?? this.categoryType,
      itemCategoryName: itemCategoryName ?? this.itemCategoryName,
      itemName: itemName ?? this.itemName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionType': transactionType?.toMap(),
      'categoryType': categoryType?.toMap(),
      'itemCategoryName': itemCategoryName,
      'itemName': itemName,
      'amount': amount,
      'date': date,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionType: map['transactionType'] != null
          ? TransactionType.fromMap(
              map['transactionType'] as Map<String, dynamic>)
          : null,
      categoryType: map['categoryType'] != null
          ? ItemCategoryType.fromMap(
              map['categoryType'] as Map<String, dynamic>)
          : null,
      itemCategoryName: map['itemCategoryName'] != null
          ? map['itemCategoryName'] as String
          : null,
      itemName: map['itemName'] != null ? map['itemName'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(transactionType: $transactionType,categoryType: $categoryType, itemCategoryName: $itemCategoryName, itemName: $itemName, amount: $amount, date: $date)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.transactionType == transactionType &&
        other.categoryType == categoryType &&
        other.itemCategoryName == itemCategoryName &&
        other.itemName == itemName &&
        other.amount == amount &&
        other.date == date;
  }

  @override
  int get hashCode {
    return transactionType.hashCode ^
        categoryType.hashCode ^
        itemCategoryName.hashCode ^
        itemName.hashCode ^
        amount.hashCode ^
        date.hashCode;
  }
}

List<Transaction> transactions1 = [Transaction()];

UserInfo userdata = UserInfo();
