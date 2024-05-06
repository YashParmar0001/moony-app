import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';

class BudgetDateField extends StatelessWidget {
  const BudgetDateField({
    super.key,
    required this.onSelectDate,
    required this.month,
    required this.year,
  });

  final int month, year;
  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectDate,
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.iconsCalendar,
            width: 30,
            color: AppColors.spiroDiscoBall,
          ),
          const SizedBox(width: 10),
          Text(
            DateFormat('MMMM, y').format(DateTime(year, month)),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
