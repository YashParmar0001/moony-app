import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';

class DueDateField extends StatelessWidget {
  const DueDateField({
    super.key,
    required this.date,
    required this.onSelectDate,
  });

  final DateTime? date;
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
          const SizedBox(width: 5),
          Text(
            'Due Date: ${date != null ? DateFormat('dd/MM/y').format(date!) : ''}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: (date == null) ? AppColors.graniteGrey : Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
