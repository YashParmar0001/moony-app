import 'dart:developer' as dev;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/controller/transactions_filter_controller.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/screens/add_transaction_screen.dart';
import 'package:moony_app/ui/home/widgets/home_app_bar.dart';
import 'package:moony_app/ui/home/widgets/monthly_status_card.dart';
import 'package:moony_app/ui/home/widgets/no_transactions.dart';
import 'package:moony_app/ui/home/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TransactionController transactionController;
  late final TransactionsFilterController transactionsFilterController;

  @override
  void initState() {
    transactionController = Get.find<TransactionController>();
    transactionController.fetchTransactions();
    transactionsFilterController = Get.find<TransactionsFilterController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          const MonthlyStatusCard(),
          const SizedBox(height: 10),
          Obx(() {
            if (transactionsFilterController.categoryFilterApplied) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Money: ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    transactionsFilterController.totalCategoryExpense
                        .toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
          Obx(() {
            List<Transaction> list = transactionController.transactions;
            if (list.isEmpty) {
              return const Center(
                child: NoTransactions(),
              );
            } else {
              final transactionsFilterController =
                  Get.find<TransactionsFilterController>();
              if (transactionsFilterController.filterApplied) {
                list = transactionsFilterController.filteredList;
              }
              return list.isEmpty
                  ? const NoTransactions()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return TransactionCard(transaction: list[index]);
                        },
                      ),
                    );
            }
          }),
        ],
      ),
      floatingActionButton: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (transactionsFilterController.categoryFilterApplied)
              FloatingActionButton(
                heroTag: 'remove_filter',
                onPressed: () {
                  dev.log('Removing filters', name: 'Transaction');
                  transactionsFilterController.removeFilters();
                },
                backgroundColor: AppColors.begonia,
                child: const Icon(
                  Icons.filter_list_off_rounded,
                  color: AppColors.white,
                ),
              ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () => Get.to(
                () => AddTransactionScreen(
                  currentTransactionController: Get.put(
                    CurrentTransactionController(),
                  ),
                ),
              ),
              backgroundColor: AppColors.spiroDiscoBall,
              child: const Icon(Icons.add, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
