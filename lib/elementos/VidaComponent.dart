import 'dart:ui';

import 'package:flame/components.dart';

class VidasComponent extends PositionComponent {
  final int totalVidas;
  int vidasRestantes;
  final Sprite vidaCompleta;
  final Sprite mediaVida;
  final double espacio; // Espacio entre corazones
  final Vector2 tamanoCorazon;

  VidasComponent({
    required this.totalVidas,
    required this.vidaCompleta,
    required this.mediaVida,
    this.espacio = 4.0,
    required this.tamanoCorazon,
  }) : vidasRestantes = totalVidas;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (int i = 0; i < totalVidas; i++) {
      // Determinar qué sprite usar
      Sprite sprite = i < vidasRestantes ? vidaCompleta : mediaVida;
      // Calcular la posición de cada corazón
      double x = (tamanoCorazon.x + espacio) * i;
      sprite.render(canvas, position: Vector2(x, 0), size: tamanoCorazon);
    }
  }

  void perderVida() {
    if (vidasRestantes > 0) {
      vidasRestantes--;
    }
  }
}
