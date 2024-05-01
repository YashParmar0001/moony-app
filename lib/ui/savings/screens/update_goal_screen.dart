import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/core/ui/widgets/custom_text_field.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/select_icon_screen.dart';

class UpdateGoalScreen extends StatefulWidget {
  const UpdateGoalScreen({super.key});

  @override
  State<UpdateGoalScreen> createState() => _UpdateGoalScreenState();
}

class _UpdateGoalScreenState extends State<UpdateGoalScreen> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;

  @override
  void initState() {
    titleController = TextEditingController(text: 'For laptop');
    amountController = TextEditingController(text: '100');
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
        title: 'Update Goal',
        actions: [
          TextButton(
            onPressed: () {},
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
            CustomTextField(
              controller: titleController,
              label: 'Title',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: amountController,
              label: 'Amount',
              maxLength: 100,
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.iconsCalendar,
                  width: 30,
                  color: AppColors.spiroDiscoBall,
                ),
                const SizedBox(width: 5),
                Text(
                  'Due Date:',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.graniteGrey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Get.to(
                () => SelectIconScreen(
                  currentSavingController: CurrentSavingController(),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.question_mark_rounded,
                    color: AppColors.spiroDiscoBall,
                    size: 30,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Select Icon',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.graniteGrey,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
