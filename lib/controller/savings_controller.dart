import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/service/sqlite_service.dart';

class SavingsController extends GetxController {
  final _savings = RxList<Saving>();

  List<Saving> get savings => _savings;

  final service = Get.find<SqliteService>();

  @override
  void onInit() {
    fetchSavings();
    super.onInit();
  }

  Future<void> fetchSavings() async {
    _savings.value = await service.getSavings();
    dev.log('Savings fetched: $savings', name: 'Saving');
  }
}
