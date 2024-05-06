import 'package:get/get.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/model/transaction.dart';

import '../model/category.dart';

class TransactionsFilterController extends GetxController {
  final _categoryFilterApplied = false.obs;
  final _incomeFilterApplied = false.obs;
  final _totalCategoryExpense = 0.obs;
  final _filteredList = <Transaction>[].obs;

  bool get categoryFilterApplied => _categoryFilterApplied.value;

  bool get incomeFilterApplied => _incomeFilterApplied.value;

  int get totalCategoryExpense => _totalCategoryExpense.value;

  List<Transaction> get filteredList => _filteredList;

  bool get filterApplied => categoryFilterApplied || incomeFilterApplied;

  void filterCategoryWise(Category category) {
    final transactions = Get.find<TransactionController>().transactions;

    _filteredList.value = transactions
        .where((transaction) => transaction.category == category)
        .toList();

    int total = 0;
    for (Transaction transaction in filteredList) {
      total += transaction.money;
    }
    _categoryFilterApplied.value = true;
    _totalCategoryExpense.value = total;
  }

  void filterIncomeStatus(bool isIncome) {
    final transactions = Get.find<TransactionController>().transactions;

    _filteredList.value = transactions.where((transaction) {
      if (isIncome) {
        return transaction.category.isIncome;
      } else {
        return !transaction.category.isIncome;
      }
    }).toList();
    _categoryFilterApplied.value = false;
    _incomeFilterApplied.value = true;
  }

  void removeFilters() {
    _categoryFilterApplied.value = false;
    _totalCategoryExpense.value = 0;
    _incomeFilterApplied.value = false;
  }
}
