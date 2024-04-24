import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/ui/home/screens/add_transaction_screen.dart';
import 'package:moony_app/ui/home/widgets/app_bar_action.dart';

import '../../../theme/colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.onSelected});

  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
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
        _buildFilterMenu(),
        AppBarAction(
          icon: Icons.add,
          onPressed: () {
            Get.to(
              () => AddTransactionScreen(
                currentTransactionController: CurrentTransactionController(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);

  Widget _buildFilterMenu() {
    return PopupMenuButton(
      icon: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.ghostWhite,
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
        child: const Icon(Icons.filter_alt_outlined),
      ),
      onSelected: onSelected,
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
