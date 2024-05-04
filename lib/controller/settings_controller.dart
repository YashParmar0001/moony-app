import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final _currencyUnit = 'none'.obs;
  final _currencyKey = 'currency_unit';

  String get currencyUnit => _currencyUnit.value;
  String get currency => currencyUnit == 'none' ? '' : currencyUnit;

  late final SharedPreferences sharedPrefs;

  @override
  Future<void> onInit() async {
    sharedPrefs = await SharedPreferences.getInstance();
    _currencyUnit.value = sharedPrefs.getString(_currencyKey) ?? 'none';
    dev.log('Currency unit: $currencyUnit', name: 'Settings');
    super.onInit();
  }

  Future<void> setCurrencyUnit(String value) async {
    _currencyUnit.value = value;
    await sharedPrefs.setString(_currencyKey, value);
  }
}