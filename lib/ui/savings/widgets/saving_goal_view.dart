import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/theme/colors.dart';

class SavingGoalView extends StatelessWidget {
  const SavingGoalView({super.key, required this.saving});

  final Saving saving;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.iconsCalendar,
                    color: AppColors.spiroDiscoBall,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('dd/MM/y').format(saving.date),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontFamily: 'Nimbus-Medium',
                        ),
                  ),
                ],
              ),
              Image.asset(
                saving.icon.iconPath,
                width: 40,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: LiquidCircularProgressIndicator(
              value: saving.percentage / 100,
              valueColor: AlwaysStoppedAnimation(
                AppColors.spiroDiscoBall.withOpacity(0.3),
              ),
              backgroundColor: Colors.white,
              direction: Axis.vertical,
              center: Text(
                '${saving.percentage}%',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontFamily: 'Nimbus-Medium',
                      color: AppColors.spiroDiscoBall,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Data(label: 'Saved', data: saving.savedMoney.toString()),
              _Data(label: 'Goal', data: saving.desiredAmount.toString()),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            (saving.remainingMoney.isNegative) ? 'Redundancy' : 'Remaining',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontFamily: 'Nimbus-Medium',
                  color: AppColors.midSlateBlue,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Data(
                label: 'Money',
                data: saving.remainingMoney.abs().toString(),
              ),
              _Data(label: 'Time', data: '${saving.remainingDays} day'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontFamily: 'Nimbus-Medium',
                color: AppColors.midSlateBlue,
              ),
        ),
        Text(
          data,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Nimbus-Medium',
                color: AppColors.charcoal,
              ),
        ),
      ],
    );
  }
}
