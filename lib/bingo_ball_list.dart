import 'package:flutter/material.dart';

import 'app_data.dart';

class BingoBallList extends StatelessWidget {
  final AppData provider;
  const BingoBallList({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color.fromRGBO(0, 100, 0, 0.8);
    Color unSelectedColor = const Color.fromARGB(153, 115, 142, 14);
    Color textColor = Colors.white70;
    TextStyle? ts =
        Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor);
    Map<int, bool> flags = provider.flags;
    return GridView.extent(
      //crossAxisCount: 5,
      maxCrossAxisExtent: 32.0,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      children: List.generate(
        provider.ballsSet.length,
        (index) {
          int idx = index + 1; // Numbers are 1 based.
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: flags[idx]! ? unSelectedColor : selectedColor,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "$idx",
                  style: ts,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
