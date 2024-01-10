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

import '../elementos/GotaBoss.dart';
import '../elementos/VidaComponent.dart';
import 'EmberPlayer2.dart';

class EmberPlayer extends SpriteAnimationComponent with HasGameRef<JuegoCarlos> {

  final VidasComponent vidasComponent;

  late EmberPlayerBody parentBody;

  EmberPlayer({
    required super.position,
    required super.size,
    required this.parentBody,
    required this.vidasComponent,
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
    if (other is EmberPlayerBody || other is EmberPlayerBody2) {
      vidasComponent.perderVida();
    }
  }
}

class EmberPlayerBody extends BodyComponent with KeyboardHandler, CollisionCallbacks {
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  final VidasComponent vidasComponent;
  final JuegoCarlos gameRef;

  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  late EmberPlayer emberPlayer;
  late double jumpSpeed=0.0;

  EmberPlayerBody({
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

  void removeEmberPlayer() {
    emberPlayer.removeFromParent();
  }


  @override
  Future<void> onLoad() {
    emberPlayer = EmberPlayer(
      position: Vector2(0, 0),
      size: tamano,
      parentBody: this,
      vidasComponent: vidasComponent, // Pasar vidasComponent aquí
    );
    add(emberPlayer);
    return super.onLoad();
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
        print("JUGADOR 1 INVERTIDO");
      }
    }

    if((keysPressed.contains(LogicalKeyboardKey.keyA))){horizontalDirection=-1;}
    else if((keysPressed.contains(LogicalKeyboardKey.keyD))){horizontalDirection=1;}
    if((keysPressed.contains(LogicalKeyboardKey.keyW))){verticalDirection=-1;}
    else if((keysPressed.contains(LogicalKeyboardKey.keyS))){verticalDirection=1;}

    return true;
  }

  @override
  void update(double dt) {

    velocidad.x = horizontalDirection * aceleracion;
    velocidad.y = verticalDirection * aceleracion;
    velocidad.y += -1 * jumpSpeed;

    body.applyLinearImpulse(velocidad*dt*1000);

    if (horizontalDirection < 0 && emberPlayer.scale.x > 0) {
      emberPlayer.flipHorizontallyAroundCenter();
    }
    else if (horizontalDirection > 0 && emberPlayer.scale.x < 0) {
      emberPlayer.flipHorizontallyAroundCenter();
    }
    super.update(dt);
  }
}



