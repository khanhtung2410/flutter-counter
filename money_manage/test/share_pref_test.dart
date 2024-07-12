import 'package:flutter_test/flutter_test.dart';
import 'package:money_manage/data/localstore.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Save user info', () async {
    SharedPreferences.setMockInitialValues({});
    // Tạo mockdata
    UserInfo userInfo = UserInfo(
      name: 'John Doe',
      gender: 'Male',
      birthday: '1990-01-01',
      totalBalance: '1000',
      inflow: '1500',
      outflow: '500',
      transactions: [],
    );

    // Lưu dữ liệu
    await LocalStorageManager.saveUserInfo(userInfo);

    //Load dữ liệu
    UserInfo? loadedUserInfo = await LocalStorageManager.loadUserInfo();

    // Kiểm tra dữ liệu load không null
    expect(loadedUserInfo, isNotNull);

    // Kiểm tra trùng khớp
    expect(loadedUserInfo!.name, equals(userInfo.name));
    expect(loadedUserInfo.gender, equals(userInfo.gender));
    expect(loadedUserInfo.birthday, equals(userInfo.birthday));
    //Vì không có giao dịch nên outflow, inflow, totalBalance đều == '0'
    // outflow, inflow lấy giá trị từ giao dịch
    // totalBalance = inflow - outflow
    expect(loadedUserInfo.totalBalance, equals('0'));
    expect(loadedUserInfo.inflow, equals('0'));
    expect(loadedUserInfo.outflow, equals('0'));
  });
  test('Save transaction', () async {
    SharedPreferences.setMockInitialValues({});
    // Tạo giao dịch
    Transaction transaction = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '2000',
      date: '2024-06-10',
    );

    // Lưu giao dịch
    await LocalStorageManager.saveTransaction(transaction);

    // Load  giao dịch
    Transaction? loadedTransaction =
        await LocalStorageManager.loadTransaction(index: 0);

    // kiểm tra giao dịch
    expect(loadedTransaction, equals(transaction));
  });
  test('Delete Transaction', () async {
    SharedPreferences.setMockInitialValues({});

    Transaction transaction = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '2000',
      date: '2024-06-10',
    );
    await LocalStorageManager.saveTransaction(transaction);
    Transaction transaction1 = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '5000',
      date: '2024-08-10',
    );
    await LocalStorageManager.saveTransaction(transaction1);
    Transaction transaction2 = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '3000',
      date: '2024-08-10',
    );
    await LocalStorageManager.saveTransaction(transaction2);
    Transaction? loadedTransactionBefore =
        await LocalStorageManager.loadTransaction(index: 1);
    expect(loadedTransactionBefore, equals(transaction1));

    await LocalStorageManager.deleteTransaction(1);

    Transaction? loadedTransaction =
        await LocalStorageManager.loadTransaction(index: 1);
    expect(loadedTransaction, equals(transaction2));

    Transaction? loadedTransaction2 =
        await LocalStorageManager.loadTransaction(index: 0);
    expect(loadedTransaction2, equals(transaction));
  });
  test('Change transaction', () async {
    SharedPreferences.setMockInitialValues({});
    Transaction transaction = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '2000',
      date: '2024-06-10',
    );
    await LocalStorageManager.saveTransaction(transaction);
    Transaction transaction1 = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '5000',
      date: '2024-08-10',
    );
    await LocalStorageManager.saveTransaction(transaction1);
    Transaction transaction2 = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '3000',
      date: '2024-08-10',
    );
    await LocalStorageManager.saveTransaction(transaction2);

    Transaction transactionChangeData = Transaction(
      transactionType: 'Income',
      itemCategoryType: 'Salary',
      itemName: 'June Salary',
      amount: '4000',
      date: '2024-08-10',
    );
    await LocalStorageManager.changeTransaction(transactionChangeData, 0);

    // Kiểm tra giao dịch được đổi có đồng nhất không
    Transaction? transactionChanged =
        await LocalStorageManager.loadTransaction(index: 0);
    expect(transactionChanged, transactionChangeData);

    // Kiểm tra các giao dịch phía sau có giữ nguyên không
    Transaction? transactionKeep =
        await LocalStorageManager.loadTransaction(index: 1);
    expect(transactionKeep, transaction1);
    Transaction? transactionKeep2 =
        await LocalStorageManager.loadTransaction(index: 2);
    expect(transactionKeep2, transaction2);
  });
}
