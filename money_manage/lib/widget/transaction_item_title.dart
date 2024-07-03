import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Tạo lớp hiển thị giao dịch
class TransactionItemTile extends StatelessWidget {
  //Lấy biến từ lớp transaction
  final Transaction? transaction;
  final UserInfo userInfo;
  final Function(int) onDelete;
  const TransactionItemTile({
    Key? key,
    required this.transaction,
    required this.userInfo,
    required this.onDelete,
  }) : super(key: key);

  //Lấy màu ngẫu nhiên
  Color getRandomBgColor() {
    return Color(Random().nextInt(0XFF000000));
  }

  //Lấy dấu giao dịch
  String getSign(String? a) {
    switch (a) {
      //Nếu là chi thì có "-" ở trước vd: - 200
      case "Chi":
        return "-";
      //Nếu là thu thì có "+" ở trước vd: + 200
      case "Thu":
        return "+";
    }
    //Trả về "" nếu không có gì
    return "";
  }

  void showOption(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Bạn muốn ?'),
              content: Row(
                children: [
                  TextButton(
                      onPressed: () => deleteTransaction(context),
                      child: Text("Xóa mục này")),
                  TextButton(onPressed: () {}, child: Text("Sửa mục này"))
                ],
              ),
            ));
  }

  //Function xóa giao dịch
  void deleteTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Bạn có chắc chắn muốn xóa giao dịch này?"),
        actions: [
          TextButton(
            onPressed: () {
              //Đóng cửa sổ xác nhận
              Navigator.of(context).pop();
              //Xóa giao dịch
              if (transaction != null) {
                onDelete(userInfo.transactions!.indexOf(transaction!));
              }
              //Đóng muc chon
              Navigator.of(context).pop();
            },
            child: const Text(
              'Xóa',
            ),
          ),
          TextButton(
            onPressed: () {
              // Đóng cửa số xác nhận
              Navigator.of(context).pop();
            },
            child: Text('Hủy'),
          ),
        ],
      ),
    );
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
          onTap: () => showOption(context),
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
            //Lấy dữ liệu mục giao dịch nhập vào và bắt lỗi null
            transaction?.itemCategoryType ?? "No category",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fontHeading,
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w700,
                ),
          ),
          subtitle: Text(
            //Lấy dữ liệu chi tiết giao dịch nhập vào và bắt lỗi null
            transaction?.itemName ?? "No name",
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
                //Lấy dữ liệu loại giao dịch nhập vào và bắt lỗi null
                "${getSign(transaction?.transactionType)} ${transaction?.amount ?? ""} vnđ",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: transaction?.transactionType == 'Chi'
                          ? Colors.red
                          : fontHeading,
                      fontSize: fontSizeTitle,
                    ),
              ),
              Text(
                //Lấy dữ liệu ngày giao dịch nhập vào và bắt lỗi null
                transaction?.date ?? "No date",
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
