import 'package:flutter_test/flutter_test.dart';
import 'package:money_manage/data/userInfo.dart';

void main() {
  group('UserInfo', () {
    test('Add Transaction', () {
      UserInfo userInfo = getMockUserInfo();
      // mockdata
      // name: 'John Doe',
      // gender: 'Nữ',
      // birthday: '01/01/1990',
      // totalBalance: '',
      // inflow: '1110',
      // outflow: '0',
      // transactions: null,
      Transaction transaction = Transaction(
        transactionType: 'Thu',
        itemCategoryType: 'Cá nhân',
        itemName: 'Salary',
        amount: '1000',
        date: '2022-06-10',
      );

      // Add transaction
      userInfo.addTransaction(transaction);

      // Check if transaction is added
      expect(userInfo.transactions?.length, 1);
      expect(userInfo.transactions?.first.transactionType, 'Thu');
      expect(userInfo.transactions?.first.itemCategoryType, 'Cá nhân');
      expect(userInfo.transactions?.first.itemName, 'Salary');
      expect(userInfo.transactions?.first.amount, '1000');
      expect(userInfo.transactions?.first.date, '2022-06-10');

      // Check if inflow is updated
      expect(userInfo.inflow, '2110'); //1000 + 1110

      // Check if total balance is updated
      expect(userInfo.totalBalance, '2110'); //user.inflow-user.outflow (2110 - '') + start amount ( '' ) 
    });

    test('Delete Transaction', () {
      UserInfo userInfo = getMockUserInfo();
      Transaction transaction = Transaction(
        transactionType: 'Thu',
        itemCategoryType: 'Cá nhân',
        itemName: 'Salary',
        amount: '1000',
        date: '2022-06-10',
      );

      // Add transaction
      userInfo.addTransaction(transaction);

      // Delete transaction
      userInfo.deleteTransaction(transaction);

      // Check if transaction is deleted
      expect(userInfo.transactions?.isEmpty, true);

      // Check if inflow is updated
      expect(userInfo.inflow, '1110'); // Initial inflow in getMockUserInfo

      // Check if total balance is updated
      expect(userInfo.totalBalance, '1110'); //user.inflow-user.outflow (1110 - '') + start amount ( '' ) 
    });

    test('To Map and From Map', () {
      UserInfo userInfo = UserInfo(
        name: 'John Doe',
        gender: 'Nữ',
        birthday: '01/01/1990',
        totalBalance: '',
        inflow: '1110',
        outflow: '0',
        transactions: [
          Transaction(
            transactionType: 'Thu',
            itemCategoryType: 'Cá nhân',
            itemName: 'Salary',
            amount: '1000',
            date: '2022-06-10',
          ),
          Transaction(
            transactionType: 'Chi',
            itemCategoryType: 'Đồ ăn',
            itemName: 'Lunch',
            amount: '50',
            date: '2022-06-11',
          ),
        ],
      );

      // Convert UserInfo to map
      Map<String, dynamic> userInfoMap = userInfo.toMap();

      // Convert map back to UserInfo
      UserInfo userInfoFromMap = UserInfo.fromMap(userInfoMap);

      // Check if the original and converted UserInfo objects are equal
      expect(userInfoFromMap.name, userInfo.name);
      expect(userInfoFromMap.gender, userInfo.gender);
      expect(userInfoFromMap.birthday, userInfo.birthday);
      expect(userInfoFromMap.totalBalance, userInfo.totalBalance);
      expect(userInfoFromMap.inflow, userInfo.inflow);
      expect(userInfoFromMap.outflow, userInfo.outflow);
      expect(
          userInfoFromMap.transactions?.length, userInfo.transactions?.length);
    });

  test('Delete The right Transaction', () {
      // Tạo data với thông tin cho trước
      UserInfo userInfo = UserInfo();
      Transaction initialTransaction = Transaction(amount: '100');
      Transaction initialTransaction2 = Transaction(amount: '200');
      userInfo.addTransaction(initialTransaction);
      userInfo.addTransaction(initialTransaction2);

      // Xóa giao dịch với khoản tiền 

      userInfo.deleteTransaction(initialTransaction2);

      // Xác định giao dịch vẫn còn
      expect(userInfo.transactions!.length, 1);
      expect(userInfo.transactions!.first.amount, '100');
    });

  test('Transaction To Map and From Map', () {
    Transaction transaction = Transaction(
      transactionType: 'Thu',
      itemCategoryType: 'Cá nhân',
      itemName: 'Salary',
      amount: '1000',
      date: '2022-06-10',
    );

    // Convert Transaction to map
    Map<String, dynamic> transactionMap = transaction.toMap();

    // Convert map back to Transaction
    Transaction transactionFromMap = Transaction.fromMap(transactionMap);

    // Check if the original and converted Transaction objects are equal
    expect(transactionFromMap.transactionType, transaction.transactionType);
    expect(transactionFromMap.itemCategoryType, transaction.itemCategoryType);
    expect(transactionFromMap.itemName, transaction.itemName);
    expect(transactionFromMap.amount, transaction.amount);
    expect(transactionFromMap.date, transaction.date);
  });
});
}