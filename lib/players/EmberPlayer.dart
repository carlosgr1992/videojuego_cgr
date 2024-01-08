import 'dart:async';

import 'package:flame/components.dart';
import 'package:videojuego_cgr/game/JuegoCarlos.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameReference<JuegoCarlos> {

  EmberPlayer({
    required super.position,
  }) : super(size: Vector2(64,64), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }
}