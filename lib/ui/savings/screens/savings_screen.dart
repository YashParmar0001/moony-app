import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/savings/screens/add_goal_screen.dart';
import 'package:moony_app/ui/savings/widgets/goal_card.dart';
import 'package:moony_app/ui/savings/widgets/savings_stats_card.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final savingsController = Get.find<SavingsController>();

  @override
  void initState() {
    savingsController.fetchSavings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SavingsStatsCard(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saving Goals',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontFamily: 'Nimbus-Medium',
                          color: AppColors.charcoal,
                        ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      Get.to(
                        () => AddGoalScreen(
                          currentSavingController: CurrentSavingController(),
                        ),
                      );
                    },
                    backgroundColor: AppColors.spiroDiscoBall,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Obx(() {
              final list = savingsController.savings;
              if (list.isEmpty) {
                return const Text('Empty');
              } else {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: list.length,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GoalCard(
                      saving: list[index],
                    ),
                  ),
                );
              }
            }),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
