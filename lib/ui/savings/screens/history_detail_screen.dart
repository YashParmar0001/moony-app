import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moony_app/controller/current_saving_history_controller.dart';
import 'package:moony_app/controller/savings_controller.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/model/saving_history.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/savings_detail_screen.dart';
import 'package:moony_app/ui/savings/screens/update_history_screen.dart';

import '../../../core/ui/widgets/alert_dialog.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({super.key, required this.history});

  final SavingHistory history;

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'History Details',
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadows: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    spreadRadius: 3,
                    offset: Offset.zero,
                  ),
                ],
                color: AppColors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.history.moneyIn ? '' : '-'}${widget.history.amount}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontFamily: 'Nimbus-Medium',
                        ),
                  ),
                  const SizedBox(height: 20),
                  _buildIncomeStatus(context),
                  const SizedBox(height: 20),
                  _buildNotes(context),
                  const SizedBox(height: 20),
                  _buildDate(context),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              right: 50,
              child: IconButton.filled(
                onPressed: () => Get.to(
                  () => UpdateHistoryScreen(
                    currentSavingHistoryController:
                        CurrentSavingHistoryController(),
                    history: widget.history,
                  ),
                ),
                icon: const Icon(Icons.edit),
                iconSize: 30,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    AppColors.spiroDiscoBall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(
          Assets.iconsCalendar,
          width: 30,
          color: AppColors.spiroDiscoBall,
        ),
        const SizedBox(width: 10),
        Text(
          DateFormat('dd/MM/y').format(widget.history.date),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Nimbus-Medium',
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildNotes(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Assets.iconsNote,
          width: 30,
          color: AppColors.spiroDiscoBall,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width - 150,
          child: Text(
            widget.history.description,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontFamily: 'Nimbus-Medium',
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeStatus(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 30,
          child: Image.asset(
            widget.history.moneyIn ? Assets.iconsMoneyIn : Assets.iconsMoneyOut,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.history.moneyIn ? 'Money in' : 'Money out',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Nimbus-Medium',
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Future<void> _deleteSavingHistory() async {
    final savingsController = Get.find<SavingsController>();
    final savings = savingsController.savings;
    final response = await savingsController.deleteSavingHistory(
      widget.history.id,
      widget.history.transactionId,
      savings.where((e) => e.id == widget.history.savingId).first,
    );
    Get.closeAllSnackbars();
    if (response.error == null) {
      Get.back();
      Get.off(
        () => SavingsDetailScreen(saving: response.data!, initialTabIndex: 1),
        preventDuplicates: false,
      );
      Get.snackbar(
        'Savings',
        'Successfully deleted saving history!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<SavingsController>().fetchSavings();
    } else {
      Get.snackbar(
        'Savings',
        response.error!,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          onPressOk: () {
            Get.back();
            _deleteSavingHistory();
          },
          onPressCancel: () {
            Get.back();
          },
          title: 'Warning',
          content: 'Do you really want to delete this?',
        );
      },
    );
  }
}
