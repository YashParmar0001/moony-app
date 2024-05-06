import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/ui/shell/screens/shell_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => Get.off(() => const ShellScreen()),
    );

    return const Scaffold(
      body: Center(
        child: Text(
          'Moony',
          style: TextStyle(
            fontSize: 80,
            fontFamily: 'Nimbus-Medium',
          ),
        ),
      ),
    );
  }
}
