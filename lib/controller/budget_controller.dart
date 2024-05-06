import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/budget.dart';
import 'package:moony_app/service/sqlite_service.dart';

class BudgetController extends GetxController {
  final _budgets = <Budget>[].obs;
  late Rx<DateTime> _currentTime;
  final _totalBudget = 0.obs, _totalSpent = 0.obs;

  int get totalBudget => _totalBudget.value;

  int get totalSpent => _totalSpent.value;

  List<Budget> get budgets => _budgets;

  DateTime get currentTime => _currentTime.value;

  final service = Get.find<SqliteService>();

  @override
  void onInit() {
    _currentTime = DateTime.now().obs;
    final worker = ever(_currentTime, (time) {
      reset();
      fetchBudgets();
    });
    super.onInit();
  }

  void setMonthYear(int month, int year) {
    reset();
    _currentTime.value = DateTime(year, month);
  }

  void setPreviousMonth() {
    int year = _currentTime.value.year;
    int month = _currentTime.value.month;

    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }

    _currentTime.value = DateTime(year, month);
  }

  void setNextMonth() {
    int year = _currentTime.value.year;
    int month = _currentTime.value.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    _currentTime.value = DateTime(year, month);
  }

  void calculateStats() {
    int total = 0, spent = 0;
    for (Budget budget in budgets) {
      total += budget.limit;
      spent += budget.spent;
    }
    dev.log('Total budget: $total | Total spent: $spent', name: 'Budget');
    _totalBudget.value = total;
    _totalSpent.value = spent;
  }

  Future<void> fetchBudgets() async {
    dev.log('Fetching budgets', name: 'Budget');
    final budgets = await service.getBudgets(
      _currentTime.value.month,
      _currentTime.value.year,
    );
    for (int i = 0; i < budgets.length; i++) {
      final transactions = await service.getTransactionsByCategory(
        budgets[i].category.id,
        _currentTime.value.month,
        _currentTime.value.year,
      );
      budgets[i] = budgets[i].copyWith(transactions: transactions);
    }
    _budgets.value = budgets;
    calculateStats();
  }

  void reset() {
    _budgets.value = [];
    _totalBudget.value = 0;
    _totalSpent.value = 0;
  }
}
