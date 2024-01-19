
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
import '../elementos/GotaBoss.dart';
import '../elementos/TierraBody.dart';
import '../elementos/VidaComponent.dart';
import '../players/EmberPlayer2.dart';

class JuegoCarlos extends Forge2DGame with
    HasKeyboardHandlerComponents,HasCollisionDetection, CollisionCallbacks{

  late VidasComponent vidasComponent;

  late final CameraComponent cameraComponent;
  late EmberPlayerBody _player;
  late EmberPlayerBody2 _player2;
  late GotaBoss gotaBoss;
  late Gota gota;
  late TiledComponent mapComponent;

  double wScale=1.0,hScale=1.0;

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
    //addAll([cameraComponent, world]);

    mapComponent=await TiledComponent.load('prueba2mapa32.tmx', Vector2(32,32));
    add(mapComponent);

    //gotas
    ObjectGroup? gotas=mapComponent.tileMap.getLayer<ObjectGroup>("gotas");

    for(final gota in gotas!.objects){
      Gota spriteGota = Gota(position: Vector2(gota.x,gota.y),
          size: Vector2(64*wScale,64*hScale));

      spriteGota.onBeginContact=InicioContactosDelJuego;

      add(spriteGota);
    }

    ObjectGroup? tierras=mapComponent.tileMap.getLayer<ObjectGroup>("tierra");

    for(final tiledObjectTierra in tierras!.objects){
      TierraBody tierraBody = TierraBody(tiledBody: tiledObjectTierra,
          scales: Vector2(wScale,hScale));
      add(tierraBody);
    }

    vidasComponent = VidasComponent(
      totalVidas: 5,
      vidaCompleta: Sprite(await images.load('heart.png')),
      mediaVida: Sprite(await images.load('heart_half.png')),
      tamanoCorazon: Vector2(32, 32),
    );
    add(vidasComponent);

    // Crear las instancias de EmberPlayerBody después de crear vidasComponent
    _player = EmberPlayerBody(
      gameRef: this,
      initialPosition: Vector2(98, canvasSize.y - 350),
      tamano: Vector2(50, 50),
      vidasComponent: vidasComponent, // Utiliza la variable de instancia
    );
    _player.onBeginContact=InicioContactosDelJuego;
    add(_player);


    _player2 = EmberPlayerBody2(initialPosition: Vector2(170, canvasSize.y - 350,),
        tamano: Vector2(50,50), vidasComponent: vidasComponent, gameRef: this
    );
    _player2.onBeginContact=InicioContactosDelJuego;
    add(_player2);

    gotaBoss = GotaBoss(position: Vector2(320, canvasSize.y - 180,), size: Vector2(90,90));
    gotaBoss.onBeginContact = InicioContactosDelJuego;
    add(gotaBoss);


  }

  @override
  Color backgroundColor() {
    return Color(0xFFE7FFFF);
  }

  void InicioContactosDelJuego(Object objeto, Contact contact) {
    if (objeto is Gota || objeto is GotaBoss) {
      // Llama a perderVida en vidasComponent
      vidasComponent.perderVida();

      // Verifica si el jugador se quedó sin vidas
      if (vidasComponent.vidasRestantes == 0) {
        // Eliminar ambos jugadores
        _player.removeFromParent();
        _player2.removeFromParent();
      }
    }
  }


}