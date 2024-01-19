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

class EmberPlayerBody extends BodyComponent with KeyboardHandler, ContactCallbacks, CollisionCallbacks {
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  int vidas = 5;
  Vector2 initialPosition;
  final VidasComponent vidasComponent;
  final JuegoCarlos gameRef;

  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  late EmberPlayer emberPlayer;
  late double jumpSpeed=0.0;

  EmberPlayerBody({
    required this.initialPosition,required this.vidasComponent,required this.gameRef,
    required this.tamano})
      : super();

  @override
  Body createBody() {
    BodyDef definicionCuerpo = BodyDef(
        position: initialPosition,
        type: BodyType.dynamic,
        angularDamping: 0.8,
        fixedRotation: true, // Esto evita que el cuerpo rote
        userData: this
    );

    Body cuerpo = world.createBody(definicionCuerpo);

    final shape = CircleShape();
    shape.radius = tamano.x / 2;

    FixtureDef fixtureDef = FixtureDef(
        shape,
        //density: 10.0,
        friction: 0.2,
        restitution: 0.5,
        userData: this
    );

    cuerpo.createFixture(fixtureDef);

    return cuerpo;
  }

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
      if (event.logicalKey == LogicalKeyboardKey.space) {
        body.gravityOverride = (body.gravityOverride?.y ?? 0) > 1
            ? Vector2(0, -100.0)
            : Vector2(0, 100.0);
        print("Jugador 1 invertida gravedad");
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



