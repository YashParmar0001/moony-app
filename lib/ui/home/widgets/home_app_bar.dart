import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/transactions_filter_controller.dart';
import 'package:moony_app/ui/home/screens/add_transaction_screen.dart';
import 'package:moony_app/ui/home/screens/select_category_screen.dart';
import 'package:moony_app/ui/home/widgets/app_bar_action.dart';

import '../../../theme/colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionsFilterController =
        Get.find<TransactionsFilterController>();

    return AppBar(
      clipBehavior: Clip.none,
      backgroundColor: AppColors.aliceBlue,
      title: Text(
        'Transaction',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontFamily: 'Nimbus-Medium',
              color: AppColors.midSlateBlue,
            ),
      ),
      actions: [
        Obx(() => _buildFilterMenu(transactionsFilterController)),
        Obx(
          () => AppBarAction(
            icon: Icons.category_outlined,
            onPressed: () => Get.to(
              () => SelectCategoryScreen(
                onSelectCategory: (category) {
                  if (category != null) {
                    Get.find<TransactionsFilterController>()
                        .filterCategoryWise(category);
                  }
                },
              ),
            ),
            color: transactionsFilterController.categoryFilterApplied
                ? AppColors.spiroDiscoBall
                : AppColors.ghostWhite,
            iconColor: transactionsFilterController.categoryFilterApplied
                ? AppColors.white
                : AppColors.charcoal,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);

  Widget _buildFilterMenu(TransactionsFilterController filterController) {
    return PopupMenuButton(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: filterController.incomeFilterApplied
              ? AppColors.spiroDiscoBall
              : AppColors.ghostWhite,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.filter_alt_outlined,
          color: filterController.incomeFilterApplied
              ? AppColors.white
              : AppColors.charcoal,
        ),
      ),
      onSelected: (value) {
        if (value == 'all') {
          filterController.removeFilters();
        } else {
          filterController.filterIncomeStatus(value == 'income' ? true : false);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            value: 'all',
            child: Text('All'),
          ),
          const PopupMenuItem<String>(
            value: 'income',
            child: Text('Income'),
          ),
          const PopupMenuItem<String>(
            value: 'expenses',
            child: Text('Expenses'),
          ),
        ];
      },
    );
  }
}
