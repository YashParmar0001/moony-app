import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/model/budget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../theme/colors.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return InkWell(
      onTap: () {
        // Get.to(() => TransactionDetailsScreen(transaction: transaction));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
          color: AppColors.ghostWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Image.asset(
                budget.category.icon.iconPath,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.category.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Limit: ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      budget.limit.toString(),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Spent: ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      budget.spent.toString(),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      budget.remaining.isNegative ? 'Extra: ' : 'Remaining: ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      budget.remaining.abs().toString(),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                LinearPercentIndicator(
                  percent: budget.percentage / 100,
                  lineHeight: 10,
                  progressColor: AppColors.spiroDiscoBall,
                  animation: true,
                  width: MediaQuery.of(context).size.width - 120,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  barRadius: const Radius.circular(5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
