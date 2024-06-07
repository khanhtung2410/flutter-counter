import 'dart:ui';

import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "${userInfo.totalBalance ?? ""} vnđ",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultSpacing * 2),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: IncomeExpenseCard(
                    expenseData: ExpenseData(
                      'Thu nhập',
                      ' vnđ',
                      Icons.arrow_upward_rounded,
                    ),
                  ),
                ),
                SizedBox(width: defaultSpacing),
                Expanded(
                  child: IncomeExpenseCard(
                    expenseData: ExpenseData(
                      'Chi tiêu',
                      ' vnđ',
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
              'child',
              style: TextStyle(color: fontSubheading),
            ),
            TransactionItemTile(
              transactions: userInfo.transactions ?? [],
            ),
          ],
        ),
      ),
    );
  }
}
