import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bingo_ball.dart';

enum GameState {
  gameStateRaw,
  gameStateReadyToStart,
  gamePausedForNextDraw,
  generatingNextNumber,
  gameStateInProgress,
  gameStateGameOver
}

class AppData with ChangeNotifier {
  final int numberOfBalls = 90;
  List<BingoBall> ballsSet = [];

  GameState _gameState = GameState.gameStateRaw;
  GameState get gameState => _gameState;

  int _currentBallPosition = 0;
  Map<int, bool> flags = {};

  // --------------------------------
  void initSelf() {
    for (int i = 1; i <= numberOfBalls; i++) {
      ballsSet.add(BingoBall(i, false));
      flags[i] = false;
    }
    _gameState = GameState.gameStateReadyToStart;
    notifyListeners();
  }

  // --------------------------------
  void shuffleBalls() {
    Random r = Random();
    for (int i = 0; i < 50; i++) {
      int x = r.nextInt(numberOfBalls);
      if (x != i) {
        // No point swapping with self!
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

  // -------------------------------
  String getCounter() {
    return "${_currentBallPosition + 1}/${ballsSet.length}";
  }

  // --------------------------------
  void startGame() {
    int i = 1;
    for (var element in ballsSet) {
      element.isDone = false;
      flags[i++] = false;
    }
    shuffleBalls();
    _currentBallPosition = -1;
    _gameState = GameState.gamePausedForNextDraw;
    notifyListeners();
  }

  // ---------------------------------
  void resetGame() {
    // separate call for future use?
    startGame();
  }

  // ----------------------------------
  int getCurrentBallPicked() {
    if (_currentBallPosition != -1) {
      return ballsSet[_currentBallPosition].value;
    } else {
      print("Illegal call to get currentBall when game not running");
      return 0;
    }
  }

  // -----------------------------------
  void getNextBall() {
    if (_currentBallPosition < 0 || _currentBallPosition < ballsSet.length) {
      _gameState = GameState.generatingNextNumber;
      notifyListeners();
      Timer(const Duration(seconds: 1), () {
        ++_currentBallPosition;
        ballsSet[_currentBallPosition].isDone = true;
        int val = ballsSet[_currentBallPosition].value;
        flags[val] = true;
        _gameState = GameState.gamePausedForNextDraw;
        notifyListeners();
      });
    } else {
      _gameState = GameState.gameStateGameOver;
      notifyListeners();
    }
  }
}
