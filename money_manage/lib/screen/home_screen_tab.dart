import 'package:flutter/material.dart';
import 'package:money_manage/ultils/colors_and_size.dart';
import 'package:money_manage/widget/income_expense_card.dart';

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          children: [
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            ListTile(
              title: Text('name'),
              leading: Image.asset("assest/picture/confuse.jpg"),
              trailing: Image.asset('assest/icon/bell-icon.png'),
            ),
            const SizedBox(
              height: defaultSpacing * 2.5,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      "Thu nhập", '40,000,000 vnd', Icons.arrow_upward_rounded),
                )),
                SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      'Chi tiêu', '-700', Icons.arrow_downward_rounded),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
