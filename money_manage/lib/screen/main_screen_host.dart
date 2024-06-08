import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/screen/add_transaction_tab.dart';
import 'package:money_manage/screen/home_profile_tab.dart';
import 'package:money_manage/screen/home_screen_tab.dart';
import 'package:money_manage/ultils/colors_and_size.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({super.key});

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {
  var currentIndex = 0;

  final formKey = GlobalKey<FormState>();

  final transactionCtl = TextEditingController();
  final categoryCtl = TextEditingController();
  final moneyCtl = TextEditingController();
  final dateCtl = TextEditingController();
  final detailCtl = TextEditingController();

  String dropdownTransaction = transactionTypes.first;
  String dropdownCategory = itemCategoryTypes.first;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return HomeScreenTab();
      case 1:
        return const AddTransactionTab();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return HomeScreenTab();
    }
  }

  void addTransaction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thêm giao dịch"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: defaultSpacing * 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  onChanged: (newValue) {
                    dropdownTransaction = newValue!;
                  },
                  onSaved: (newValue) {
                    transactionCtl.text = newValue!;
                  },
                  decoration: InputDecoration(
                    label: const Text('Loại chi'),
                    labelStyle: const TextStyle(
                      fontSize: fontSizeHeading,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng chọn loại giao dịch';
                    }
                    return null;
                  },
                  value: dropdownTransaction,
                  items: transactionTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  onChanged: (newValue) {
                    dropdownCategory = newValue!;
                  },
                  onSaved: (newValue) {
                    categoryCtl.text = newValue!;
                  },
                  decoration: InputDecoration(
                    label: const Text('Mục chi'),
                    labelStyle: const TextStyle(
                      fontSize: fontSizeHeading,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng chọn loại giao dịch';
                    }
                    return null;
                  },
                  value: dropdownCategory,
                  items: itemCategoryTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  onSaved: (newValue) {
                    detailCtl.text = (newValue!);
                  },
                  controller: detailCtl,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    label: const Text('Chi tiết'),
                    labelStyle: const TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin chi tiết';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  readOnly: true,
                  controller: dateCtl,
                  onChanged: (newValue) {
                    dateCtl.text = newValue;
                  },
                  onSaved: (newValue) {
                    dateCtl.text = newValue!;
                  },
                  decoration: InputDecoration(
                    labelText: "Thời gian giao dịch",
                    hintText: 'Nhập thời gian giao dịch',
                    labelStyle: const TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                  ),
                  onTap: () async {
                    await _showDateTimePicker(context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thời gian diễn ra giao dịch';
                    }
                    try {
                      DateFormat('dd/MM/yyyy HH:mm').parse(value);
                      return null;
                    } catch (e) {
                      return 'Thời gian giao dịch không hợp lệ';
                    }
                  },
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  onSaved: (newValue) {
                    moneyCtl.text = (newValue!);
                  },
                  controller: moneyCtl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                    hintText: 'Nhập giá trị',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text('Lưu'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text('Hủy'),
          )
        ],
      ),
    );
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDateTime != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (selectedTime != null) {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        dateCtl.text = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);
      }
    }
  }

  void save() {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Transaction transaction = Transaction(
          transactionType: transactionCtl.text,
          itemCategoryType: categoryCtl.text,
          itemName: detailCtl.text,
          amount: moneyCtl.text,
          date: dateCtl.text,
        );
        Provider.of<UserInfo>(context, listen: false)
            .addTransaction(transaction);
      }
    } catch (e) {
      print("Error saving transaction: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Loi"),
          content: Text("Co loi xay ra khi luu giao dich. Xin hay thu lai"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    moneyCtl.clear();
    dateCtl.clear();
    transactionCtl.clear();
    categoryCtl.clear();
    detailCtl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTabContent(currentIndex),
      
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: background,
          elevation: 0,
          onPressed: addTransaction,
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
