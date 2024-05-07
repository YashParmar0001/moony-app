import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/model/budget.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/query_response.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/service/sqlite_service.dart';

import '../model/saving_history.dart';

class CurrentBudgetController extends GetxController {
  final _amount = 0.obs;
  final _month = DateTime.now().month.obs;
  final _year = DateTime.now().year.obs;
  final _category = Rx<Category?>(null);

  final _amountError = Rx<String?>(null);
  final _categoryError = Rx<String?>(null);

  int get money => _amount.value;

  Category? get category => _category.value;

  int get month => _month.value;

  int get year => _year.value;

  int get amount => _amount.value;

  String? get amountError => _amountError.value;

  String? get categoryError => _categoryError.value;

  set amount(int value) => _amount.value = value;

  set month(int value) => _month.value = value;

  set year(int value) => _year.value = value;

  set category(Category? category) => _category.value = category;

  void populate(Budget budget) {
    amount = budget.limit;
    category = budget.category;
    month = budget.month;
    year = budget.year;
  }

  Future<String?> addBudget() async {
    if (!validate()) return 'Please fill all the details first!';

    final service = Get.find<SqliteService>();

    try {
      final budget = Budget(
        id: 0,
        limit: amount,
        category: category!,
        month: month,
        year: year,
        transactions: const [],
      );

      final response = await service.addBudget(budget);

      if (response == 0) {
        return 'Something went wrong!';
      } else {
        return null;
      }
    } catch (_) {
      return 'Something went wrong!';
    }
  }

  Future<QueryResponse> updateBudget(Budget oldBudget) async {
    QueryResponse queryResponse = const QueryResponse<Budget>(
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
      final budget = Budget(
        id: oldBudget.id,
        category: category!,
        limit: amount,
        month: month,
        year: year,
        transactions: oldBudget.transactions,
      );
      // dev.log('Updating transaction: $transaction', name: 'Transaction');
      final response = await service.updateBudget(budget);

      if (response == 0) {
        return queryResponse.copyWith(error: 'Something went wrong!');
      } else {
        return queryResponse.copyWith(data: budget);
      }
    } catch (_) {
      return queryResponse.copyWith(error: 'Something went wrong!');
    }
  }

  bool validateMoney() {
    if (money == 0) {
      _amountError.value = 'Money cannot be 0!';
      return false;
    } else {
      _amountError.value = null;
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
