import 'package:bingo_app/bingo_ball_list.dart';
import 'package:bingo_app/witty_text_widget.dart';
import 'package:bingo_app/spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';

// copy funny BingoCalling from https://en.wikipedia.org/wiki/List_of_British_bingo_nicknames

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  // -------------------------------------------------
  Widget _waitingForInit(BuildContext context, AppData provider) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      provider.initSelf();
    });
    return const Row(
      children: [Text("Please wait..."), CircularProgressIndicator()],
    );
  }

  // -------------------------------------------------
  Widget _showStartGame(BuildContext context, AppData provider) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            provider.startGame();
          });
        },
        child: const Text("Start new game"),
      ),
    );
  }

  // --------------------------------------------------
  Widget _gameScreen(BuildContext context, AppData provider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinnerWidget(
            provider: provider,
          ),
          WittyTextWidget(provider: provider),
          Expanded(child: BingoBallList(provider: provider)),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  Widget _buildBody(BuildContext context, AppData provider) {
    if (provider.gameState == GameState.gameStateRaw) {
      return _waitingForInit(context, provider);
    } else if (provider.gameState == GameState.gameStateReadyToStart) {
      return _showStartGame(context, provider);
    } else {
      return _gameScreen(context, provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bingo!"),
      ),
      body: Consumer<AppData>(
        builder: (context, value, child) {
          return _buildBody(context, value);
        },
      ),
    );
  }
}
