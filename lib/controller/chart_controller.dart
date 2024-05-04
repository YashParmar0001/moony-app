import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/model/chart_item.dart';
import 'package:moony_app/service/sqlite_service.dart';

class ChartController extends GetxController {
  final _chartItems = <ChartItem>[].obs;
  late Rx<DateTime> _currentTime;
  final _totalExpense = 0.obs;
  final _showExpense = true.obs;

  DateTime get currentTime => _currentTime.value;

  int get totalExpense => _totalExpense.value;

  bool get showExpense => _showExpense.value;

  List<ChartItem> get chartItems => _chartItems;

  final service = Get.find<SqliteService>();

  @override
  void onInit() {
    _currentTime = DateTime.now().obs;
    // fetchTransactions();
    ever(_currentTime, (date) {
      _showExpense.value = true;
      fetchItems(showExpense);
    });
    ever(_showExpense, (showExpense) {
      fetchItems(showExpense);
    });
    super.onInit();
  }

  void setMonthYear(int month, int year) {
    _currentTime.value = DateTime(year, month);
  }

  void changeMode() {
    _showExpense.value = !_showExpense.value;
    dev.log('Mode changed: $showExpense', name: 'Chart');
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

  Future<void> fetchItems(bool showExpenses) async {
    final transactions = await service.getTransactions(currentTime);

    final categoryAmountMap = <Category, int>{};

    int total = 0;
    for (final transaction in transactions) {
      final category = transaction.category;
      if (showExpenses && !category.isIncome) {
        categoryAmountMap[category] =
            (categoryAmountMap[category] ?? 0) + transaction.money;
        total += transaction.money;
      } else if (!showExpenses && category.isIncome) {
        categoryAmountMap[category] =
            (categoryAmountMap[category] ?? 0) + transaction.money;
        total += transaction.money;
      }
    }
    _totalExpense.value = total;

    _chartItems.value = categoryAmountMap.entries.map(
      (entry) {
        return ChartItem(
          category: entry.key,
          amount: entry.value,
        );
      },
    ).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }

  List<ChartItem> getCombinedChartItems() {
    if (chartItems.length > 5) {
      final items = List<ChartItem>.from(chartItems);
      int otherAmount = 0;
      for (int i = 5; i < chartItems.length; i++) {
        otherAmount += chartItems[i].amount;
      }
      items.removeRange(4, chartItems.length);
      items.add(
        ChartItem(
          category: const Category(
            id: 0,
            name: 'Other',
            icon: CategoryIcon(
              id: 0,
              iconCategory: '',
              icon: '',
            ),
            isIncome: false,
          ),
          amount: otherAmount,
        ),
      );
      dev.log('Combined chart items: $items', name: 'Chart');
      return items;
    } else {
      return chartItems;
    }
  }
}
