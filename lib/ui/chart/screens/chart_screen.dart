import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/chart_controller.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/ui/chart/widgets/category_list.dart';
import 'package:moony_app/ui/chart/widgets/chart_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../theme/colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    final chartController = Get.find<ChartController>();
    chartController.setMonthYear(DateTime.now().month, DateTime.now().year);
    chartController.fetchItems(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            ChartCard(),
            SizedBox(height: 10),
            CategoryList(),
          ],
        ),
      ),
    );
  }
}
