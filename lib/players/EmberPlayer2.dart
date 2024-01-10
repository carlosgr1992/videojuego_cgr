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
import '../elementos/VidaComponent.dart';

class EmberPlayer2 extends SpriteAnimationComponent
    with HasGameRef<JuegoCarlos> {

  final VidasComponent vidasComponent;

  EmberPlayer2(this.vidasComponent, {
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        amountPerRow: 4,
        textureSize: Vector2(16,16),
        stepTime: 0.12,
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is EmberPlayerBody2 || other is EmberPlayerBody2) {
      vidasComponent.perderVida();
    }
  }

}

class EmberPlayerBody2 extends BodyComponent with KeyboardHandler, CollisionCallbacks{

  final VidasComponent vidasComponent;
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  final JuegoCarlos gameRef;

  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  late EmberPlayer2 emberPlayer2;
  late double jumpSpeed=0.0;

  EmberPlayerBody2({
    Vector2? initialPosition,required this.vidasComponent,required this.gameRef,
    required this.tamano})
      : super(
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
      fixedRotation: true,
    ),
  );


  @override
  Future<void> onLoad() {
    emberPlayer2 = EmberPlayer2(
      vidasComponent, // Argumento posicional
      position: Vector2(0, 0),
      size: tamano,
    );
    add(emberPlayer2); // Corrección de nombre aquí
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is EmberPlayerBody2) {
      vidasComponent.perderVida();
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

    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.digit5) {
        gameRef.toggleWorldGravity();
        print("JUGADOR 2 INVERTIDO");
      }
    }

    if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){horizontalDirection=-1;}
    else if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){horizontalDirection=1;}
    if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){verticalDirection=-1;}
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){verticalDirection=1;}

    return true;
  }

  @override
  void update(double dt) {

    velocidad.x = horizontalDirection * aceleracion;
    velocidad.y = verticalDirection * aceleracion;
    velocidad.y += -1 * jumpSpeed;

    body.applyLinearImpulse(velocidad*dt*1000);

    if (horizontalDirection < 0 && emberPlayer2.scale.x > 0) {
      emberPlayer2.flipHorizontallyAroundCenter();
    }
    else if (horizontalDirection > 0 && emberPlayer2.scale.x < 0) {
      emberPlayer2.flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }
}
