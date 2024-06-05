import 'package:flutter/material.dart';
import 'package:money_manage/screen/add_transaction_tab.dart';
import 'package:money_manage/screen/home_profile_tab.dart';
import 'package:money_manage/screen/home_screen_tab.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({super.key});

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {
  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const HomeScreenTab();
      case 1:
        return const TransactionForm();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return const HomeScreenTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTabContent(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: background,
          elevation: 0,
          onPressed: () {
            
          },
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: primaryLight),
              borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.add,
            color: primaryDark,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: secondaryDark,
        unselectedItemColor: fontLight,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('assest/icon/home_icon.png'),
              label: "Trang chủ"),
          BottomNavigationBarItem(
              icon: Image.asset('assest/icon/stat_icon.png'),
              label: "Thống kê"),
          BottomNavigationBarItem(
              icon: Image.asset('assest/icon/wallet_icon.png'), label: "Ví"),
          BottomNavigationBarItem(
              icon: Image.asset('assest/icon/user_profile_icon.png'),
              label: "Cá nhân"),
        ],
      ),
    );
  }
}
class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final nameCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCtl,
            decoration: const InputDecoration(labelText: 'Họ và tên'),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ tên';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
