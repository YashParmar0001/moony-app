import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moony_app/controller/chart_controller.dart';
import 'package:moony_app/model/chart_item.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../theme/colors.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({super.key});

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  final colorPalette = const <Color>[
    AppColors.newYorkPink,
    AppColors.metallicRed,
    AppColors.pewterBlue,
    AppColors.charm,
    AppColors.middleGreen,
  ];
  late final ChartController chartController;

  @override
  void initState() {
    chartController = Get.find<ChartController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset.zero,
          ),
        ],
        color: AppColors.ghostWhite,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: chartController.setPreviousMonth,
                  icon: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: AppColors.midSlateBlue,
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: _showMonthPicker,
                    child: Text(
                      DateFormat('MMMM y').format(chartController.currentTime),
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.midSlateBlue,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: chartController.setNextMonth,
                  icon: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: AppColors.midSlateBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Obx(
            () {
              final chartItems = chartController.getCombinedChartItems();
              return Row(
                children: [
                  _buildChart(chartItems),
                  const SizedBox(width: 10),
                  _buildChartLegends(chartItems),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _showMonthPicker() async {
    showMonthPicker(
      context,
      onSelected: (month, year) {
        chartController.setMonthYear(month, year);
      },
      initialSelectedMonth: chartController.currentTime.month,
      initialSelectedYear: DateTime.now().year,
      highlightColor: AppColors.spiroDiscoBall,
    );
  }

  Widget _buildChart(List<ChartItem> chartItems) {
    if (chartItems.isEmpty) {
      return SizedBox(
        width: 200,
        height: 200,
        child: SfCircularChart(
          palette: const [AppColors.graniteGrey],
          annotations: [
            CircularChartAnnotation(
              widget: GestureDetector(
                onTap: chartController.changeMode,
                child: Text(
                  '${(chartController.showExpense ? 'Expenses' : 'Income')}\n'
                  '${chartController.totalExpense}',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          series: <CircularSeries<int, String>>[
            DoughnutSeries<int, String>(
              dataSource: const [10],
              xValueMapper: (data, _) => 'No Items',
              yValueMapper: (data, _) => data,
              name: 'Expenses',
              innerRadius: '80%',
              radius: '100%',
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 200,
        height: 200,
        child: SfCircularChart(
          palette: colorPalette,
          annotations: [
            CircularChartAnnotation(
              widget: GestureDetector(
                onTap: () {
                  dev.log('Change mode', name: 'Chart');
                  chartController.changeMode();
                },
                child: Text(
                  '${(chartController.showExpense ? 'Expenses' : 'Income')}\n'
                  '${chartController.totalExpense}',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CircularSeries<ChartItem, String>>[
            DoughnutSeries<ChartItem, String>(
              dataSource: chartItems,
              xValueMapper: (data, _) => data.category.name,
              yValueMapper: (data, _) => data.amount,
              name: 'Expenses',
              innerRadius: '80%',
              radius: '100%',
            ),
          ],
        ),
      );
    }
  }

  Widget _buildChartLegends(List<ChartItem> chartItems) {
    return chartItems.isEmpty
        ? _buildLegend(
            AppColors.midSlateBlue,
            'No Item',
          )
        : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              itemCount: chartItems.length,
              itemBuilder: (context, index) {
                return _buildLegend(
                  colorPalette[index],
                  chartItems[index].category.name,
                );
              },
            ),
          );
  }

  Widget _buildLegend(Color color, String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  width: 2,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            categoryName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
