import 'package:flutter/material.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/utils/formatting_utils.dart';

import '../../../theme/colors.dart';

class IconCategoryCard extends StatelessWidget {
  const IconCategoryCard({
    super.key,
    required this.category,
    required this.icons,
    required this.onIconSelected,
  });

  final String category;
  final List<CategoryIcon> icons;
  final Function(CategoryIcon icon) onIconSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      color: AppColors.ghostWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                FormattingUtils.getCapitalString(category),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: 'Nimbus-Medium',
                      color: AppColors.charcoal,
                    ),
              ),
            ),
            Wrap(
              // crossAxisAlignment: WrapCrossAlignment.start,
              // alignment: WrapAlignment.start,
              children: List.generate(
                icons.length,
                (index) => GestureDetector(
                  onTap: () {
                    onIconSelected(icons[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Image.asset(
                      icons[index].iconPath,
                      width: 45,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
