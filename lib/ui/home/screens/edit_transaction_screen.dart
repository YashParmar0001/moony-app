import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/screens/select_category_screen.dart';
import 'package:moony_app/ui/home/screens/transaction_detail_screen.dart';
import 'package:moony_app/ui/home/widgets/category_selection_field.dart';
import 'package:moony_app/ui/home/widgets/date_field.dart';
import 'package:moony_app/ui/home/widgets/money_field.dart';
import 'package:moony_app/ui/home/widgets/notes_field.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({
    super.key,
    required this.currentTransactionController,
    required this.transaction,
  });

  final CurrentTransactionController currentTransactionController;
  final Transaction transaction;

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController moneyController, noteController;
  final transactionController = Get.find<TransactionController>();
  late final CurrentTransactionController currentTransactionController;

  @override
  void initState() {
    currentTransactionController = widget.currentTransactionController;
    currentTransactionController.populate(widget.transaction);
    moneyController = TextEditingController(
      text: currentTransactionController.money.toString(),
    );
    noteController = TextEditingController(
      text: currentTransactionController.note,
    );
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
        title: 'Edit Transaction',
        actions: [
          TextButton(
            onPressed: _updateTransaction,
            child: const Text('Update'),
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
              MoneyField(
                controller: moneyController,
                errorText: currentTransactionController.moneyError,
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
                          categoryError:
                              currentTransactionController.categoryError,
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

  Future<void> _updateTransaction() async {
    final response = await currentTransactionController.updateTransaction(
      widget.transaction.id,
    );
    if (response.error == null) {
      Get.back();
      Get.off(
        () => TransactionDetailsScreen(transaction: response.data!),
        preventDuplicates: false,
      );
      Get.snackbar(
        'Transaction',
        'Successfully updated transaction!',
        snackPosition: SnackPosition.BOTTOM,
      );
      transactionController.fetchTransactions();
    } else {
      Get.snackbar(
        'Transaction',
        response.error!,
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
