import 'package:get/get.dart';
import 'package:moony_app/controller/categories_controller.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/service/sqlite_service.dart';

class MoonyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SqliteService());
    Get.put(TransactionController());
    // Get.put(CurrentTransactionController());
    Get.put(CategoriesController());
  }
}
