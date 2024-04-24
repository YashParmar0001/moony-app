import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/model/transaction.dart';
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
  var filterOption = 'all';

  @override
  void initState() {
    transactionController = Get.find<TransactionController>();
    transactionController.fetchTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onSelected: (value) {
          setState(() {
            filterOption = value;
          });
        },
      ),
      body: Column(
        children: [
          const MonthlyStatusCard(),
          const SizedBox(height: 10),
          Obx(() {
            List<Transaction> list = transactionController.transactions;
            if (list.isEmpty) {
              return const Center(
                child: NoTransactions(),
              );
            } else {
              if (filterOption == 'income') {
                list = list.where((e) => e.category.isIncome).toList();
              } else if (filterOption == 'expenses') {
                list = list.where((e) => !e.category.isIncome).toList();
              }
              return Expanded(
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
    );
  }
}
