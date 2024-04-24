import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/service/sqlite_service.dart';

class TransactionController extends GetxController {
  final transactions = <Transaction>[].obs;
  late Rx<DateTime> _currentTime;
  final _income = 0.obs, _expenses = 0.obs, _balance = 0.obs;

  DateTime get currentTime => _currentTime.value;
  int get income => _income.value;
  int get expenses => _expenses.value;
  int get balance => _balance.value;
  final service = Get.find<SqliteService>();

  @override
  void onInit() {
    _currentTime = DateTime.now().obs;
    // fetchTransactions();
    ever(_currentTime, (date) {
      fetchTransactions();
    });
    super.onInit();
  }

  void setMonthYear(int month, int year) {
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
    int income = 0, expenses = 0;
    for (Transaction transaction in transactions) {
      if (transaction.category.isIncome) {
        income += transaction.money;
      }else {
        expenses += transaction.money;
      }
    }
    _income.value = income;
    _expenses.value = expenses;
    _balance.value = income - expenses;
  }

  Future<void> fetchTransactions() async {
    transactions.value = await service.getTransactions(_currentTime.value);
    calculateStats();
    dev.log('Fetched transactions', name: 'Transaction');
  }

  Future<bool> deleteTransaction(int id) async {
    final count = await service.deleteTransaction(id);
    return count >= 1;
  }
}
