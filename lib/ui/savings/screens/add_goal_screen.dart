import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/core/ui/widgets/custom_text_field.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/widgets/due_date_field.dart';
import 'package:moony_app/ui/savings/widgets/icon_selection_field.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key, required this.currentSavingController});

  final CurrentSavingController currentSavingController;

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  late final TextEditingController titleController, amountController;
  late final CurrentSavingController currentSavingController;
  final savingsController = Get.find<SavingsController>();

  @override
  void initState() {
    currentSavingController = widget.currentSavingController;
    titleController = TextEditingController();
    amountController = TextEditingController();
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
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Add Goal',
        actions: [
          TextButton(
            onPressed: saveSavingGoal,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
      ),
    );
  }

  Future<void> saveSavingGoal() async {
    final response = await currentSavingController.addSaving();
    if (response == null) {
      Get.back();
      Get.snackbar(
        'Savings',
        'Successfully added goal!',
        snackPosition: SnackPosition.BOTTOM,
      );
      savingsController.fetchSavings();
    } else {
      Get.snackbar(
        'Savings',
        response,
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
