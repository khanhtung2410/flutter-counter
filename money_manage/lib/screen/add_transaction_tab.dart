import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';
import 'package:money_manage/data/localstore.dart';

import 'package:money_manage/data/userInfo.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class AddTransactionTab extends StatefulWidget {
  const AddTransactionTab({super.key});

  @override
  State<AddTransactionTab> createState() => _AddTransactionTabState();
}

class _AddTransactionTabState extends State<AddTransactionTab> {
  final formKey = GlobalKey<FormState>();
  UserInfo userInfo = getMockUserInfo();
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thêm giao dịch"),
        ),
        body: Container(
          child: Column(
            children: [
              TransactionForm(
                formKey: formKey,
                userInfo: userInfo,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    await LocalStorageManager.saveUserInfo(userInfo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã lưu giao dịch thành công'),
                      ),
                    );
                  }
                },
                child: Text('Lưu giao dịch'),
              ),
            ],
          ),
        ));
  }
}

class TransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;

  const TransactionForm({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  // var formatter = NumberFormat('###,###,###,000');
  final moneyCtl = TextEditingController();
  final dateCtl = TextEditingController();
  String dropdownTransaction = transactionTypes.first;
  String dropdownCategory = itemCategoryTypes.first;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultSpacing),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: defaultSpacing * 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                onChanged: (newValue) {
                  _updateTransactionType(newValue);
                },
                onSaved: (newValue) {
                  _updateTransactionType(newValue);
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
                  _updateItemCategoryType(newValue);
                },
                onSaved: (newValue) {
                  _updateItemCategoryType(newValue);
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
                onChanged: (newValue) {
                  _updateItemName(newValue);
                },
                onSaved: (newValue) {
                  _updateItemName(newValue!);
                },
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
                  _updateDateTime(newValue);
                },
                onSaved: (newValue) {
                  _updateDateTime(newValue!);
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
                onChanged: (newValue) {
                  _updateAmount(newValue);
                },
                onSaved: (newValue) {
                  _updateAmount(newValue!);
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
    );
  }

  void _updateTransactionType(String? newValue) {
    if (newValue != null) {
      setState(() {
        Transaction newTransaction = Transaction(
          transactionType: newValue,
        );
        widget.userInfo.transactions?.add(newTransaction);
      });
    }
  }

  void _updateItemCategoryType(String? newValue) {
    if (newValue != null) {
      setState(() {
        Transaction? currentTransaction =
            widget.userInfo.transactions?.lastOrNull;
        if (currentTransaction != null) {
          currentTransaction.itemCategoryType = newValue;
        }
      });
    }
  }

  void _updateItemName(String value) {
    setState(() {
      Transaction? currentTransaction =
          widget.userInfo.transactions?.lastOrNull;
      if (currentTransaction != null) {
        currentTransaction.itemName = value;
      }
    });
  }

  void _updateDateTime(String value) {
    setState(() {
      Transaction? currentTransaction =
          widget.userInfo.transactions?.lastOrNull;
      if (currentTransaction != null) {
        currentTransaction.date = value;
      }
    });
  }

  void _updateAmount(String value) {
    setState(() {
      Transaction? currentTransaction =
          widget.userInfo.transactions?.lastOrNull;
      if (currentTransaction != null) {
        currentTransaction.amount = value;
      }
    });
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
        _updateDateTime(dateCtl.text);
      }
    }
  }
}
