enum TransactionType { outflow, inflow }

enum ItemCategoryType { self, family, travel, health, grocery }

class UserInfo {
  final String name;
  final String gender;
  final String birthday;
  final String totalBalance;
  final String inflow;
  final String outflow;
  final List<Transaction> transactions;

  const UserInfo(
      {required this.name,
      required this.gender,
      required this.birthday,
      required this.totalBalance,
      required this.inflow,
      required this.outflow,
      required this.transactions});
}

class Transaction {
  final ItemCategoryType categoryType;
  final TransactionType transactionType;
  final String itemCategoryName;
  final String itemName;
  final int amount;
  final String date;

  const Transaction(this.categoryType, this.transactionType,
      this.itemCategoryName, this.itemName, this.amount, this.date);
}

const List<Transaction> transactions1 = [
  Transaction(ItemCategoryType.grocery, TransactionType.outflow, 'Food',
      'Steak', 200000, 'Dec, 23'),
  Transaction(ItemCategoryType.family, TransactionType.outflow, 'Gift', 'Cake',
      15000, 'Oct, 24')
];

const List<Transaction> transactions2 = [
  Transaction(ItemCategoryType.family, TransactionType.inflow, 'Gift',
      'Transfer', 200000, 'Nov, 23'),
  Transaction(ItemCategoryType.family, TransactionType.inflow, 'Gift', 'doc',
      150000, 'Oct, 24')
];


const userdata = UserInfo(
    name: 'me',
    gender: "Nam",
    birthday: 'time',
    totalBalance: '44,452,245',
    inflow: '10,000,000',
    outflow: '2,000,000',
    transactions: transactions1);
