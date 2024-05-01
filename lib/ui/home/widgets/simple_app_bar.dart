import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({
    super.key,
    required this.title,
    required this.actions,
  });

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.ghostWhite,
      shadowColor: Colors.black,
      elevation: 5,
      iconTheme: const IconThemeData(
        color: AppColors.midSlateBlue,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.midSlateBlue,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
