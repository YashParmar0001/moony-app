import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/core/ui/widgets/alert_dialog.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/screens/select_category_screen.dart';
import 'package:moony_app/ui/home/widgets/category_selection_field.dart';
import 'package:moony_app/ui/home/widgets/date_field.dart';
import 'package:moony_app/ui/home/widgets/money_field.dart';
import 'package:moony_app/ui/home/widgets/notes_field.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

import '../../../controller/savings_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
    required this.currentTransactionController,
  });

  final CurrentTransactionController currentTransactionController;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController moneyController, noteController;
  final transactionController = Get.find<TransactionController>();
  late final CurrentTransactionController currentTransactionController;

  @override
  void initState() {
    currentTransactionController = widget.currentTransactionController;
    moneyController = TextEditingController(text: '0');
    noteController = TextEditingController();
    moneyController.addListener(() {
      currentTransactionController.money = int.parse(
        moneyController.text.isEmpty ? '0' : moneyController.text,
      );
      currentTransactionController.validateMoney();
    });
    noteController.addListener(() {
      currentTransactionController.note = noteController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    currentTransactionController.dispose();
    moneyController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Add Transaction',
        actions: [
          TextButton(
            onPressed: _saveTransaction,
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
                  controller: moneyController,
                  errorText: currentTransactionController.moneyError,
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
                          category: currentTransactionController.category,
                          categoryError:
                              currentTransactionController.categoryError,
                          onSelectCategory: () {
                            Get.to(
                              () => SelectCategoryScreen(
                                onSelectCategory: (category) {
                                  currentTransactionController.category =
                                      category;
                                  currentTransactionController.validate();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Obx(() {
                        final category = currentTransactionController.category;
                        if (category != null && category.name == 'Saving') {
                          final savings = Get.find<SavingsController>().savings;
                          if (savings.isEmpty) {
                            return const SizedBox();
                          }

                          currentTransactionController.saving = savings.first;

                          dev.log('Savings: $savings',
                              name: 'TransactionSavings');
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.savings_outlined,
                                  color: AppColors.spiroDiscoBall,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: savings.first.id,
                                    items: List.generate(
                                      savings.length,
                                      (index) => DropdownMenuItem(
                                        value: savings[index].id,
                                        child: Text(
                                          savings[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value != null) {
                                        currentTransactionController.saving =
                                            savings
                                                .where((e) => e.id == value)
                                                .first;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                      const SizedBox(height: 10),
                      NotesField(controller: noteController),
                      const SizedBox(height: 20),
                      Obx(
                        () => DateField(
                          date: currentTransactionController.date,
                          onSelectDate: () {
                            _showDatePicker();
                          },
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

  void _showNoSavingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'No Savings',
          content:
              "You have no saving goals to add this category. Try adding one!",
          onPressOk: () => Get.back,
          onPressCancel: () {},
          showOnlyOK: true,
        );
      },
    );
  }

  Future<void> _saveTransaction() async {
    final response = await currentTransactionController.addTransaction();
    if (response == null) {
      Get.back();
      Get.snackbar(
        'Transaction',
        'Successfully added transaction!',
        snackPosition: SnackPosition.BOTTOM,
      );
      transactionController.fetchTransactions();
    } else {
      Get.snackbar(
        'Transaction',
        response,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      currentTransactionController.date = date;
    }
  }
}
