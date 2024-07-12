import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_manage/data/localstore.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';
import 'package:money_manage/widget/income_expense_card.dart';
import 'package:money_manage/widget/transaction_item_title.dart';

class HomeScreenTab extends StatefulWidget {
  HomeScreenTab({Key? key}) : super(key: key);

  @override
  _HomeScreenTabState createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  UserInfo userInfo = getMockUserInfo();
  bool isLoaded = false;
  //Tạo dữ liệu và gọi function lấy dữ liệu từ local store
  @override
  void initState() {
    super.initState();
    //Gọi funtion lấy dữ liệu
    _loadUserInfo();
  }

  //Funtion lấy dữ liệu và kiểm tra xem dữ liệu có null không
  Future<void> _loadUserInfo() async {
    //Đợi lấy dữ liệu
    final userData = await LocalStorageManager.loadUserInfo();

    //Kiểm tra xem dữ liêu null không
    if (userData != null) {
      setState(() {
        //Nếu dữ liệu không null thì userInfo sẽ là dữ liệu từ local store
        userInfo = userData;
        print(userInfo.transactions?.length);
        isLoaded = true;
      });
    }
  }

  void _handleDeleteTransaction(int index, UserInfo user) {
    // Perform deletion from local storage
    LocalStorageManager.deleteTransaction(index);
    // Update the UI by reloading user info
    _loadUserInfo();
  }

  //xóa được giao dịch đã hiện nhưng chưa xóa được trong local store vì chưa thêm vào local
  void _handleNewTransactionDeletion(
      Transaction transaction, int index, UserInfo user) {
    UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
    userInfo.deleteTransaction(transaction);
    _handleDeleteTransaction(index, user);
    Provider.of<UserInfo>(context, listen: false).notifyListeners();
    //thử ùng _handleDeleteTransaction với index = index mới thêm + index trong local
  }

  String calculateTotalBalance(UserInfo userInfo, UserInfo value) {
    int userInfoTotalBalance = int.tryParse(userInfo.totalBalance ?? "0") ?? 0;
    int valueInflow = int.tryParse(value.inflow ?? "0") ?? 0;
    int valueOutflow = int.tryParse(value.outflow ?? "0") ?? 0;

    // Combine userInfo's totalBalance with adjusted inflow and outflow from value
    int totalBalance =
        userInfoTotalBalance + (valueInflow).round() - (valueOutflow).round();

    return totalBalance.toString();
  }

  String calculateInflow(UserInfo userInfo, UserInfo value) {
    int userInfoInflow = int.tryParse(userInfo.inflow ?? "0") ?? 0;
    int valueInflow = int.tryParse(value.inflow ?? "0") ?? 0;

    int totalInflow = userInfoInflow + (valueInflow).round();

    return totalInflow.toString();
  }

  String calculateOutflow(UserInfo userInfo, UserInfo value) {
    int userInfoOutflow = int.tryParse(userInfo.outflow ?? "0") ?? 0;
    int valueOutflow = int.tryParse(value.outflow ?? "0") ?? 0;

    // Combine userInfo's totalBalance with adjusted inflow and outflow from value
    int totalOutflow = userInfoOutflow + (valueOutflow).round();

    return totalOutflow.toString();
  }

  @override
  Widget build(BuildContext context) {
    //Dùng Consumer để chỉnh UI khi có thay đổi liên quan đến UserInfo
    return Consumer<UserInfo>(
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultSpacing * 2),
                ListTile(
                  //Lấy tên người dùng từ dữ liêu được lưu
                  title: Text('Xin chào! ${userInfo.name ?? ""}'),
                  leading: Image.asset(
                    "assest/picture/like.png",
                  ),
                  trailing: Image.asset('assest/icon/bell-icon.png'),
                ),
                const SizedBox(height: defaultSpacing * 1.5),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Tổng tiền",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: fontSubheading),
                      ),
                      const SizedBox(height: defaultSpacing / 2),
                      Text(
                        //Lấy dữ liệu tổng tiền từ local store và thay đổi nó khi nhập giao dịch mới
                        "${calculateTotalBalance(userInfo, value)} vnđ",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultSpacing * 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      //Lớp tự làm để trình bày dòng tiền người dùng
                      child: IncomeExpenseCard(
                        expenseData: ExpenseData(
                          'Thu nhập',
                          //Lấy dữ liệu dòng tiền thu từ local store và thay đổi nó khi nhập giao dịch mới
                          "${calculateInflow(userInfo, value)} vnđ",
                          Icons.arrow_upward_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultSpacing),
                    Expanded(
                      child: IncomeExpenseCard(
                        expenseData: ExpenseData(
                          'Chi tiêu',
                          //Lấy dữ liệu dòng tiền chi từ local store và thay đổi nó khi nhập giao dịch mới
                          "${calculateOutflow(userInfo, value)} vnđ",
                          Icons.arrow_downward_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultSpacing * 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách giao dịch',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    //Tạo view một danh sách những giao dịch
                    ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (value.transactions?.length ?? 0) +
                          (userInfo.transactions?.length ?? 0),
                      itemBuilder: (context, index) {
                        if (index < (value.transactions?.length ?? 0)) {
                          // Danh sách giao dịch mới thêm trước
                          Transaction? transaction = value.transactions?[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0)
                                Text(
                                  'Mới thêm vào',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              TransactionItemTile(
                                transaction: transaction,
                                userInfo: value,
                                onDelete: (index) =>
                                    _handleNewTransactionDeletion(
                                        transaction!,
                                        (index + userInfo.transactions!.length),
                                        userInfo),
                              ),
                            ],
                          );
                        } else {
                          // Danh sách giao dịch từ localstore
                          Transaction? transaction = userInfo.transactions?[
                              index - (value.transactions?.length ?? 0)];
                          return TransactionItemTile(
                            transaction: transaction,
                            userInfo: userInfo,
                            onDelete: (index) =>
                                _handleDeleteTransaction(index, userInfo),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
