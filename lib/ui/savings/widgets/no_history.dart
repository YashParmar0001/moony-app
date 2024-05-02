import 'package:flutter/material.dart';

class NoHistory extends StatelessWidget {
  const NoHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "No saving history",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 50),
        const Text(
          '@.@',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 144,
          ),
        ),
      ],
    );
  }
}
