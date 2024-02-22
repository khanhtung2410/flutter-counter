// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Validate());
}

class Validate extends StatelessWidget {
  const Validate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Validation Site')),
        body: const Center(
          child: Validation(),
        ),
      ),
    );
  }
}

class Validation extends StatefulWidget {
  const Validation({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ValidationState();
  }
}

class _ValidationState extends State<Validation> {
  int _step = 0;
  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _step,
      onStepCancel: () {
        if (_step > 0) {
          setState(() {
            _step -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_step <= 0) {
          setState(() {
            _step += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _step = index;
        });
      },
      steps: const <Step>[
        Step(title: Text('B1'), content: FirstForm()),
      ],
    );
  }
}

class FirstForm extends StatefulWidget {
  const FirstForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FirstFormState();
  }
}

class _FirstFormState extends State<FirstForm> {
  final _formKey = GlobalKey<FormState>();
  var provinceList;
  var districtList;
  var wardList;
  Future<void> loadLocationData() async {
    try {
      String data =
          await rootBundle.loadString('assets/data/don_vi_hanh_chinh.json');
      Map<String, dynamic> jsonData = json.decode(data);

      List provinceData = jsonData["province"];
      provinceList =
          provinceData.map((json) => Province.fromMap(json)).toList();
      print(provinceList[0]);

      List districtData = jsonData["district"];
      districtList =
          districtData.map((json) => District.fromMap(json)).toList();
      List wardData = jsonData["ward"];
      wardList = wardData.map((json) => Ward.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Lỗi load dữ liệu vị trí: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = '';
    loadLocationData();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: FutureBuilder<void>(
          //       future: loadLocationData(),
          //       builder: (BuildContext context, AsyncSnapshot snapshot) {
          //         return DropdownButtonFormField<String>(
          //             value: dropdownValue,
          //             icon: const Icon(Icons.arrow_downward),
          //             items: provinceData.map((json) {
          //               DropdownMenuItem(
          //                 value: provinceData["id"],
          //                 child: Text(provinceData['name']),
          //               );
          //             }).toList(),
          //             onChanged: (String? value) {
          //               setState(() {
          //                 dropdownValue = value!;
          //               });
          //             });
          //       }),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                //Cho bàn phím chỉ hiện số
                LengthLimitingTextInputFormatter(10)
                //Giới hạn số kí tự nhập là 10
              ],
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your phone number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng điền vào chỗ trống";
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}

class Province {
  String? id;
  String? name;
  String? level;
  Province({
    this.id,
    this.name,
    this.level,
  });

  Province copyWith({
    String? id,
    String? name,
    String? level,
  }) {
    return Province(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
    };
  }

  factory Province.fromMap(Map<String, dynamic> map) {
    return Province(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Province.fromJson(String source) =>
      Province.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Province(id: $id, name: $name, level: $level)';

  @override
  bool operator ==(covariant Province other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.level == level;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ level.hashCode;
}

class District {
  String? id;
  String? name;
  String? level;
  String? provinceId;
  District({
    this.id,
    this.name,
    this.level,
    this.provinceId,
  });

  District copyWith({
    String? id,
    String? name,
    String? level,
    String? provinceId,
  }) {
    return District(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      provinceId: provinceId ?? this.provinceId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
      'provinceId': provinceId,
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      provinceId:
          map['provinceId'] != null ? map['provinceId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) =>
      District.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'District(id: $id, name: $name, level: $level, provinceId: $provinceId)';
  }

  @override
  bool operator ==(covariant District other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.level == level &&
        other.provinceId == provinceId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ level.hashCode ^ provinceId.hashCode;
  }
}

class Ward {
  String? id;
  String? name;
  String? level;
  String? districtId;
  String? provinceId;
  Ward({
    this.id,
    this.name,
    this.level,
    this.districtId,
    this.provinceId,
  });

  Ward copyWith({
    String? id,
    String? name,
    String? level,
    String? districtId,
    String? provinceId,
  }) {
    return Ward(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      districtId: districtId ?? this.districtId,
      provinceId: provinceId ?? this.provinceId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'level': level,
      'districtId': districtId,
      'provinceId': provinceId,
    };
  }

  factory Ward.fromMap(Map<String, dynamic> map) {
    return Ward(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      districtId:
          map['districtId'] != null ? map['districtId'] as String : null,
      provinceId:
          map['provinceId'] != null ? map['provinceId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ward.fromJson(String source) =>
      Ward.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ward(id: $id, name: $name, level: $level, districtId: $districtId, provinceId: $provinceId)';
  }

  @override
  bool operator ==(covariant Ward other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.level == level &&
        other.districtId == districtId &&
        other.provinceId == provinceId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        level.hashCode ^
        districtId.hashCode ^
        provinceId.hashCode;
  }
}

class AddressInfo {
  Province? province;
  District? district;
  Ward? ward;
  String? street;
  AddressInfo({
    this.province,
    this.district,
    this.ward,
    this.street,
  });

  AddressInfo copyWith({
    Province? province,
    District? district,
    Ward? ward,
    String? street,
  }) {
    return AddressInfo(
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      street: street ?? this.street,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'province': province?.toMap(),
      'district': district?.toMap(),
      'ward': ward?.toMap(),
      'street': street,
    };
  }

  factory AddressInfo.fromMap(Map<String, dynamic> map) {
    return AddressInfo(
      province: map['province'] != null
          ? Province.fromMap(map['province'] as Map<String, dynamic>)
          : null,
      district: map['district'] != null
          ? District.fromMap(map['district'] as Map<String, dynamic>)
          : null,
      ward: map['ward'] != null
          ? Ward.fromMap(map['ward'] as Map<String, dynamic>)
          : null,
      street: map['street'] != null ? map['street'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressInfo.fromJson(String source) =>
      AddressInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressInfo(province: $province, district: $district, ward: $ward, street: $street)';
  }

  @override
  bool operator ==(covariant AddressInfo other) {
    if (identical(this, other)) return true;

    return other.province == province &&
        other.district == district &&
        other.ward == ward &&
        other.street == street;
  }

  @override
  int get hashCode {
    return province.hashCode ^
        district.hashCode ^
        ward.hashCode ^
        street.hashCode;
  }
}

class UserInfo {
  String? name;
  String? email;
  String? phoneNumber;
  DateTime? birthDate;
  AddressInfo? address;
  UserInfo({
    this.name,
    this.email,
    this.phoneNumber,
    this.birthDate,
    this.address,
  });

  UserInfo copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? birthDate,
    AddressInfo? address,
  }) {
    return UserInfo(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'address': address?.toMap(),
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      birthDate: map['birthDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthDate'] as int)
          : null,
      address: map['address'] != null
          ? AddressInfo.fromMap(map['address'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfo(name: $name, email: $email, phoneNumber: $phoneNumber, birthDate: $birthDate, address: $address)';
  }

  @override
  bool operator ==(covariant UserInfo other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.birthDate == birthDate &&
        other.address == address;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        birthDate.hashCode ^
        address.hashCode;
  }
}
