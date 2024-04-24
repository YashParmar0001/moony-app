import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';

class DateField extends StatelessWidget {
  const DateField({super.key, required this.onSelectDate, required this.date});

  final DateTime date;
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
            DateFormat('dd/MM/y').format(date),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
