import 'package:bingo_app/app_data.dart';
import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {
  final AppData provider;
  const SpinnerWidget({super.key, required this.provider});

  @override
  State<SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget> {
  Future<void> _confirmResetGame(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please confirm"),
          content: const Text("Are you sure you want to reset the game?"),
          actions: [
            TextButton(
                onPressed: () {
                  widget.provider.resetGame();
                  Navigator.of(context).pop();
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No, play on!"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String text = "";
    bool nextButtonEnabled =
        widget.provider.gameState == GameState.gamePausedForNextDraw;
    TextStyle? ts =
        Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 35);
    if (widget.provider.gameState == GameState.gamePausedForNextDraw) {
      text = "${widget.provider.getCurrentBallPicked()}";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: ts,
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: !nextButtonEnabled
              ? null
              : () {
                  widget.provider.getNextBall();
                },
          child: const Text("Next"),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          widget.provider.getCounter(),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          //style: Theme.of(context).buttonTheme.copyWith(color: Colors.red),
          onPressed: () {
            _confirmResetGame(context);
            //widget.provider.resetGame();
          },
          child: const Text("Restart"),
        ),
      ],
    );
  }
}
