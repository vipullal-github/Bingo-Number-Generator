import 'package:flutter/material.dart';
import 'app_data.dart';

class WittyTextWidget extends StatelessWidget {
  final AppData provider;

  const WittyTextWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(provider.getWhittySaying()));
  }
}
