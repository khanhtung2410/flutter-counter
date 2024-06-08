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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userData = await LocalStorageManager.loadUserInfo();
    if (userData != null) {
      setState(() {
        userInfo = userData;
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfo>(
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultSpacing),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: defaultSpacing * 2),
              ListTile(
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
                      "${value.totalBalance ?? "0"} vnđ",
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
                    child: IncomeExpenseCard(
                      expenseData: ExpenseData(
                        'Thu nhập',
                        "${value.inflow ?? "0"} vnđ",
                        Icons.arrow_upward_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(width: defaultSpacing),
                  Expanded(
                    child: IncomeExpenseCard(
                      expenseData: ExpenseData(
                        'Chi tiêu',
                        "${value.outflow ?? "0"} vnđ",
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
              Text(
                "{userInfo.transactions}",
                style: TextStyle(color: fontSubheading),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.transactions?.length ?? 0,
                  itemBuilder: (context, index) {
                    Transaction? transaction = value.transactions?[index];
                    return TransactionItemTile(transaction: transaction);
                  }),
            ]),
          ),
        );
      },
    );
  }
}
