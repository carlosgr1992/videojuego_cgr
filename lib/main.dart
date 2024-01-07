import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/JuegoCarlos.dart';

void main() {

  runApp(
    const GameWidget<JuegoCarlos>.controlled(
      gameFactory: JuegoCarlos.new,
    ),
  );

}

