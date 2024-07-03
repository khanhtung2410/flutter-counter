import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:money_manage/data/localstore.dart';
import 'package:money_manage/data/userInfo.dart';
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

  final formKey = GlobalKey<FormState>();
  //Tạo controler
  final transactionCtl = TextEditingController();
  final categoryCtl = TextEditingController();
  final moneyCtl = TextEditingController();
  final dateCtl = TextEditingController();
  final detailCtl = TextEditingController();

  String dropdownTransaction = transactionTypes.first;
  String dropdownCategory = itemCategoryTypes.first;
  //Tạo switch chuyển tab
  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return HomeScreenTab();
      case 1:
        return HomeScreenTab();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return HomeScreenTab();
    }
  }

  //Function thêm giao dịch
  void addTransaction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thêm giao dịch"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  //Form chọn loại chi
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
                //Form chọn mục chi
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
                        return 'Vui lòng chọn mục chi';
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
                //Form nhập chi tiết giao dịch
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
                //Form chọn ngày giờ
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
                //Form nhập số tiền
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
        ),
        actions: [
          //Nút đến funcion lưu
          MaterialButton(
            onPressed: save,
            child: Text('Lưu'),
          ),
          //Nút hủy form
          MaterialButton(
            onPressed: cancel,
            child: Text('Hủy'),
          )
        ],
      ),
    );
  }

 

  //Function hiện chọn ngày và giờ
  Future<void> _showDateTimePicker(BuildContext context) async {
    //Hiện bộ chọn ngày với biến selectedDateTime
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    //Nếu ngày được chọn, hiện bộ chọn giờ với ngày được chọn ở biến selectedDateTime
    if (selectedDateTime != null) {
      //Hiện bộ chọn giờ với biến selectedTime
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      //Nếu selectedTime không null, chuyển vào DateTime biến vừa chọn
      if (selectedTime != null) {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        //Format lại DateTime vào controller
        dateCtl.text = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);
      }
    }
  }

  //Function lưu
  void save() {
    try {
      //Kiểm tra state của form có hợp lệ không
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        //Tạo transaction mới với dữ liệu là các controller từ form
        Transaction transaction = Transaction(
          transactionType: transactionCtl.text,
          itemCategoryType: categoryCtl.text,
          itemName: detailCtl.text,
          amount: moneyCtl.text,
          date: dateCtl.text,
        );
        //Lấy dữ liệu từ Provider cao hơn
        UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
        //Kiểm tra loại giao dịch và cập nhật dòng tiền
    

        //Lưu giao dịch vào class userInfo
        userInfo.addTransaction(transaction);
        //Lưu dữ liệu giao dịch và người dùng vào localStorage
        LocalStorageManager.saveUserInfo(userInfo);
        LocalStorageManager.saveTransaction(transaction);
        //Báo cho wiget liên quan đến UserInfo là có thay đổi dữ liệu
        Provider.of<UserInfo>(context, listen: false).notifyListeners();
      }
    } catch (e) {
      //Bắt lỗi
      print("Error saving transaction: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lỗi"),
          content: Text("Có lỗi xảy ra khi lưu giao dịch. Xin hãy thử lại"),
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
    //Gọi function làm sạch form
    clear();
  }

  //Function hủy
  void cancel() {
    //Đẩy ra khỏi thông báo và xóa dữ liệu ở controller
    Navigator.pop(context);
    clear();
  }

  //Function xóa hết dữ liệu nhập ở controller
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
      //Tạo các màn hình khác nhau
      body: buildTabContent(currentIndex),
      //Nút bấm ở góc phải bên dưới màn hình để đến hai function thêm và xóa giao dịch
      floatingActionButton: SpeedDial(
        //Tạo kiểu
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          //Nút đến funtion thêm giao dịch
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            label: 'Thêm giao dịch',
            onTap: addTransaction,
          ),
          //Nút đến funtion xóa giao dịch
          SpeedDialChild(
            child: Icon(Icons.delete),
            backgroundColor: Colors.orange,
            label: 'Xóa giao dịch',
            onTap: (){},
          ),
          SpeedDialChild(
            child: Icon(Icons.change_circle),
            backgroundColor: Color.fromARGB(255, 255, 133, 20),
            labelBackgroundColor: Colors.white,
            label: 'Sửa giao dịch',
            onTap: () {},
          ),
        ],
      ),
      //Thanh để đến các màn hình khác nhau
      bottomNavigationBar: BottomNavigationBar(
        //Lấy vị trí trong danh sách tab
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: secondaryDark,
        unselectedItemColor: fontLight,
        items: [
          //Các màn hình khác nhau
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
