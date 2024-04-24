import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';

class NotesField extends StatelessWidget {
  const NotesField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.iconsNote,
          width: 30,
          color: AppColors.spiroDiscoBall,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Write Note',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
            ),
            maxLines: 10,
            minLines: 1,
            maxLength: 254,
          ),
        ),
      ],
    );
  }
}
