
import 'package:flame/game.dart';

class JuegoCarlos extends FlameGame{

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'ember.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

  }

}