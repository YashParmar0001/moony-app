import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moony_app/controller/current_saving_history_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/ui/savings/screens/history_detail_screen.dart';
import 'package:moony_app/ui/savings/screens/save_history_screen.dart';
import 'package:moony_app/model/saving_history.dart' as sh;
import 'package:moony_app/ui/savings/widgets/no_history.dart';

import '../../../theme/colors.dart';

class SavingHistory extends StatefulWidget {
  const SavingHistory({super.key, required this.saving});

  final Saving saving;

  @override
  State<SavingHistory> createState() => _SavingHistoryState();
}

class _SavingHistoryState extends State<SavingHistory> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    final history = widget.saving.history;
    return Scaffold(
      body: (history.isEmpty)
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 50,
                ),
                child: NoHistory(),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) => _HistoryCard(
                history: history[index],
              ),
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showOptions)
            FloatingActionButton(
              heroTag: 'money_in',
              onPressed: () => Get.to(
                () => SaveHistoryScreen(
                  currentSavingHistoryController:
                      CurrentSavingHistoryController(),
                  moneyIn: true,
                  saving: widget.saving,
                ),
              ),
              backgroundColor: AppColors.spiroDiscoBall,
              child: const Icon(Icons.add, color: AppColors.white),
            ),
          const SizedBox(height: 10),
          if (showOptions)
            FloatingActionButton(
              heroTag: 'money_out',
              onPressed: () => Get.to(
                () => SaveHistoryScreen(
                  currentSavingHistoryController:
                      CurrentSavingHistoryController(),
                  moneyIn: false,
                  saving: widget.saving,
                ),
              ),
              backgroundColor: AppColors.spiroDiscoBall,
              child: const Icon(Icons.remove, color: AppColors.white),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'show_options',
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
  const _HistoryCard({required this.history});

  final sh.SavingHistory history;

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return GestureDetector(
      onTap: () => Get.to(() => HistoryDetailsScreen(history: history)),
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
                    history.moneyIn
                        ? Assets.iconsMoneyIn
                        : Assets.iconsMoneyOut,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.moneyIn ? 'Money in' : 'Money out',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      DateFormat('dd/MM/y').format(history.date),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.midSlateBlue,
                              ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '${history.amount}${settingsController.currency}',
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
