import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/budget_controller.dart';
import 'package:moony_app/controller/current_budget_controller.dart';
import 'package:moony_app/model/budget.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/budget/screens/add_budget_screen.dart';
import 'package:moony_app/ui/budget/widgets/budget_app_bar.dart';
import 'package:moony_app/ui/budget/widgets/budget_card.dart';
import 'package:moony_app/ui/budget/widgets/monthly_budget_card.dart';
import 'package:moony_app/ui/budget/widgets/no_budget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late final BudgetController budgetController;

  @override
  void initState() {
    budgetController = Get.find<BudgetController>();
    // budgetController.fetchBudgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    budgetController.fetchBudgets();
    return Scaffold(
      appBar: const BudgetAppBar(),
      body: Column(
        children: [
          const MonthlyBudgetCard(),
          const SizedBox(height: 10),
          Obx(
            () {
              List<Budget> list = budgetController.budgets;
              return list.isEmpty
                  ? const NoBudget()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return BudgetCard(budget: list[index]);
                        },
                      ),
                    );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => AddBudgetScreen(
            currentBudgetController: Get.put(
              CurrentBudgetController(),
            ),
          ),
        ),
        backgroundColor: AppColors.spiroDiscoBall,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
