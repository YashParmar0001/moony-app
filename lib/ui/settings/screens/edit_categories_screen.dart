import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/categories_controller.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

import '../../../core/ui/widgets/alert_dialog.dart';
import '../../../model/category.dart';
import '../../../theme/colors.dart';

class EditCategoriesScreen extends StatelessWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.find<CategoriesController>()
      ..fetchCategories();

    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Categories',
        actions: [],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text('EXPENSES'),
                ),
                Tab(
                  child: Text('INCOME'),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Obx(
                    () {
                      final list = categoriesController.categories;
                      if (list.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return _buildCategoriesList(
                          categoriesController.categories
                              .where((e) => !e.isIncome)
                              .toList(),
                        );
                      }
                    },
                  ),
                  Obx(
                    () {
                      final list = categoriesController.categories;
                      if (list.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return _buildCategoriesList(
                          categoriesController.categories
                              .where((e) => e.isIncome)
                              .toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(List<Category?> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          if (category == null) return const SizedBox();
          return GestureDetector(
            onTap: () {
              // onSelectCategory(category);
              // Get.back();
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 35,
                        child: Image.asset(category.icon.iconPath),
                      ),
                      Text(
                        category.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                if (category.name != 'Saving')
                  Positioned(
                    top: 0,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => _showDeleteDialog(context, category.id),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                          color: AppColors.begonia,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteCategory(int id) async {
    final categoriesController = Get.find<CategoriesController>();
    final response = await categoriesController.deleteCategory(id);
    Get.closeAllSnackbars();
    if (response == null) {
      Get.snackbar(
        'Category',
        'Category deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      categoriesController.fetchCategories();
    } else {
      Get.snackbar(
        'Category',
        'Something went wrong. Please try again!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          onPressOk: () {
            Get.back();
            _deleteCategory(id);
          },
          onPressCancel: () {
            Get.back();
          },
          title: 'Warning',
          content: 'Do you really want to delete this category '
              'and ALL the transactions related to it?',
        );
      },
    );
  }
}
