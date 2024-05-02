import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/query_response.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/model/saving_history.dart';
import 'package:moony_app/service/sqlite_service.dart';

class SavingsController extends GetxController {
  final _savings = RxList<Saving>();
  final _goal = 0.obs, _inProgress = 0.obs, _completed = 0.obs;

  List<Saving> get savings => _savings;

  int get goal => _goal.value;

  int get inProgress => _inProgress.value;

  int get completed => _completed.value;

  final service = Get.find<SqliteService>();

  @override
  void onInit() {
    fetchSavings();
    super.onInit();
  }

  void calculateStats() {
    int inProgress = 0, completed = 0;
    for (Saving saving in savings) {
      if (saving.remainingMoney == 0) {
        completed++;
      } else {
        inProgress++;
      }
    }
    _goal.value = savings.length;
    _inProgress.value = inProgress;
    _completed.value = completed;
  }

  Future<void> fetchSavings() async {
    final savingList = await service.getSavings();
    final updatedSavingList = <Saving>[];
    for (Saving saving in savingList) {
      final history = await service.getSavingHistory(saving.id);
      dev.log(
        'Got saving history for id: ${saving.id} => $history',
        name: 'Saving',
      );
      saving = saving.copyWith(history: history);
      updatedSavingList.add(saving);
    }
    dev.log('Final savings list: $updatedSavingList', name: 'Saving');
    _savings.value = updatedSavingList;
    calculateStats();
  }

  Future<bool> deleteSaving(int id) async {
    final count = await service.deleteSaving(id);
    final historyCount = await service.deleteSavingHistory(id);
    return count >= 1 && historyCount >= 1;
  }

  Future<QueryResponse<Saving>> deleteSavingHistory(int id, Saving saving,) async {
    const queryResponse = QueryResponse<Saving>(data: null, error: null);
    final count = await service.deleteSavingHistoryById(id);
    if (count >= 1) {
      return queryResponse.copyWith(
        data: saving.copyWith(
          history: saving.history..removeWhere((e) => e.id == id),
        ),
      );
    }else {
      return queryResponse.copyWith(error: 'Something went wrong!');
    }
  }
}
