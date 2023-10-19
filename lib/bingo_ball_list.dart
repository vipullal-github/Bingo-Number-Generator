import 'package:flutter/material.dart';

import 'app_data.dart';

class BingoBallList extends StatelessWidget {
  final AppData provider;
  const BingoBallList({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color.fromRGBO(0, 100, 0, 0.8);
    Color unSelectedColor = const Color.fromARGB(153, 115, 142, 14);
    Map<int, bool> flags = provider.flags;
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(
        provider.ballsSet.length,
        (index) {
          int idx = index + 1; // Numbers are 1 based.
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
                maxRadius: 32,
                backgroundColor: flags[idx]! ? unSelectedColor : selectedColor,
                child: Text("$idx")),
          );
        },
      ),
    );
  }
}
