import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';

import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class AddTransactionTab extends StatefulWidget {
  const AddTransactionTab({super.key});

  @override
  State<AddTransactionTab> createState() => _AddTransactionTabState();
}

class _AddTransactionTabState extends State<AddTransactionTab> {
  final formKey = GlobalKey<FormState>();
  UserInfo userInfo = UserInfo();
  bool isLoaded = false;
  List<ItemCategoryType> itemCategoryList = [];
  List<TransactionType> transactionTypeList = [];

  @override
  void initState() {
    super.initState();
    loadLocationData().then((value) {
      setState(() {
        isLoaded = true;
        itemCategoryList = value['itemCategoryList'] ?? [];
        transactionTypeList = value['transactionTypeList'] ?? [];
      });
    });
  }

  Future<Map<String, dynamic>> loadLocationData() async {
    try {
      String data = await rootBundle.loadString("assest/data/thss.json");
      Map<String, dynamic> jsonData = json.decode(data);
      List itemCategoryData = jsonData["itemCategory"];
      List transactionTypeData = jsonData["transactionType"];
      List<ItemCategoryType> itemCategoryList = itemCategoryData
          .map((json) => ItemCategoryType.fromMap(json))
          .toList();
      List<TransactionType> transactionTypeList = transactionTypeData
          .map((json) => TransactionType.fromMap(json))
          .toList();
      return {
        "itemCategoryList": itemCategoryList,
        "transactionTypeList": transactionTypeList,
      };
    } catch (e) {
      debugPrint('Error loading type data: $e');
      return {
        "itemCategory": [],
        "transactionType": [],
      };
    }
  }

  void saveForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      saveUserTransactions(userInfo).then(
        (value) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thông báo'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('Hồ sơ giao dịch đã được lưu thành công'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Đóng"))
                ],
              );
            },
          );
        },
      );
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm giao dịch"),
      ),
      body: isLoaded
          ? Container(
              child: Column(
                children: [
                  TransactionForm(
                    formKey: formKey,
                    userInfo: userInfo,
                    itemCategoryList: itemCategoryList,
                    transactionTypeList: transactionTypeList,
                  ),
                  ElevatedButton(onPressed: saveForm, child: const Text('Lưu')),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class TransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  final List<ItemCategoryType> itemCategoryList;
  final List<TransactionType> transactionTypeList;
  const TransactionForm(
      {super.key,
      required this.formKey,
      required this.userInfo,
      required this.itemCategoryList,
      required this.transactionTypeList});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  // var formatter = NumberFormat('###,###,###,000');
  final moneyCtl = TextEditingController();
  final dateCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultSpacing),
      child: Form(
        key: widget.key,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: defaultSpacing * 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
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
                  if (widget.userInfo.transactions?.transactionType == null ||
                      value!.isEmpty) {
                    return 'Vui lòng chọn loại giao dịch';
                  }
                  return null;
                },
                value: widget.userInfo.transactions?.transactionType
                        ?.transactionLabel ??
                    "2",
                onChanged: (newValue) {
                  setState(() {
                    widget.userInfo.transactions?.transactionType
                        ?.transactionLabel = newValue;
                  });
                },
                items: widget.transactionTypeList
                    .map<DropdownMenuItem<String>>((TransactionType map) {
                  return DropdownMenuItem<String>(
                    value: map.transactionNumber,
                    child: Text(map.transactionLabel ?? 'Error'),
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
                  if (widget.userInfo.transactions?.categoryType == null ||
                      value!.isEmpty) {
                    return 'Vui lòng chọn loại giao dịch';
                  }
                  return null;
                },
                value:
                    widget.userInfo.transactions?.categoryType?.categoryLabel ??
                        "1",
                onChanged: (newValue) {
                  setState(() {
                    widget.userInfo.transactions?.categoryType?.categoryLabel =
                        newValue;
                  });
                },
                items: widget.itemCategoryList
                    .map<DropdownMenuItem<String>>((ItemCategoryType map) {
                  return DropdownMenuItem<String>(
                    value: map.categoryNumber,
                    child: Text(map.categoryLabel ?? "Error"),
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
                onChanged: (value) =>
                    widget.userInfo.transactions?.itemName = value,
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
                    dateCtl.text = DateFormat('dd/MM/yyyy HH:mm').format(
                        DateTime(date.year, date.month, date.day,
                            selectedTime!.hour, selectedTime.minute));
                  }
                },
                onChanged: (value) =>
                    widget.userInfo.transactions?.date = value,
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
                controller: moneyCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  hintText: 'Nhập giá trị',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    widget.userInfo.transactions?.amount = value,
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
    );
  }
}

Future<void> saveUserTransactions(UserInfo userInfo) async {
  return await Localstore.instance
      .collection('users')
      .doc('transaction')
      .set(userInfo.toMap());
}
