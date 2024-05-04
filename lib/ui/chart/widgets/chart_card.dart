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
              if (chartItems.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Center(
                    child: Text(
                      'No data to display',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'
                      ),
                    ),
                  ),
                );
              } else {
                return Row(
                  children: [
                    _buildChart(context, chartItems),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        itemCount: chartItems.length,
                        itemBuilder: (context, index) {
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
                                        color: colorPalette[index],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  chartItems[index].category.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
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

  Widget _buildChart(BuildContext context, List<ChartItem> chartItems) {
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
