import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.ghostWhite,
    this.iconColor = AppColors.charcoal,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: color,
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
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
