import 'package:flutter/material.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "No Transactions\nTap '+' to add one",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 50),
        const Text(
          ':(',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 144,
          ),
        ),
      ],
    );
  }
}
