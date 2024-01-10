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

class EmberPlayer2 extends SpriteAnimationComponent
    with HasGameRef<JuegoCarlos> {

  EmberPlayer2({
    required super.position
    ,required super.size
  }) : super( anchor: Anchor.center);

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
}

class EmberPlayerBody2 extends BodyComponent with KeyboardHandler{

  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  late EmberPlayer2 emberPlayer2;
  late double jumpSpeed=0.0;

  EmberPlayerBody2({Vector2? initialPosition,
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
    ),
  );

  @override
  Future<void> onLoad() {
    // TODO: implement onLoad
    emberPlayer2=EmberPlayer2(position: Vector2(0,0),size:tamano);
    add(emberPlayer2);
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
