import 'package:flutter/material.dart';
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
        return Container();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return HomeScreenTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTabContent(currentIndex),
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
