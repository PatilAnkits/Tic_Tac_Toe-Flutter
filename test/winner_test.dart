import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/utils/game_logic.dart';

void main(){
  test('validate the winner', () {
    final game = Game();
    var result = game.winnerCheck("X", 7, [-1, 1, 0, 0, 2, -2, 0, 0], 3);
    expect(result, true);
  });

  test('validate the Draw', () {
    final game = Game();
    var result = game.winnerCheck("X", 7, [1, -1, 0, -1, 0, 1, -1, -1], 3);
    expect(result, false);
  });
}