import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videojuego_cgr/game/JuegoCarlos.dart';

import '../elementos/Gota.dart';

class EmberPlayer2 extends SpriteAnimationComponent {
  final JuegoCarlos gameRef;

  EmberPlayer2({
    required this.gameRef,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Cargamos la animación y la asignamos a la variable 'animation'
    animation = await gameRef.loadSpriteAnimation(
      'ember.png', // Ruta correcta de tu imagen
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(16, 16),
        stepTime: 0.12,
      ),
    );
  }
}


class EmberPlayerBody2 extends BodyComponent with KeyboardHandler, CollisionCallbacks {
  final JuegoCarlos gameRef;

  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  late EmberPlayer2 emberPlayer2;

  EmberPlayerBody2({
    Vector2? initialPosition,
    required this.gameRef,
    required this.tamano,
  }) : super(
    fixtureDefs: [
      FixtureDef(
        CircleShape()..radius = tamano.x/2,
        restitution: 0.8,
        friction: 0.4,
      ),
    ],
    bodyDef: BodyDef(
      angularDamping: 0.8,
      position: initialPosition ?? Vector2.zero(),
      type: BodyType.dynamic,
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    emberPlayer2 = EmberPlayer2(
      gameRef: gameRef,
      position: Vector2.zero(),
      size: tamano,
    );
    add(emberPlayer2);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Gota) {
      removeFromParent(); // Esto removerá EmberPlayerBody del juego
      print("COLISION");
    }
  }

  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      horizontalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      horizontalDirection = 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      verticalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      verticalDirection = 1;
    }

    return true;
  }

  @override
  void update(double dt) {
    velocidad.x = horizontalDirection * aceleracion;
    velocidad.y = verticalDirection * aceleracion;

    body.applyLinearImpulse(velocidad * dt * 1000);

    if (horizontalDirection < 0 && emberPlayer2.scale.x > 0) {
      emberPlayer2.flipHorizontallyAroundCenter();
    } else if (horizontalDirection > 0 && emberPlayer2.scale.x < 0) {
      emberPlayer2.flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }
}
