import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/current_transaction_controller.dart';

import '../../../theme/colors.dart';

class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    required this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColors.white,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Form(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 50,
                  right: 10,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                errorText: errorText,
              ),
              style: Theme.of(context).textTheme.headlineLarge,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
