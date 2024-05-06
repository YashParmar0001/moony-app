import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:moony_app/ui/budget/screens/budget_screen.dart';
import 'package:moony_app/ui/chart/screens/chart_screen.dart';
import 'package:moony_app/ui/home/screens/home_screen.dart';
import 'package:moony_app/ui/savings/screens/savings_screen.dart';
import 'package:moony_app/ui/settings/screens/settings_screen.dart';

import '../../../core/ui/widgets/custom_bottom_bar.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController animationController;

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging) {
          setState(() {
            animationController.forward(from: 0);
          });
        }
      });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tabs = [
      HomeScreen(),
      SavingsScreen(),
      BudgetScreen(),
      ChartScreen(),
      SettingsScreen(),
    ];

    return PopScope(
      canPop: tabController.index == 0,
      onPopInvoked: (_) {
        if (tabController.index > 0) {
          tabController.animateTo(0);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: FadeTransition(
          opacity: animationController,
          child: tabs[tabController.index],
        ),
        bottomNavigationBar: CustomBottomNavBar(tabController: tabController),
      ),
    );
  }
}
