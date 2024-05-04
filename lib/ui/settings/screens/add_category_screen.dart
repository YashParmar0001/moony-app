import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/categories_controller.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/controller/icons_controller.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/widgets/icon_category_card.dart';
import 'package:moony_app/utils/formatting_utils.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key, required this.isIncome});

  final bool isIncome;

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late final IconsController iconsController;
  late final TextEditingController categoryNameController;
  CategoryIcon? selectedIcon;
  final categoryController = Get.find<CategoriesController>();

  @override
  void initState() {
    categoryNameController = TextEditingController();
    iconsController = Get.find<IconsController>()..fetchIcons();
    super.initState();
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: widget.isIncome ? 'Add Income Category' : 'Add Expense Category',
        actions: [
          TextButton(
            onPressed: _saveCategory,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                selectedIcon == null
                    ? const Icon(
                        Icons.question_mark_rounded,
                        color: AppColors.spiroDiscoBall,
                        size: 30,
                      )
                    : Image.asset(
                        selectedIcon!.iconPath,
                        width: 40,
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: categoryNameController,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final icons = iconsController.icons;
            if (icons.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final iconsMap = iconsController.getIconsMap().entries.toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: iconsMap.length,
                  itemBuilder: (context, index) {
                    return IconCategoryCard(
                      onIconSelected: (icon) {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      category: iconsMap[index].key,
                      icons: iconsMap[index].value,
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Future<void> _saveCategory() async {
    if (selectedIcon == null) {
      Get.snackbar('Category', 'Please select icon!');
      return;
    }

    if (categoryNameController.text.isEmpty) {
      Get.snackbar('Category', 'Category name cannot be empty!');
      return;
    }

    final category = Category(
      id: 0,
      isIncome: widget.isIncome,
      name: categoryNameController.text,
      icon: selectedIcon!,
    );
    final response = await categoryController.addCategory(category);
    if (response == null) {
      categoryController.fetchCategories();
      Get.back();
      Get.snackbar(
        'Category',
        'Category added successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Category',
        response,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
