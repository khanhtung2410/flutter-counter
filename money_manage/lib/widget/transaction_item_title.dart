import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class TransactionItemTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionItemTile({Key? key, required this.transaction})
      : super(key: key);

  // String getSign(String? type) {
  //   switch (type) {
  //     case "2":
  //       return "+";
  //     case "1":
  //       return "-";
  //   }
  // }

  Color getRandomBgColor() {
    return Color(Random().nextInt(0XFF000000));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: defaultSpacing / 2),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset.zero,
                  blurRadius: 10,
                  spreadRadius: 4)
            ],
            color: background,
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        child: ListTile(
          leading: Container(
              padding: const EdgeInsets.all(defaultSpacing / 2),
              decoration: BoxDecoration(
                  color: getRandomBgColor(),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultRadius / 2))),
              child: 1 == 1
                  ? const Icon(Icons.supervised_user_circle_sharp)
                  : const Icon(Icons.house)),
          title: Text(transaction.itemCategoryName ?? "",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: fontHeading,
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.w700,
                  )),
          subtitle: Text(transaction.itemName ?? "",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: fontSubheading,
                    fontSize: fontSizeBody,
                  )),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  // "${getSign(transaction.transactionType?.transactionNumber)} ${transaction.amount}
                  " vnđ",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: transaction.transactionType?.transactionNumber == 2
                          ? Colors.red
                          : fontHeading,
                      fontSize: fontSizeTitle)),
              Text(transaction.date ?? "",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: fontSubheading,
                        fontSize: fontSizeBody,
                      ))
            ],
          ),
        ));
  }
}
