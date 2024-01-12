import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import '../game/JuegoCarlos.dart';

class GotaBoss extends BodyComponent with CollisionCallbacks {
  final Vector2 position;
  final Vector2 size;

  GotaBoss({required this.position, required this.size});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;
    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.3
      ..density = 1.0
      ..friction = 0.2;

    final bodyDef = BodyDef()
      ..type = BodyType.static  // Static le hace que no se mueva
      ..position = position
      ..userData = this
      ..fixedRotation = true;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final animationComponent = SpriteAnimationComponent()
      ..animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('water_enemy.png'),
        SpriteAnimationData.sequenced(
          amount: 2,
          amountPerRow: 2,
          textureSize: Vector2(16, 16),
          stepTime: 0.12,
        ),
      )
      ..size = size
      ..anchor = Anchor.center;

    add(animationComponent);
  }
}
