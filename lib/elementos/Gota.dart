import 'dart:async';

import 'package:flame/components.dart';

import '../game/JuegoCarlos.dart';

class Gota extends SpriteAnimationComponent with HasGameRef<JuegoCarlos> {
  Gota({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);


  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        amountPerRow: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );

  }

}