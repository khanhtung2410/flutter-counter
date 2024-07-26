import 'package:flutter/material.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late SpendingCalculator spendingCalculator;
  late Transaction transaction;
  @override
  void initState() {
    super.initState();
    // Initialize with sample data or your actual data
    final List<Transaction> sampleTransactions = [
      Transaction(
          transactionType: 'Chi', itemCategoryType: 'Đồ ăn', amount: '500'),
      Transaction(
          transactionType: 'Chi', itemCategoryType: 'Quà', amount: '200'),
      Transaction(
          transactionType: 'Chi', itemCategoryType: 'Đồ ăn', amount: '300'),
      Transaction(
          transactionType: 'Chi', itemCategoryType: 'Cá nhân', amount: '150'),
    ];

    spendingCalculator = SpendingCalculator(sampleTransactions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: PieChart(
            dataMap: spendingCalculator.calculateSpendingByCategory(),
            animationDuration: const Duration(milliseconds: 800),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: false,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
        ),
      ],
    );
  }
}
