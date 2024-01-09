import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:videojuego_cgr/game/JuegoCarlos.dart';

import '../elementos/Gota.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameReference<JuegoCarlos>, KeyboardHandler, CollisionCallbacks{

  int verticalDirection = 0;
  int horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  late ShapeHitbox hitbox;


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

    final defaultPaint = Paint()
    ..color = DefaultSelectionStyle.defaultColor
      ..style = PaintingStyle.stroke;

    hitbox = RectangleHitbox()
    ..paint = defaultPaint
    ..isSolid = true
    ..renderShape = false; // Muestra el cuadrado del area en el que colision
    add(hitbox);

    add(EmberPlayerBody(vector2Tamano: size));
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

    horizontalDirection = 0;
    verticalDirection = 0;


    if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      horizontalDirection = 1;
    } else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection = -1;
    } else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      verticalDirection= -1;
    } else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      verticalDirection = 1;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    // Aplicamos la velocidad horizontal
    velocity.x = horizontalDirection * moveSpeed;
    // Aplicamos la velocidad vertical
    velocity.y = verticalDirection * moveSpeed;
    // Actualizamos la posición basada en la velocidad
    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {

    if (other is Gota /*|| other is PlatformBlock*/) {
      if (intersectionPoints.length == 2) {
        if(other is Gota){
          removeFromParent();
        }
      }
      }
    super.onCollision(intersectionPoints, other);
    }


}