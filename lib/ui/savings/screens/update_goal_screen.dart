import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/core/ui/widgets/custom_text_field.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/savings_detail_screen.dart';
import 'package:moony_app/ui/savings/screens/select_icon_screen.dart';

import '../widgets/due_date_field.dart';
import '../widgets/icon_selection_field.dart';

class UpdateGoalScreen extends StatefulWidget {
  const UpdateGoalScreen({
    super.key,
    required this.currentSavingController,
    required this.saving,
  });

  final CurrentSavingController currentSavingController;
  final Saving saving;

  @override
  State<UpdateGoalScreen> createState() => _UpdateGoalScreenState();
}

class _UpdateGoalScreenState extends State<UpdateGoalScreen> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final CurrentSavingController currentSavingController;
  final savingsController = Get.find<SavingsController>();

  @override
  void initState() {
    currentSavingController = widget.currentSavingController;
    currentSavingController.populate(widget.saving);
    titleController = TextEditingController(
      text: currentSavingController.title,
    );
    amountController = TextEditingController(
      text: currentSavingController.amount.toString(),
    );
    titleController.addListener(() {
      currentSavingController.title = titleController.text;
      currentSavingController.validateTitle();
    });
    amountController.addListener(() {
      currentSavingController.amount = int.parse(
        amountController.text.isEmpty ? '0' : amountController.text,
      );
      currentSavingController.validateAmount();
    });
    super.initState();
  }

  @override
  void dispose() {
    currentSavingController.dispose();
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Update Goal',
        actions: [
          TextButton(
            onPressed: updateSavingGoal,
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
                controller: titleController,
                label: 'Title',
                maxLength: 100,
                errorText: currentSavingController.titleError,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => CustomTextField(
                controller: amountController,
                label: 'Amount',
                keyboardType: TextInputType.number,
                errorText: currentSavingController.amountError,
              ),
            ),
            const SizedBox(height: 50),
            Obx(
              () => DueDateField(
                date: currentSavingController.dueDate,
                onSelectDate: _showDatePicker,
              ),
            ),
            const SizedBox(height: 20),
            IconSelectionField(
              currentSavingController: currentSavingController,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateSavingGoal() async {
    final response = await currentSavingController.updateSaving(
      widget.saving.id,
    );
    if (response.error == null) {
      Get.back();
      Get.off(
        () => SavingsDetailScreen(saving: response.data!),
        preventDuplicates: false,
      );
      Get.snackbar(
        'Savings',
        'Successfully updated saving goal!',
        snackPosition: SnackPosition.BOTTOM,
      );
      savingsController.fetchSavings();
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
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      currentSavingController.dueDate = date;
    }
  }
}
