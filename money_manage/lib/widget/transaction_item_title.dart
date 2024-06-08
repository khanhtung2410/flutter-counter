import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class TransactionItemTile extends StatelessWidget {
  final Transaction? transaction;
  const TransactionItemTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  Color getRandomBgColor() {
    return Color(Random().nextInt(0XFF000000));
  }

  String getSign(String? a) {
    switch (a) {
      case "Outflow":
        return "-";
      case "Inflow":
        return "+";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: defaultSpacing / 2),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset.zero,
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ],
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(defaultSpacing / 2),
            decoration: BoxDecoration(
              color: getRandomBgColor(),
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultRadius / 2),
              ),
            ),
            child: const Icon(Icons.supervised_user_circle_sharp),
          ),
          title: Text(
            transaction?.itemCategoryType ?? "No category", // Handle null case
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fontHeading,
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w700,
                ),
          ),
          subtitle: Text(
            transaction?.itemName ?? "No name", // Handle null case
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fontSubheading,
                  fontSize: fontSizeBody,
                ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${getSign(transaction?.transactionType)} ${transaction?.amount ?? ""} vnđ", // Handle null cases
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: transaction?.transactionType == 'Outflow'
                          ? Colors.red
                          : fontHeading,
                      fontSize: fontSizeTitle,
                    ),
              ),
              Text(
                transaction?.date ?? "No date", // Handle null case
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: fontSubheading,
                      fontSize: fontSizeBody,
                    ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
