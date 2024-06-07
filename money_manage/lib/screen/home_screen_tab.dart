import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';
import 'package:money_manage/widget/income_expense_card.dart';
import 'package:money_manage/widget/transaction_item_title.dart';

class HomeScreenTab extends StatelessWidget {
   HomeScreenTab({super.key});

  Transaction transactions = Transaction();
  bool isLoaded = false;

  Future<Transaction> init() async {
    if (isLoaded) return transactions;
    var value = await loadUserInfo();
    if (value != null) {
      try {
        isLoaded = true;
        return Transaction.fromMap(value);
      } catch (e) {
        debugPrint(e.toString());
        return Transaction();
      }
    }
    return Transaction();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            ListTile(
              title: Text('Xin chào! ${userdata.name}'),
              leading: Image.asset("assest/picture/like.png"),
              trailing: Image.asset('assest/icon/bell-icon.png'),
            ),
            const SizedBox(
              height: defaultSpacing * 1.5,
            ),
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
                  const SizedBox(
                    height: defaultSpacing / 2,
                  ),
                  Text(
                    "${userdata.totalBalance} vnđ",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
             const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                    //${userdata.inflow}
                      "Thu nhập", ' vnđ', Icons.arrow_upward_rounded),
                )),
                SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                    //${userdata.outflow}
                      'Chi tiêu', ' vnđ', Icons.arrow_downward_rounded),
                ))
              ],
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            Text(
              'Giao dịch gần đây',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: defaultSpacing,
            ),
            const Text(//userdata.transactions?.last.date??
               "",
              style: TextStyle(color: fontSubheading),
            ),
             TransactionItemTile(transaction: transactions)
          ],
        ),
      ),
    );
  }
}
Future<Map<String, dynamic>?> loadUserInfo() async {
  return await Localstore.instance.collection('users').doc('transaction').get();
}