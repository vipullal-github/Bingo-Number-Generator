import 'package:bingo_app/game_page.dart';
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home:
          const GamePage(), //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
