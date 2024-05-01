import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/update_goal_screen.dart';
import 'package:moony_app/ui/savings/widgets/saving_goal_view.dart';
import 'package:moony_app/ui/savings/widgets/saving_history.dart';

class SavingsDetailScreen extends StatelessWidget {
  const SavingsDetailScreen({super.key, required this.saving});

  final Saving saving;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: saving.title,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => Get.to(() => const UpdateGoalScreen()),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
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
                  SavingGoalView(saving: saving),
                  SavingHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
