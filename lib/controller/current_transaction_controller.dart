import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/query_response.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/service/sqlite_service.dart';

import '../model/saving_history.dart';

class CurrentTransactionController extends GetxController {
  final _money = 0.obs;
  final _category = Rx<Category?>(null);
  final _note = ''.obs;
  final _date = DateTime.now().obs;
  final _saving = Rx<Saving?>(null);

  final _moneyError = Rx<String?>(null);
  final _categoryError = Rx<String?>(null);

  int get money => _money.value;

  Category? get category => _category.value;

  String get note => _note.value;

  DateTime get date => _date.value;

  String? get moneyError => _moneyError.value;

  String? get categoryError => _categoryError.value;

  Saving? get saving => _saving.value;

  set money(int value) => _money.value = value;

  set category(Category? category) => _category.value = category;

  set note(String value) => _note.value = value;

  set date(DateTime value) => _date.value = value;

  set saving(Saving? value) => _saving.value = value;

  @override
  void onInit() {
    Worker worker = ever(_category, (category) {
      if (category != null && category.name == 'Saving') {
        final savings = Get.find<SavingsController>().savings;
        if (savings.isEmpty) {
          dev.log('Savings are empty', name: 'Saving');
          _category.value = null;
          Get.snackbar(
            'Category',
            'You have no saving goals, Try adding one!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    });
    super.onInit();
  }

  void populate(Transaction transaction) {
    money = transaction.money;
    category = transaction.category;
    note = transaction.note;
    date = transaction.date;
  }

  Future<String?> addTransaction() async {
    if (!validate()) return 'Please fill all the details first!';

    final service = Get.find<SqliteService>();

    try {
      final transaction = Transaction(
        id: 0,
        money: money,
        category: category!,
        note: note,
        date: date,
      );
      int? historyId;
      SavingHistory? history;
      if (category!.name == 'Saving' && saving != null) {
        history = SavingHistory(
          id: 0,
          amount: transaction.money,
          date: date,
          description: category!.isIncome
              ? 'Add money to ${saving!.title} saving'
              : 'Get money out from ${saving!.title} saving',
          moneyIn: category!.isIncome ? false : true,
          savingId: saving!.id,
        );
        final id = await service.addSavingHistory(history);
        if (id != 0) historyId = id;
      }

      final response = await service.addTransaction(
        transaction.copyWith(historyId: historyId),
      );

      if (response == 0) {
        return 'Something went wrong!';
      } else {
        if (historyId != null && history != null) {
          await service.updateSavingHistory(
            history.copyWith(
              id: historyId,
              transactionId: response,
            ),
          );
        }
        return null;
      }
    } catch (_) {
      return 'Something went wrong!';
    }
  }

  Future<QueryResponse> updateTransaction(int id) async {
    QueryResponse queryResponse = const QueryResponse<Transaction>(
      data: null,
      error: null,
    );
    if (!validate()) {
      return queryResponse.copyWith(
        error: 'Please fill the details properly!',
      );
    }

    final service = Get.find<SqliteService>();

    try {
      final transaction = Transaction(
        id: id,
        money: money,
        category: category!,
        note: note,
        date: date,
      );
      // dev.log('Updating transaction: $transaction', name: 'Transaction');
      final response = await service.updateTransaction(
        transaction,
      );

      if (response == 0) {
        return queryResponse.copyWith(error: 'Something went wrong!');
      } else {
        return queryResponse.copyWith(data: transaction);
      }
    } catch (_) {
      return queryResponse.copyWith(error: 'Something went wrong!');
    }
  }

  bool validateMoney() {
    if (money == 0) {
      _moneyError.value = 'Money cannot be 0!';
      return false;
    } else {
      _moneyError.value = null;
      return true;
    }
  }

  bool validate() {
    if (!validateMoney()) return false;

    if (category == null) {
      _categoryError.value = 'Please select category!';
      return false;
    } else {
      _categoryError.value = null;
    }

    return true;
  }
}
