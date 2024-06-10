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
}
