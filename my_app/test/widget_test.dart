import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  group('Test constructor return object with right given data:', () {
    var province = Province(
        id: '01', name: "Thành phố Hà Nội", level: 'Thành phố trung ương');
    var district = District(
        id: '924', provinceId: '92', name: "Huyện Vĩnh Thạnh", level: 'Huyện');
    var ward = Ward(
        id: '00001',
        provinceId: '01',
        districtId: '001',
        name: "Phường Phúc Xá",
        level: 'Phường');
    var addressInfo = AddressInfo(
        province: province,
        district: district,
        ward: ward,
        street: "Đường Bắc Từ Liêm");
    var userInfo = UserInfo(
        name: 'Tùng',
        email: 'Tung@gmail.com',
        phoneNumber: '0979712341',
        birthDate: null,
        address: addressInfo);
    test('Create province objects', () {
      expect(province.id, equals('01'));
      expect(province.name, equals('Thành phố Hà Nội'));
      expect(province.level, equals('Thành phố trung ương'));
    });
    test('Create district objects', () {
      expect(district.id, equals('924'));
      expect(district.provinceId, equals('92'));
      expect(district.name, equals('Huyện Vĩnh Thạnh'));
      expect(district.level, equals('Huyện'));
    });
    test('Create ward object', () {
      expect(ward.id, equals('00001'));
      expect(ward.provinceId, equals('01'));
      expect(ward.districtId, equals('001'));
      expect(ward.name, equals('Phường Phúc Xá'));
      expect(ward.level, equals('Phường'));
    });
    test('Create addressInfo object', () {
      expect(addressInfo.province?.name, equals('Thành phố Hà Nội'));
      expect(addressInfo.province?.id, equals('01'));
      expect(addressInfo.province?.level, equals('Thành phố trung ương'));
      expect(addressInfo.district?.id, equals('924'));
      expect(addressInfo.district?.provinceId, equals('92'));
      expect(addressInfo.district?.name, equals('Huyện Vĩnh Thạnh'));
      expect(addressInfo.district?.level, equals('Huyện'));
      expect(addressInfo.ward?.id, equals('00001'));
      expect(addressInfo.ward?.provinceId, equals('01'));
      expect(addressInfo.ward?.districtId, equals('001'));
      expect(addressInfo.ward?.name, equals('Phường Phúc Xá'));
      expect(addressInfo.ward?.level, equals('Phường'));
      expect(addressInfo.street, equals('Đường Bắc Từ Liêm'));
    });
    test('Create userInfo object', () {
      expect(userInfo.name, equals("Tùng"));
      expect(userInfo.email, equals("Tung@gmail.com"));
      expect(userInfo.phoneNumber, equals("0979712341"));
      expect(userInfo.birthDate, equals(null));
      expect(userInfo.address, equals(addressInfo));
    });
  });
  group('Test rightnest', () {
    var provinceList;
    var districtList;
    var wardList;
    test('If variable have data from json file', () {
      Future<void> loadLocationData() async {
        final file = File('test/resource/don_vi_hanh_chinh_test.json');
        Map<String, dynamic> jsonData = jsonDecode(await file.readAsString());
        List provinceData = jsonData["province"];
        provinceList =
            provinceData.map((json) => Province.fromMap(json)).toList();
        expect(provinceList.hasData, true);
        List districtData = jsonData["district"];
        districtList =
            districtData.map((json) => District.fromMap(json)).toList();
        expect(districtList.hasData, true);

        List wardData = jsonData["ward"];
        wardList = wardData.map((json) => Ward.fromMap(json)).toList();
        expect(wardList.hasData, true);
      }
    });
    test('If list read right data from json file', () {
      Future<void> loadLocationData() async {
        final file = File('test/resource/don_vi_hanh_chinh_test.json');
        Map<String, dynamic> jsonData = jsonDecode(await file.readAsString());
        List provinceData = jsonData["province"];

        expect(provinceData[0]['id'], equals('01'));
        expect(provinceData[0]['name'], equals('Thành phố Hà Nội'));
        expect(provinceData[0]['level'], equals('Thành phố Trung ương'));

        List districtData = jsonData["district"];

        expect(districtData[0]['id'], equals('001'));
        expect(districtData[0]['name'], equals('Quận Ba Đình'));
        expect(districtData[0]['level'], equals('Quận'));
        expect(districtData[0]['provinceId'], equals('01'));

        List wardData = jsonData["ward"];

        expect(wardData[0]['id'], equals('00001'));
        expect(wardData[0]['name'], equals('Phường Phúc Xá'));
        expect(wardData[0]['level'], equals('Phường'));
        expect(wardData[0]['provinceId'], equals('01'));
        expect(wardData[0]['districtId'], equals('001'));
      }
    });
  });
}
