import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'bingo_ball.dart';

enum GameState {
  gameStateRaw,
  gameStateReadyToStart,
  gamePausedForNextDraw,
  generatingNextNumber,
  gameStateInProgress,
  gameStateGameOver
}

// from https://en.wikipedia.org/wiki/List_of_British_bingo_nicknames
// all rights acknowledged
Map<int, String> whittyQuotes = {
  1: "All by itself, number 1",
  2: "One little duck.",
  3: "Cup of tea",
  4: "Knock at the door",
  5: "Man alive",
  6: "Half a dozen",
  7: "Lucky number",
  8: "One Fat Lady",
  9: "Doctor's orders",
  10: "A big fat hen",
  11: "All the leggs, number eleven",
  12: "One dozen",
  13: "Unlucky for some, number thirteen",
  14: "Valentine's Day",
  15: "Young and keen, number fifteen",
  16: "Sweet 16",
  17: "Dancing Queen, number seventeen",
  18: "Get your drivers lisence, number eighteen.",
  19: "Last of the teens, number nineteen",
  20: "",
  21: "Royal salute",
  22: "Two ittle ducks",
  23: "Three and me",
  24: "Two dozzen",
  25: "Duck and Dive",
  26: "Pick and mix, number 26",
  27: "Gateway to heaven",
  28: "Overweight, number 28",
  29: "Rise and shine, number 29",
  30: "Dirty Gertie",
  31: "Get up and run, number 31",
  32: "Buckle my shoe, number 32",
  33: "Dirty knee, number 33",
  34: "The house with the bamboo door, number 34",
  35: "Jump and Jive",
  36: "Three dozzen",
  37: "More than 11",
  38: "Christmas cake",
  39: "",
  40: "Life begins at 40",
  41: "Time for fun, number 41",
  42: "Winnie the Pooh",
  43: "Down on your knees",
  44: "Droopy Drawers",
  45: "Halfway there",
  46: "Up to tricks",
  47: "Four and seven",
  48: "Four dozzen",
  49: "PC",
  50: "Half a century",
  51: "Tweak of the thumb",
  52: "Deck of cards",
  53: "Stuck in the tree",
  54: "Man at the door",
  55: "All the fives",
  56: "",
  57: "",
  58: "Make them wait",
  59: "",
  60: "Five dozen",
  61: "Bakers bun",
  62: "Turn the screw",
  63: "Tickle me",
  64: "Almost retired",
  65: "Old age pension",
  66: "Clickety click",
  67: "Stairway to Heaven",
  68: "Pick a mate",
  69: "Either way up",
  70: "Three score and 10",
  71: "Bang on the drum",
  72: "Six dozen",
  73: "Queen bee",
  74: "Hit the floor",
  75: "Strive and strive[",
  76: "",
  77: "",
  78: "Heaven's gate",
  79: "One more time",
  80: "Eight and blank",
  81: "Fat lady with a walking stick",
  82: "Straight on through",
  83: "Time for tea",
  84: "Give me more",
  85: "Staying alive",
  86: "Between the sticks",
  87: "",
  88: "Two fat ladies",
  89: "",
  90: "Top of the shop",
};

class AppData with ChangeNotifier {
  final int numberOfBalls = 90;
  List<BingoBall> ballsSet = [];

  GameState _gameState = GameState.gameStateRaw;
  GameState get gameState => _gameState;

  int _currentBallPosition = 0;
  Map<int, bool> flags =
      {}; // Using Map instead of BitSet because BitSet is not supported on Web

  // int _lastNumber = 0;
  // int get lastNumber => _lastNumber;

  String getWhittySaying() {
    int b = getCurrentBallPicked();
    if (b == 0) {
      return "";
    }
    return whittyQuotes[b] ?? "";
  }

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
    if (kDebugMode) {
      print(result);
    }
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
