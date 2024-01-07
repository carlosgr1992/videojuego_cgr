
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:videojuego_cgr/players/EmberPlayer.dart';

class JuegoCarlos extends FlameGame{

  final world = World();
  late final CameraComponent cameraComponent;
  late EmberPlayer _player1;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'ember.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    cameraComponent = CameraComponent(world: world);

    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);

    _player1 = EmberPlayer(
      position: Vector2(128, canvasSize.y - 70),
    );
    world.add(_player1);

  }

}