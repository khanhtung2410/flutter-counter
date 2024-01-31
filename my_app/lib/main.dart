import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CouterPage(),
    );
  }
}

class CouterPage extends StatefulWidget {
  const CouterPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CouterPageState();
  }
}

class _CouterPageState extends State<CouterPage> {
  final MyObject myObject = MyObject(3);
  final TextEditingController _newval = TextEditingController();
  String value = '';
  int m = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyanAccent, title: const Text('CouterPage')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            child: TextField(
              controller: _newval,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Nhập số nguyên tố n'),
              onChanged: (String value) {
                m = int.parse(value);
              },
            ),
          ),
          const SizedBox(width: 5),
          OutlinedButton.icon(
            onPressed: () {
              String newvalue = myObject.textpower(m).toString();
              print(myObject.textpower(m));
              final updatevalue = newvalue;
              _newval.value = _newval.value.copyWith(
                text: updatevalue,
                selection: TextSelection.collapsed(offset: updatevalue.length),
              );
              m = myObject.textpower(m);
            },
            icon: const Icon(Icons.power),
            label: const Text('Tính lũy thừa bậc n'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Giá trị hiện tại: ${myObject.value}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      myObject.decrease();
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('Giảm'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton.icon(
                    onPressed: () {
                      myObject.increase();
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tăng'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton.icon(
                    onPressed: () {
                      myObject.square();
                      setState(() {});
                    },
                    icon: const Icon(Icons.square),
                    label: const Text('Lũy thừa bậc 2'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton.icon(
                    onPressed: () {
                      myObject.power(3);
                      setState(() {});
                    },
                    icon: const Icon(Icons.power),
                    label: const Text('Lũy thừa bậc 3'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton.icon(
                    onPressed: () {
                      myObject.reset();
                      setState(() {});
                    },
                    icon: const Icon(Icons.reset_tv),
                    label: const Text('Đặt lại'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyObject {
  int _value;
  MyObject(this._value);

  int get value => _value;
  set value(newValue) => _value = newValue;

  void increase() {
    _value++;
  }

  void decrease() {
    _value--;
  }

  void square() {
    _value = _value * _value;
  }

  void reset() {
    _value = 0;
  }

  int power(int n) {
    int base = _value;
    if (n == 0) {
      _value = 1;
    } else {
      for (int i = 2; i <= n; i++) {
        _value = _value * base;
      }
    }
    return _value;
  }

  int textpower(int m) {
    int base = m;
    int result = 0;
    if (m == 0) {
      m = 1;
    } else {
      for (int i = 2; i <= base; i++) {
        m = m * base;
      }
      result = m;
    }
    m = 0;
    return result;
  }
}
