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

class EmberPlayer extends SpriteAnimationComponent
    with HasGameRef<JuegoCarlos>, KeyboardHandler, CollisionCallbacks {

  late ShapeHitbox hitbox;
  late Vector2 tamano;

  EmberPlayer({
    required super.position
    ,required super.size
  }) : super( anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteComponent = SpriteAnimationComponent(
      animation: await gameRef.loadSpriteAnimation(
          'ember.png', // Asegúrate de que esta ruta es correcta
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2(60, 88),
            stepTime: 0.12,
          )
      ),
      size: tamano,
      anchor: Anchor.center,
    );
    add(spriteComponent);
  }
}

class EmberPlayerBody extends BodyComponent with KeyboardHandler, CollisionCallbacks {
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;


  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  final _defaultColor = Colors.red;
  late EmberPlayer emberPlayer;
  late double jumpSpeed=0.0;

  EmberPlayerBody({Vector2? initialPosition,
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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Gota) {
      // Aquí manejas lo que sucede cuando EmberPlayer colisiona con una Gota
      removeFromParent(); // Esto removerá EmberPlayerBody del juego
      print("COLISION");
    }
  }

  @override
  Future<void> onLoad() {
    emberPlayer=EmberPlayer(position: Vector2(0,0),size:tamano);
    add(emberPlayer);
    return super.onLoad();
  }

  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    horizontalDirection = 0;
    verticalDirection = 0;

    //movimiento
    if((keysPressed.contains(LogicalKeyboardKey.keyA))){horizontalDirection=-1;}
    else if((keysPressed.contains(LogicalKeyboardKey.keyD))){horizontalDirection=1;}
    if((keysPressed.contains(LogicalKeyboardKey.keyW))){verticalDirection=-1;}
    else if((keysPressed.contains(LogicalKeyboardKey.keyS))){verticalDirection=1;}

    return true;
  }

  @override
  void update(double dt) {
    //updatear movimiento
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



