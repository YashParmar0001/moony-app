import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moony_app/core/ui/widgets/custom_text_field.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

class MoneyOutScreen extends StatefulWidget {
  const MoneyOutScreen({super.key});

  @override
  State<MoneyOutScreen> createState() => _MoneyOutScreenState();
}

class _MoneyOutScreenState extends State<MoneyOutScreen> {
  late final TextEditingController amountController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Get Money Out',
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
              controller: amountController,
              label: 'Amount',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
              maxLength: 100,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.iconsCalendar,
                  width: 30,
                  color: AppColors.spiroDiscoBall,
                ),
                const SizedBox(width: 5),
                Text(
                  'Date:',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.graniteGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
