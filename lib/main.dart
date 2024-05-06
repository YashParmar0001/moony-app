import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/bindings.dart';
import 'package:moony_app/theme/app_theme.dart';
import 'package:moony_app/ui/shell/screens/shell_screen.dart';
import 'package:moony_app/ui/shell/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Moony App',
      initialRoute: '/splash',
      theme: AppTheme.getTheme(),
      initialBinding: MoonyBinding(),
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
      ],
    );
  }
}
