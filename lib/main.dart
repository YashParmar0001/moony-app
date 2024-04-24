import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:moony_app/bindings.dart';
import 'package:moony_app/theme/app_theme.dart';
import 'package:moony_app/ui/shell/screens/shell_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Moony App',
      initialRoute: '/',
      theme: AppTheme.getTheme(),
      initialBinding: MoonyBinding(),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      getPages: [
        GetPage(
          name: '/',
          page: () => const ShellScreen(),
        ),
      ],
    );
  }
}
