import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/screens/select_category_screen.dart';
import 'package:moony_app/ui/home/widgets/category_selection_field.dart';
import 'package:moony_app/ui/home/widgets/date_field.dart';
import 'package:moony_app/ui/home/widgets/money_field.dart';
import 'package:moony_app/ui/home/widgets/notes_field.dart';
import 'package:moony_app/ui/home/widgets/transaction_app_bar.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.currentTransactionController,});

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
      appBar: TransactionAppBar(
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
