import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_history_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/core/ui/widgets/custom_text_field.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/savings_detail_screen.dart';
import 'package:moony_app/ui/savings/widgets/due_date_field.dart';

import '../../../model/saving.dart';

class SaveHistoryScreen extends StatefulWidget {
  const SaveHistoryScreen({
    super.key,
    required this.currentSavingHistoryController,
    required this.saving,
    required this.moneyIn,
  });

  final CurrentSavingHistoryController currentSavingHistoryController;
  final Saving saving;
  final bool moneyIn;

  @override
  State<SaveHistoryScreen> createState() => _SaveHistoryScreenState();
}

class _SaveHistoryScreenState extends State<SaveHistoryScreen> {
  late final TextEditingController amountController;
  late final TextEditingController descriptionController;
  late final CurrentSavingHistoryController currentSavingHistoryController;

  @override
  void initState() {
    currentSavingHistoryController = widget.currentSavingHistoryController;
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    amountController.addListener(() {
      currentSavingHistoryController.amount = int.parse(
        amountController.text.isEmpty ? '0' : amountController.text,
      );
      currentSavingHistoryController.validateAmount();
    });
    descriptionController.addListener(() {
      currentSavingHistoryController.description = descriptionController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    currentSavingHistoryController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: widget.moneyIn ? 'More Money In' : 'Get Money Out',
        actions: [
          TextButton(
            onPressed: _saveHistory,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Obx(
              () => CustomTextField(
                controller: amountController,
                label: 'Amount',
                keyboardType: TextInputType.number,
                errorText: currentSavingHistoryController.amountError,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
              maxLength: 100,
            ),
            const SizedBox(height: 30),
            Obx(
              () => DueDateField(
                onSelectDate: _showDatePicker,
                date: currentSavingHistoryController.date,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHistory() async {
    final response = await currentSavingHistoryController.addSavingHistory(
      widget.saving,
      widget.moneyIn,
    );
    if (response.error ==  null) {
      Get.back();
      Get.off(
            () => SavingsDetailScreen(saving: response.data!),
        preventDuplicates: false,
      );
      Get.snackbar(
        'Savings',
        widget.moneyIn ? 'Successfully added money!' : 'Got money out!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<SavingsController>().fetchSavings();
    } else {
      Get.snackbar(
        'Savings',
        response.error!,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentSavingHistoryController.date ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      currentSavingHistoryController.date = date;
    }
  }
}
