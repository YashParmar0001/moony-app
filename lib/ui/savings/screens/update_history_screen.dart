import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_history_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/core/ui/widgets/custom_text_field.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/model/saving_history.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/history_detail_screen.dart';
import 'package:moony_app/ui/savings/screens/savings_detail_screen.dart';
import 'package:moony_app/ui/savings/widgets/due_date_field.dart';

class UpdateHistoryScreen extends StatefulWidget {
  const UpdateHistoryScreen({
    super.key,
    required this.currentSavingHistoryController,
    required this.history,
  });

  final CurrentSavingHistoryController currentSavingHistoryController;
  final SavingHistory history;

  @override
  State<UpdateHistoryScreen> createState() => _UpdateHistoryScreenState();
}

class _UpdateHistoryScreenState extends State<UpdateHistoryScreen> {
  late final TextEditingController amountController;
  late final TextEditingController descriptionController;
  late final CurrentSavingHistoryController currentSavingHistoryController;

  @override
  void initState() {
    currentSavingHistoryController = widget.currentSavingHistoryController;
    currentSavingHistoryController.populate(widget.history);
    descriptionController = TextEditingController(
      text: currentSavingHistoryController.description,
    );
    amountController = TextEditingController(
      text: currentSavingHistoryController.amount.toString(),
    );
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
        title: widget.history.moneyIn ? 'More Money In' : 'Get Money Out',
        actions: [
          TextButton(
            onPressed: updateSavingHistory,
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
                date: currentSavingHistoryController.date,
                onSelectDate: _showDatePicker,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> updateSavingHistory() async {
    final savings = Get.find<SavingsController>().savings;
    final response = await currentSavingHistoryController.updateSavingHistory(
      widget.history.id,
      savings.where((e) => e.id == widget.history.savingId).first,
      widget.history.moneyIn,
    );
    if (response.error == null) {
      Get.back();
      Get.back();
      Get.off(
        () => SavingsDetailScreen(saving: response.data!, initialTabIndex: 1),
        preventDuplicates: false,
      );
      Get.to(
        () => HistoryDetailsScreen(
          history: response.data!.history
              .where((e) => e.id == widget.history.id)
              .first,
        ),
      );
      Get.snackbar(
        'Savings',
        'Successfully updated saving history!',
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
