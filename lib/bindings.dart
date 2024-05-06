import 'package:get/get.dart';
import 'package:moony_app/controller/categories_controller.dart';
import 'package:moony_app/controller/chart_controller.dart';
import 'package:moony_app/controller/icons_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/controller/transactions_filter_controller.dart';
import 'package:moony_app/service/sqlite_service.dart';

class MoonyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SqliteService());
    Get.put(TransactionController());
    Get.put(TransactionsFilterController());
    Get.put(SavingsController());
    Get.put(CategoriesController());
    Get.put(IconsController());
    Get.put(ChartController());
    Get.put(SettingsController());
  }
}
