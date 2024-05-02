import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/savings_controller.dart';

import '../../../theme/colors.dart';

class SavingsStatsCard extends StatelessWidget {
  const SavingsStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final savingsController = Get.find<SavingsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(4, 4),
            ),
          ],
          color: AppColors.midSlateBlue,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Column(
          children: [
            Obx(
              () => _buildStat(
                context,
                'Goals',
                savingsController.goal,
              ),
            ),
            Obx(
              () => _buildStat(
                context,
                'In Progress',
                savingsController.inProgress,
              ),
            ),
            Obx(
              () => _buildStat(
                context,
                'Completed',
                savingsController.completed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, int data) {
    final style = Theme.of(context).textTheme.displayMedium?.copyWith(
          color: AppColors.white,
          fontFamily: 'Nimbus-Medium',
        );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style,
          ),
          Text(
            data.toString(),
            style: style,
          ),
        ],
      ),
    );
  }
}
