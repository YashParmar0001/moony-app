import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/budget_controller.dart';
import 'package:moony_app/controller/current_budget_controller.dart';
import 'package:moony_app/model/budget.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/budget/widgets/budget_date_field.dart';
import 'package:moony_app/ui/home/screens/select_category_screen.dart';
import 'package:moony_app/ui/home/widgets/category_selection_field.dart';
import 'package:moony_app/ui/home/widgets/money_field.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

import '../../home/widgets/date_field.dart';

class EditBudgetScreen extends StatefulWidget {
  const EditBudgetScreen({
    super.key,
    required this.currentBudgetController,
    required this.budget,
  });

  final CurrentBudgetController currentBudgetController;
  final Budget budget;

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  late TextEditingController amountController;
  late final CurrentBudgetController currentBudgetController;

  @override
  void initState() {
    currentBudgetController = widget.currentBudgetController;
    currentBudgetController.populate(widget.budget);
    amountController = TextEditingController(
      text: currentBudgetController.amount.toString(),
    );
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
        title: 'Edit Budget',
        actions: [
          TextButton(
            onPressed: _updateBudget,
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

  Future<void> _updateBudget() async {
    final response = await currentBudgetController.updateBudget(
      widget.budget
    );
    if (response.error == null) {
      Get.back();
      Get.snackbar(
        'Budget',
        'Successfully updated budget!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<BudgetController>().fetchBudgets();
    } else {
      Get.snackbar(
        'Budget',
        response.error!,
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
