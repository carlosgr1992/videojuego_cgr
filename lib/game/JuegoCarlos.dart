
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:videojuego_cgr/players/EmberPlayer.dart';

import '../elementos/Gota.dart';

class JuegoCarlos extends Forge2DGame with HasKeyboardHandlerComponents, HasCollisionDetection {

  late final CameraComponent cameraComponent;
  late EmberPlayer _player1, _player2;
  late TiledComponent mapComponent;



  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'ember.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'Tilemap1_32.png',
    ]);

    mapComponent = await TiledComponent.load('mapa1.tmx', Vector2.all(32));

    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);

    world.add(mapComponent);

    ObjectGroup? gotas = mapComponent.tileMap.getLayer<ObjectGroup>("gotas");
    gotas?.objects.forEach((gota) {
      Gota spriteGota = Gota(position: Vector2(gota.x, gota.y), size: Vector2.all(32));
      add(spriteGota);
    });

    _player1 = EmberPlayer(position: Vector2(128, canvasSize.y - 200));
    _player2 = EmberPlayer(position: Vector2(250, canvasSize.y - 200));

    world.add(_player1);
    world.add(_player2);
  }

}

class EmberPlayerBody extends BodyComponent{

  Vector2 vector2Tamano;

  EmberPlayerBody({required this.vector2Tamano});

  @override
  Body createBody() {
    
    BodyDef definicionCuerpo = BodyDef(position: position,
    type: BodyType.dynamic, fixedRotation: true);
    Body cuerpo = world.createBody(definicionCuerpo);
    
    final shape = CircleShape();
    shape.radius = vector2Tamano.x/2;
    
    FixtureDef fixtureDef = FixtureDef(shape, restitution: 0.5);
    return super.createBody();
  }
}