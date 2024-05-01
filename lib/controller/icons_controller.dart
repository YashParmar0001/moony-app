import 'dart:developer' as dev;

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/service/sqlite_service.dart';

class IconsController extends GetxController {
  final _icons = <CategoryIcon>[].obs;

  List<CategoryIcon> get icons => _icons;

  final dbService = Get.find<SqliteService>();

  Future<void> fetchIcons() async {
    _icons.value = Set<CategoryIcon>.from(await dbService.getIcons()).toList();
    dev.log('Icons size: ${icons.length}', name: 'Icons');
  }

  Map<String, List<CategoryIcon>> getIconsMap() {
    Map<String, List<CategoryIcon>> iconMap = groupBy(
      _icons,
      (CategoryIcon icon) => icon.iconCategory,
    ).map((key, value) => MapEntry(key, value));
    return iconMap;
  }
}
