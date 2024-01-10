import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import '../game/JuegoCarlos.dart';


class Gota extends SpriteAnimationComponent
    with HasGameRef<JuegoCarlos>,CollisionCallbacks{

  Gota({
    required super.position, required super.size
  }) : super(anchor: Anchor.center);

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        amountPerRow: 2,
        textureSize: Vector2(16,16),
        stepTime: 0.12,
      ),
    );

    final defaultPaint = Paint()
      ..color = DefaultSelectionStyle.defaultColor
      ..style = PaintingStyle.stroke;

    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..isSolid = true
      ..renderShape = false; // Muestra el cuadrado del area en el que colision
    add(hitbox);

    return super.onLoad();
  }

}