import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/controller/transaction_controller.dart';
import 'package:moony_app/core/ui/widgets/alert_dialog.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/model/transaction.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/screens/edit_transaction_screen.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late final TransactionController transactionsController;

  @override
  void initState() {
    transactionsController = Get.find<TransactionController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Transaction Details',
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Stack(
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
                  spreadRadius: 2,
                  offset: Offset(4, 4),
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
                  '${widget.transaction.category.isIncome ? '' : '-'}'
                  '${widget.transaction.money}'
                  '${settingsController.currency}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontFamily: 'Nimbus-Medium',
                      ),
                ),
                const SizedBox(height: 20),
                _buildCategory(context),
                const SizedBox(height: 20),
                _buildNotes(context),
                const SizedBox(height: 20),
                _buildDate(context),
              ],
            ),
          ),
          if (widget.transaction.category.name != 'Saving')
            Positioned(
              bottom: 5,
              right: 50,
              child: IconButton.filled(
                onPressed: () {
                  Get.to(
                    () => EditTransactionScreen(
                      currentTransactionController:
                          CurrentTransactionController(),
                      transaction: widget.transaction,
                    ),
                  );
                },
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
          DateFormat('dd/MM/y').format(widget.transaction.date),
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
        Text(
          widget.transaction.note,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Nimbus-Medium',
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildCategory(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 30,
          child: Image.asset(widget.transaction.category.icon.iconPath),
        ),
        const SizedBox(width: 10),
        Text(
          widget.transaction.category.name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Nimbus-Medium',
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Future<void> _deleteTransaction() async {
    final response = await transactionsController.deleteTransaction(
      widget.transaction.id,
      widget.transaction.historyId,
    );
    Get.closeAllSnackbars();
    if (response) {
      Get.back();
      Get.snackbar(
        'Transaction',
        'Transaction deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      transactionsController.fetchTransactions();
    } else {
      Get.snackbar(
        'Transaction',
        'Something went wrong. Please try again!',
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
            _deleteTransaction();
          },
          onPressCancel: () {
            Get.back();
          },
          title: 'Warning',
          content: 'Do you really want to delete this transaction?',
        );
      },
    );
  }
}
