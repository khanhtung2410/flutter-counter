import 'package:flutter/material.dart';
import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/screen/home_profile_tab.dart';
import 'package:money_manage/screen/home_screen_tab.dart';
import 'package:money_manage/ultils/colors_and_size.dart';
import 'package:intl/intl.dart';

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
          onPressed: () {},
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
  var formatter = NumberFormat('###,###,###,000');
  final moneyCtl = TextEditingController();
  final dateCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ItemCategoryType? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: defaultSpacing * 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<ItemCategoryType>(
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
              value: ItemCategoryType.health,
              onChanged: (ItemCategoryType? categoryNumber) {
                setState(() {
                  selectedItem = categoryNumber;
                });
              },
              items: ItemCategoryType.values
                  .map<DropdownMenuItem<ItemCategoryType>>(
                      (ItemCategoryType categoryNumber) {
                return DropdownMenuItem<ItemCategoryType>(
                  value: categoryNumber,
                  child: Text(categoryNumber.categoryLabel),
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
              readOnly: true,
              controller: dateCtl,
              decoration: InputDecoration(
                labelText: "Ngày giao dịch",
                hintText: 'Nhập ngày giao dịch',
                labelStyle: const TextStyle(
                  fontSize: fontSizeHeading,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
              ),
              onTap: () async {
                DateTime? date = DateTime(1900);
                FocusScope.of(context).requestFocus(FocusNode());
                date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  DateTime() = date;
                  final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(date));
                  dateCtl.text = DateFormat('dd/MM/yyyy HH:mm').format(DateTime(
                      date.year,
                      date.month,
                      date.day,
                      selectedTime!.hour,
                      selectedTime.minute));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập ngày diễn ra giao dịch';
                }
                try {
                  DateFormat('dd/MM/yyyy').parse(value);
                  return null;
                } catch (e) {
                  return 'Ngày giao dịch không hợp lệ';
                }
              },
            ),
          ),
          const SizedBox(
            height: defaultSpacing,
          ),
          const SizedBox(
            height: defaultSpacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: moneyCtl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                hintText: 'Nhập giá trị',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // var newVal = int.parse(value);
                // value = formatter.format(newVal);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số tiền';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
