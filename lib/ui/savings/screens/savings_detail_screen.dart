import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/update_goal_screen.dart';
import 'package:moony_app/ui/savings/widgets/saving_goal_view.dart';
import 'package:moony_app/ui/savings/widgets/saving_history.dart';

import '../../../core/ui/widgets/alert_dialog.dart';

class SavingsDetailScreen extends StatefulWidget {
  const SavingsDetailScreen({super.key, required this.saving, this.initialTabIndex = 0,});

  final Saving saving;
  final int initialTabIndex;

  @override
  State<SavingsDetailScreen> createState() => _SavingsDetailScreenState();
}

class _SavingsDetailScreenState extends State<SavingsDetailScreen> {
  late final SavingsController savingsController;

  @override
  void initState() {
    savingsController = Get.find<SavingsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: widget.saving.title,
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => Get.to(
              () => UpdateGoalScreen(
                saving: widget.saving,
                currentSavingController: CurrentSavingController(),
              ),
            ),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: widget.initialTabIndex,
        child: Column(
          children: [
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text('GOAL'),
                ),
                Tab(
                  child: Text('HISTORY'),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SavingGoalView(saving: widget.saving),
                  SavingHistory(saving: widget.saving),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteSaving() async {
    final response = await savingsController.deleteSaving(widget.saving.id);
    Get.closeAllSnackbars();
    if (response) {
      Get.back();
      Get.snackbar(
        'Savings',
        'Saving goal deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      savingsController.fetchSavings();
    } else {
      Get.snackbar(
        'Savings',
        'Something went wrong. Please try again!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          onPressOk: () {
            Get.back();
            _deleteSaving();
          },
          onPressCancel: () {
            Get.back();
          },
          title: 'Warning',
          content: 'Do you really want to delete this saving goal?',
        );
      },
    );
  }
}
