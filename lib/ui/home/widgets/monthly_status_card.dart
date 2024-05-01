import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/theme/colors.dart';

class MonthlyStatusCard extends StatefulWidget {
  const MonthlyStatusCard({super.key});

  @override
  State<MonthlyStatusCard> createState() => _MonthlyStatusCardState();
}

class _MonthlyStatusCardState extends State<MonthlyStatusCard> {
  final transactionController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: transactionController.setPreviousMonth,
                    icon: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: AppColors.white,
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: _showMonthPicker,
                      child: Text(
                        DateFormat('MMMM y').format(
                          transactionController.currentTime,
                        ),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: transactionController.setNextMonth,
                    icon: const Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Obx(
              () => _buildData(
                context,
                'Income:',
                transactionController.income.toString(),
                true,
              ),
            ),
            const SizedBox(height: 5),
            Obx(
              () => _buildData(
                context,
                'Expenses:',
                transactionController.expenses.toString(),
                true,
              ),
            ),
            const SizedBox(height: 5),
            Obx(
              () => _buildData(
                context,
                'Your Balance',
                transactionController.balance.toString(),
                false,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _showMonthPicker() async {
    // final date = await showMonthYearPicker(
    //   context: context,
    //   firstDate: DateTime(1970),
    //   lastDate: DateTime.now(),
    //   initialDate: DateTime.now(),
    // );
    //
    // if (date != null) {
    //   transactionController.setMonthYear(date);
    // }
    showMonthPicker(
      context,
      onSelected: (month, year) {
        transactionController.setMonthYear(month, year);
      },
      initialSelectedMonth: transactionController.currentTime.month,
      initialSelectedYear: DateTime.now().year,
      highlightColor: AppColors.spiroDiscoBall,
    );
  }

  Widget _buildData(
    BuildContext context,
    String label,
    String value,
    bool isBold,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: isBold ? FontWeight.w700 : null,
                ),
          ),
        ],
      ),
    );
  }
}
