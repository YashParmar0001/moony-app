import 'package:flutter/material.dart';
import 'package:moony_app/theme/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onPressOk,
    required this.onPressCancel,
    this.showOnlyOK = false,
  });

  final String title;
  final String content;
  final VoidCallback onPressOk;
  final VoidCallback onPressCancel;
  final bool showOnlyOK;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      title: Center(
        child: Text(
          title,
        ),
      ),
      backgroundColor: AppColors.ghostWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            if (!showOnlyOK) Expanded(
              child: TextButton(
                onPressed: onPressCancel,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: onPressOk,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.spiroDiscoBall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
