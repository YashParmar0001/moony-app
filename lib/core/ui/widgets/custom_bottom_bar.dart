import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home_outlined,
      Icons.savings_outlined,
      Icons.bar_chart_rounded,
      Icons.pie_chart_outline,
      Icons.settings_outlined,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.ghostWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: widget.tabController,
        indicator: DotIndicator(
          color: AppColors.spiroDiscoBall,
          radius: 2,
          distanceFromCenter: -20,
        ),
        onTap: (value) {
          setState(() {});
        },
        splashFactory: NoSplash.splashFactory,
        tabs: List.generate(
          5,
          (index) {
            final selected = widget.tabController.index == index;
            return Tab(
              icon: Padding(
                padding: EdgeInsets.only(
                  bottom: selected ? 8 : 0,
                ),
                child: Icon(
                  icons[index],
                  color: selected ? AppColors.midSlateBlue : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
