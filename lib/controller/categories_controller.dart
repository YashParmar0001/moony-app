import 'package:get/get.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/service/sqlite_service.dart';

class CategoriesController extends GetxController {
  final _categories = <Category>[].obs;
  List<Category> get categories => _categories;

  final dbService = Get.find<SqliteService>();

  Future<void> fetchCategories() async {
    _categories.value = await dbService.getCategories();
  }
}