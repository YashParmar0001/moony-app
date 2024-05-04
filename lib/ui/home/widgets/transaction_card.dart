import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/ui/home/screens/transaction_detail_screen.dart';

import '../../../theme/colors.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return InkWell(
      onTap: () {
        Get.to(() => TransactionDetailsScreen(transaction: transaction));
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
            borderRadius: BorderRadius.circular(8),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 35,
                  child: Image.asset(
                    transaction.category.icon.iconPath,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category.name,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      DateFormat('dd/MM/y').format(transaction.date),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.midSlateBlue,
                              ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '${transaction.category.isIncome ? '' : '-'}${transaction.money}'
              '${settingsController.currency}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
