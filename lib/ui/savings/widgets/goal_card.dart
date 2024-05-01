import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/savings/screens/savings_detail_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key, required this.saving});

  final Saving saving;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => SavingsDetailScreen(saving: saving)),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: ShapeDecoration(
          color: AppColors.ghostWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Image.asset(
                          saving.icon.iconPath,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Text(
                          saving.title,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontFamily: 'Nimbus-Medium',
                                color: AppColors.charcoal,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    saving.desiredAmount.toString(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontFamily: 'Nimbus-Medium',
                          color: AppColors.charcoal,
                        ),
                  ),
                  const SizedBox(height: 20),
                  LinearPercentIndicator(
                    percent: saving.percentage / 100,
                    lineHeight: 20,
                    progressColor: AppColors.spiroDiscoBall,
                    animation: true,
                    center: Text(
                      '${saving.percentage}%',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    width: MediaQuery.of(context).size.width - 150,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 120,
              height: 3,
              color: AppColors.spiroDiscoBall.withOpacity(0.25),
            ),
          ],
        ),
      ),
    );
  }
}
