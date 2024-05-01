import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/utils/formatting_utils.dart';

import '../../../theme/colors.dart';
import '../screens/select_icon_screen.dart';

class IconSelectionField extends StatelessWidget {
  const IconSelectionField({super.key, required this.currentSavingController});

  final CurrentSavingController currentSavingController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => SelectIconScreen(
          currentSavingController: currentSavingController,
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            currentSavingController.icon == null
                ? const Icon(
                    Icons.question_mark_rounded,
                    color: AppColors.spiroDiscoBall,
                    size: 30,
                  )
                : Image.asset(
                    currentSavingController.icon!.iconPath,
                    width: 40,
                  ),
            const SizedBox(width: 5),
            Text(
              currentSavingController.icon == null
                  ? 'Select Icon'
                  : FormattingUtils.getCapitalString(
                      currentSavingController.icon!.iconCategory,
                    ),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: currentSavingController.icon == null
                        ? AppColors.graniteGrey
                        : Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
