import 'package:flutter/material.dart';
import 'package:moony_app/model/category.dart';
import 'package:moony_app/theme/colors.dart';

class CategorySelectionField extends StatelessWidget {
  const CategorySelectionField({
    super.key,
    required this.category,
    required this.onSelectCategory,
    required this.categoryError,
  });

  final Category? category;
  final VoidCallback onSelectCategory;
  final String? categoryError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectCategory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categoryError != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
              ),
              child: Text(
                categoryError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.begonia,
                    ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 30,
                child: category == null
                    ? const Icon(
                        Icons.question_mark_rounded,
                        color: AppColors.spiroDiscoBall,
                      )
                    : Image.asset(category!.icon.iconPath),
              ),
              const SizedBox(width: 10),
              Text(
                category?.name ?? 'Select Category',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: category == null ? Colors.grey : null,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
