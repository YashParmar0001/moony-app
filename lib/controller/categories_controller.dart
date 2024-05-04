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

  Future<String?> addCategory(Category category) async {
    try {
      final response = await dbService.addCategory(category);
      if (response == 0) {
        return 'Something went wrong!';
      }else {
        return null;
      }
    }catch(_) {
      return 'Something went wrong!';
    }
  }

  Future<String?> deleteCategory(int id) async {
    try {
      final response = await dbService.deleteCategory(id);
      if (response >= 1) {
        return null;
      } else {
        return 'Something went wrong!';
      }
    } catch (_) {
      return 'Something went wrong!';
    }
  }
}
