import 'package:flutter/material.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class AddTransactionTab extends StatelessWidget {
  const AddTransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            " vnđ",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
