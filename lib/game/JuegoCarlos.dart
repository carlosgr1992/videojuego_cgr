
import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videojuego_cgr/players/EmberPlayer.dart';

import '../config/config.dart';
import '../elementos/Gota.dart';
import '../elementos/TierraBody.dart';
import '../players/EmberPlayer2.dart';

class JuegoCarlos extends Forge2DGame with HasKeyboardHandlerComponents, HasCollisionDetection, CollisionCallbacks {

  late final CameraComponent cameraComponent;
  late EmberPlayerBody2 _player1;
  late EmberPlayerBody2 _player2;
  late TiledComponent mapComponent;

  double wScale = 1.0,
      hScale = 1.0;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'ember.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'Tilemap1_32.png',
      'prueba1mapa.png',
      'prueba2mapa.jpeg',
    ]);


    cameraComponent = CameraComponent(world: world);
    wScale=size.x/gameWidth;
    hScale=size.y/gameHeight;

    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);

    mapComponent=await TiledComponent.load('prueba2mapa32.tmx', Vector2(32,32));
    world.add(mapComponent);

    ObjectGroup? gotas = mapComponent.tileMap.getLayer<ObjectGroup>("gotas");

    for (final gota in gotas!.objects) {
      Gota spriteGota = Gota(position: Vector2(gota.x, gota.y),
          size: Vector2(64 * wScale, 64 * hScale));
      add(spriteGota);
    }

    /*ObjectGroup? tierras = mapComponent.tileMap.getLayer<ObjectGroup>("tierra");

    for (final tiledObjectTierra in tierras!.objects) {
      TierraBody tierraBody = TierraBody(tiledBody: tiledObjectTierra,
          scales: Vector2(wScale, hScale));
      add(tierraBody);
    } */

    _player1 = EmberPlayerBody2(initialPosition: Vector2(128, canvasSize.y - 350,),
        tamano: Vector2(50,100), gameRef: this
    );

    _player2 = EmberPlayerBody2(
      gameRef: this, // Agrega esto
      initialPosition: Vector2(200, canvasSize.y - 350),
      tamano: Vector2(50, 50),
    );

    add(_player1);
    add(_player2);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {

    if(other is Gota){
      if(intersectionPoints.length == 2){
        if(other is Gota){
          removeFromParent();
        }
      }
    }

    super.onCollision(intersectionPoints, other);
  }
  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return const Color(0xFFE1FFFC);
  }
}

class EmberPlayerBody extends BodyComponent with KeyboardHandler {
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  final _defaultColor = Colors.red;
  late EmberPlayer emberPlayer;
  late double jumpSpeed = 0.0;

  EmberPlayerBody({Vector2? initialPosition,
    required this.tamano})
      : super(
    fixtureDefs: [
      FixtureDef(
        CircleShape()
          ..radius = tamano.x / 2,
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
}