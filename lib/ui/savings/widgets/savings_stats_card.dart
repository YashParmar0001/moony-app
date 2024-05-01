import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class SavingsStatsCard extends StatelessWidget {
  const SavingsStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Column(
          children: [
            _buildStat(context, 'Goals', 0),
            _buildStat(context, 'In Progress', 0),
            _buildStat(context, 'Completed', 0),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, int data) {
    final style = Theme.of(context).textTheme.displayMedium?.copyWith(
      color: AppColors.white,
      fontFamily: 'Nimbus-Medium',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style,
          ),
          Text(
            data.toString(),
            style: style,
          ),
        ],
      ),
    );
  }
}
