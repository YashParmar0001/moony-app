import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/ui/savings/screens/history_detail_screen.dart';
import 'package:moony_app/ui/savings/screens/money_in_screen.dart';
import 'package:moony_app/ui/savings/screens/money_out_screen.dart';

import '../../../theme/colors.dart';

class SavingHistory extends StatefulWidget {
  const SavingHistory({super.key});

  @override
  State<SavingHistory> createState() => _SavingHistoryState();
}

class _SavingHistoryState extends State<SavingHistory> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => const _HistoryCard(),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showOptions)
            FloatingActionButton(
              onPressed: () => Get.to(() => const MoneyInScreen()),
              backgroundColor: AppColors.spiroDiscoBall,
              child: const Icon(Icons.add, color: AppColors.white),
            ),
          const SizedBox(height: 10),
          if (showOptions)
            FloatingActionButton(
              onPressed: () => Get.to(() => const MoneyOutScreen()),
              backgroundColor: AppColors.spiroDiscoBall,
              child: const Icon(Icons.remove, color: AppColors.white),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showOptions = !showOptions;
              });
            },
            backgroundColor: AppColors.ghostWhite,
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AppColors.spiroDiscoBall,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const HistoryDetailsScreen()),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset.zero,
            ),
          ],
          color: AppColors.ghostWhite,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 35,
                  child: Image.asset(
                    Assets.iconsMoneyIn,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Money in',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '24/08/2004',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.midSlateBlue,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '2000',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
