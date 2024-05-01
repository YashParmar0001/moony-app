import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_saving_controller.dart';
import 'package:moony_app/controller/icons_controller.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/widgets/icon_category_card.dart';
import 'package:moony_app/utils/formatting_utils.dart';

class SelectIconScreen extends StatefulWidget {
  const SelectIconScreen({super.key, required this.currentSavingController});

  final CurrentSavingController currentSavingController;

  @override
  State<SelectIconScreen> createState() => _SelectIconScreenState();
}

class _SelectIconScreenState extends State<SelectIconScreen> {
  late final IconsController iconsController;
  CategoryIcon? selectedIcon;

  @override
  void initState() {
    iconsController = Get.find<IconsController>()..fetchIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Select icon',
        actions: [
          TextButton(
            onPressed: () {
              if (selectedIcon != null) {
                widget.currentSavingController.icon = selectedIcon;
                Get.back();
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                selectedIcon == null
                    ? const Icon(
                  Icons.question_mark_rounded,
                  color: AppColors.spiroDiscoBall,
                  size: 30,
                )
                    : Image.asset(
                  selectedIcon!.iconPath,
                  width: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  selectedIcon == null
                      ? 'Select Icon'
                      : FormattingUtils.getCapitalString(
                    selectedIcon!.iconCategory,
                  ),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final icons = iconsController.icons;
            if (icons.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final iconsMap = iconsController.getIconsMap().entries.toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: iconsMap.length,
                  itemBuilder: (context, index) {
                    return IconCategoryCard(
                      onIconSelected: (icon) {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      category: iconsMap[index].key,
                      icons: iconsMap[index].value,
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
