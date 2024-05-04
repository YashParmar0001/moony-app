import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/chart_controller.dart';
import 'package:moony_app/controller/settings_controller.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<ChartController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(
      () => Expanded(
        child: ListView.builder(
          itemCount: chartController.chartItems.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
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
                    offset: Offset.zero,
                  ),
                ],
                color: AppColors.ghostWhite,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        chartController
                            .chartItems[index].category.icon.iconPath,
                        width: 45,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        chartController.chartItems[index].category.name,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.charcoal,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                  Text(
                    '${chartController.chartItems[index].amount}'
                    '${settingsController.currency}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.charcoal,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
