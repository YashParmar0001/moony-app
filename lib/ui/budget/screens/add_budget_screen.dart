import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/budget_controller.dart';
import 'package:moony_app/controller/current_budget_controller.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/budget/widgets/budget_date_field.dart';
import 'package:moony_app/ui/home/screens/select_category_screen.dart';
import 'package:moony_app/ui/home/widgets/category_selection_field.dart';
import 'package:moony_app/ui/home/widgets/money_field.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

import '../../home/widgets/date_field.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({
    super.key,
    required this.currentBudgetController,
  });

  final CurrentBudgetController currentBudgetController;

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  late TextEditingController amountController;
  late final CurrentBudgetController currentBudgetController;

  @override
  void initState() {
    currentBudgetController = widget.currentBudgetController;
    amountController = TextEditingController(text: '0');
    amountController.addListener(() {
      currentBudgetController.amount = int.parse(
        amountController.text.isEmpty ? '0' : amountController.text,
      );
      currentBudgetController.validateMoney();
    });
    super.initState();
  }

  @override
  void dispose() {
    currentBudgetController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Add Budget',
        actions: [
          TextButton(
            onPressed: _saveBudget,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            children: [
              Obx(
                () => MoneyField(
                  controller: amountController,
                  errorText: currentBudgetController.amountError,
                ),
              ),
              Card(
                elevation: 3,
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Obx(
                        () => CategorySelectionField(
                          category: currentBudgetController.category,
                          categoryError: currentBudgetController.categoryError,
                          onSelectCategory: () {
                            Get.to(
                              () => SelectCategoryScreen(
                                onlyExpense: true,
                                onSelectCategory: (category) {
                                  currentBudgetController.category = category;
                                  currentBudgetController.validate();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => BudgetDateField(
                          month: currentBudgetController.month,
                          year: currentBudgetController.year,
                          onSelectDate: _showMonthPicker,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveBudget() async {
    final response = await currentBudgetController.addBudget();
    if (response == null) {
      Get.back();
      Get.snackbar(
        'Budget',
        'Successfully added budget!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<BudgetController>().fetchBudgets();
    } else {
      Get.snackbar(
        'Budget',
        response,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _showMonthPicker() async {
    showMonthPicker(
      context,
      onSelected: (month, year) {
        currentBudgetController.month = month;
        currentBudgetController.year = year;
      },
      initialSelectedMonth: currentBudgetController.month,
      initialSelectedYear: currentBudgetController.year,
      highlightColor: AppColors.spiroDiscoBall,
      lastYear: 2100,
    );
  }
}
