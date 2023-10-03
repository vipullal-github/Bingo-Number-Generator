import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bingo_ball.dart';

enum GameState {
  gameStateRaw,
  gameStateNotStarted,
  gameStateInProgress,
  gameStateGameOver
}

class AppData with ChangeNotifier {
  List<BingoBall> ballsSet = [];

  GameState _gameState = GameState.gameStateRaw;
  GameState get gameState => _gameState;

  bool get gameInProgress => _gameState == GameState.gameStateInProgress;

  int _currentBallPosition = 0;
  Map<int, bool> flags = {};

  // --------------------------------
  void initSelf() {
    for (int i = 1; i < 91; i++) {
      ballsSet.add(BingoBall(i, false));
      flags[i] = false;
    }
    _gameState = GameState.gameStateNotStarted;
    notifyListeners();
  }

  // --------------------------------
  void shuffleBalls() {
    Random r = Random();
    for (int i = 0; i < 50; i++) {
      int x = r.nextInt(90);
      if (x != i) {
        int temp = ballsSet[i].value;
        ballsSet[i].value = ballsSet[x].value;
        ballsSet[x].value = temp;
      }
    }
    String result = "";
    for (var e in ballsSet) {
      result += "${e.value} ";
    }
    print(result);
  }

  // --------------------------------
  void startGame() {
    int i = 0;
    for (var element in ballsSet) {
      element.isDone = false;
      flags[i] = false;
    }
    shuffleBalls();
    _currentBallPosition = -1;
    _gameState = GameState.gameStateInProgress;
    getNextBall();
  }

  // ----------------------------------
  int getCurrentBallPicked() {
    if (_gameState == GameState.gameStateInProgress) {
      return ballsSet[_currentBallPosition].value;
    } else {
      throw Exception("Illegal call to get currentBall when game not running");
    }
  }

  // -----------------------------------
  void getNextBall() {
    if (_currentBallPosition < 0 || _currentBallPosition < ballsSet.length) {
      ++_currentBallPosition;
      ballsSet[_currentBallPosition].isDone = true;
      int val = ballsSet[_currentBallPosition].value;
      flags[val] = true;
    } else {
      _gameState = GameState.gameStateGameOver;
    }
    notifyListeners();
  }
}
