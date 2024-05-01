import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/categories_controller.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

import '../../../model/category.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key, required this.onSelectCategory});

  final void Function(Category?) onSelectCategory;

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
          return GestureDetector(
            onTap: () {
              onSelectCategory(category);
              Get.back();
            },
            child: Column(
              children: [
                SizedBox(
                  width: 35,
                  child: Image.asset(category?.icon.iconPath ?? ''),
                ),
                Text(
                  category?.name ?? '',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
