import 'package:bingo_app/app_data.dart';
import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {
  final AppData provider;
  const SpinnerWidget({super.key, required this.provider});

  @override
  State<SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("00"),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Next"),
        ),
      ],
    );
  }
}
