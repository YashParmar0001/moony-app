import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/query_response.dart';
import 'package:moony_app/service/sqlite_service.dart';

import '../model/saving.dart';
import '../model/saving_history.dart';

class CurrentSavingHistoryController extends GetxController {
  final _description = ''.obs;
  final _amount = 0.obs;
  final _date = Rx<DateTime?>(null);

  final _amountError = Rx<String?>(null);

  String get description => _description.value;

  int get amount => _amount.value;

  DateTime? get date => _date.value;

  String? get amountError => _amountError.value;

  set description(String value) => _description.value = value;

  set amount(int value) => _amount.value = value;

  set date(DateTime? value) => _date.value = value;

  Future<QueryResponse<Saving>> addSavingHistory(
    Saving saving,
    bool moneyIn,
  ) async {
    const queryResponse = QueryResponse<Saving>(data: null, error: null);
    if (!validateAmount()) {
      return queryResponse.copyWith(
        error: 'Amount cannot be empty or 0',
      );
    }
    if (date == null) {
      return queryResponse.copyWith(
        error: 'Please select date first',
      );
    }

    final history = SavingHistory(
      id: 0,
      amount: amount,
      date: date!,
      description: description.isEmpty || description == ''
          ? 'Default description'
          : description,
      moneyIn: moneyIn,
      savingId: saving.id,
    );
    dev.log('Adding saving history: $history', name: 'Saving');
    final service = Get.find<SqliteService>();

    try {
      final response = await service.addSavingHistory(history);
      if (response == 0) {
        return queryResponse.copyWith(error: 'Something went wrong!');
      } else {
        return queryResponse.copyWith(
          data: saving.copyWith(
            history: saving.history..add(history),
          ),
        );
      }
    } catch (_) {
      return queryResponse.copyWith(error: 'Something went wrong!');
    }
  }

  bool validateAmount() {
    if (amount == 0) {
      _amountError.value = 'Amount cannot be empty or 0!';
      return false;
    } else {
      _amountError.value = null;
      return true;
    }
  }

  bool validate() {
    if (!validateAmount()) return false;

    return true;
  }
}