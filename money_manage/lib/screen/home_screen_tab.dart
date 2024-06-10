import 'dart:ui';

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
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Dùng Consumer để chỉnh UI khi có thay đổi liên quan đến UserInfo
    return Consumer<UserInfo>(
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultSpacing),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: defaultSpacing * 2),
              ListTile(
                //Lấy tên người dùng từ dữ liêu được lưu
                title: Text('Xin chào! ${userInfo.name ?? ""}'),
                leading: Image.asset("assest/picture/like.png"),
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
                      "${((int.tryParse(userInfo.totalBalance ?? "0") ?? 0) 
                      + (int.tryParse(value.inflow ?? "0") ?? 0) / 2 - (int.tryParse(value.outflow ?? "0") ?? 0) / 2)
                      .toString()} vnđ",
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
                        "${((int.tryParse(userInfo.inflow ?? "0") ?? 0) + (int.tryParse(value.inflow ?? "0") ?? 0) / 2).toString()} vnđ",
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
                        "${((int.tryParse(userInfo.outflow ?? "0") ?? 0) + (int.tryParse(value.outflow ?? "0") ?? 0) / 2).toString()} vnđ",
                        Icons.arrow_downward_rounded,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultSpacing * 2),
              Text(
                'Giao dịch gần đây',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: defaultSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mới thêm vào',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  //Tạo view một danh sách những giao dịch mới thêm trong lần sử dụng này
                  ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //Lấy dữ liệu số giao dịch từ Consumer
                      itemCount: value.transactions?.length ?? 0,
                      itemBuilder: (context, index) {
                        //Gán từng thành phần của danh sách trong Consumer vào lớp Transaction
                        Transaction? transaction = value.transactions?[index];
                        //Trả về lớp được xây để chiếu giao dịch
                        return TransactionItemTile(transaction: transaction);
                      }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giao dịch cũ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  //Tạo view danh sách lấy từ local store (giao dịch mới thêm chỉ vào đây khi khởi động lại ứng dụng)
                  ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //Lấy độ dài danh sách giao dịch từ local store
                      itemCount: userInfo.transactions?.length ?? 0,
                      itemBuilder: (context, index) {
                        //Gán thành phần từ danh sách local store
                        Transaction? transaction =
                            userInfo.transactions?[index];
                        return TransactionItemTile(transaction: transaction);
                      }),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
