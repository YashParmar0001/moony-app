import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/home/widgets/simple_app_bar.dart';
import 'package:moony_app/ui/savings/screens/update_history_screen.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({super.key});

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
                    '-20',
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
                onPressed: () => Get.to(() => const UpdateHistoryScreen()),
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
          '24/08/2004',
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
            'Get the money out from laptop savings',
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
          child: Image.asset(Assets.iconsMoneyIn),
        ),
        const SizedBox(width: 10),
        Text(
          'Money in',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Nimbus-Medium',
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Future<void> _deleteTransaction() async {
    // final response =
    // await transactionsController.deleteTransaction(widget.transaction.id);
    // if (response) {
    //   Get.back();
    //   Get.snackbar(
    //     'Transaction',
    //     'Transaction deleted successfully!',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   transactionsController.fetchTransactions();
    // } else {
    //   Get.snackbar(
    //     'Transaction',
    //     'Something went wrong. Please try again!',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
  }

  void _showDeleteDialog(BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return CustomAlertDialog(
    //       onPressOk: () {
    //         Get.back();
    //         _deleteTransaction();
    //       },
    //       onPressCancel: () {
    //         Get.back();
    //       },
    //       title: 'Warning',
    //       content: 'Do you really want to delete this transaction?',
    //     );
    //   },
    // );
  }
}
