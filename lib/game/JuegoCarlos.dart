
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:videojuego_cgr/players/EmberPlayer.dart';

class JuegoCarlos extends FlameGame{

  final world = World();
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

    cameraComponent = CameraComponent(world: world);

    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);

    mapComponent = await TiledComponent.load('mapa1.tmx', Vector2.all(32));
    world.add(mapComponent);

    _player1 = EmberPlayer(position: Vector2(128, canvasSize.y - 200),);
    _player2 = EmberPlayer(position: Vector2(250, canvasSize.y - 200),);

    world.add(_player1);
    world.add(_player2);

  }

}