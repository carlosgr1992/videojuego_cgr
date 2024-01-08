import 'dart:async';

import 'package:flame/components.dart';

import '../game/JuegoCarlos.dart';

class Gota extends SpriteAnimationComponent with HasGameRef<JuegoCarlos> {

  Gota({
    required super.position, required super.size
  }) : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );

  }

}