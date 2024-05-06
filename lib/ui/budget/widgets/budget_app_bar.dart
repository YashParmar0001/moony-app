import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class BudgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BudgetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      clipBehavior: Clip.none,
      backgroundColor: AppColors.aliceBlue,
      title: Text(
        'Budget',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontFamily: 'Nimbus-Medium',
              color: AppColors.midSlateBlue,
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
