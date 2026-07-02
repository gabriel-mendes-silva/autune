import 'package:autune/view/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Gráfico de linha simples, feito com [CustomPainter], sem depender de
/// pacotes externos de gráficos. Recebe uma lista de valores (0 a 100) e
/// rótulos opcionais para o eixo X.
class AppLineChart extends StatelessWidget {
  final List<double> valores;
  final List<String> rotulosEixoX;
  final double height;

  const AppLineChart({
    super.key,
    required this.valores,
    this.rotulosEixoX = const [],
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _EixoY(),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _LineChartPainter(
                      valores: valores,
                      linhaColor: AppColors.rosehColor,
                      pontoColor: AppColors.mainColor,
                      gridColor: AppColors.borderGreyColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (rotulosEixoX.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: rotulosEixoX
                    .map((rotulo) => Text(
                          rotulo,
                          style: TextStyle(
                            fontFamily: 'AlanSans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.oliveBrownColor,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EixoY extends StatelessWidget {
  const _EixoY();

  @override
  Widget build(BuildContext context) {
    const marcas = [100, 75, 50, 25, 0];
    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: marcas
            .map((valor) => Text(
                  valor.toString(),
                  style: TextStyle(
                    fontFamily: 'AlanSans',
                    fontSize: 11,
                    color: AppColors.oliveBrownColor,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> valores;
  final Color linhaColor;
  final Color pontoColor;
  final Color gridColor;

  _LineChartPainter({
    required this.valores,
    required this.linhaColor,
    required this.pontoColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Linhas de grade horizontais (0, 25, 50, 75, 100).
    final Paint gridPaint = Paint()
      ..color = gridColor.withOpacity(0.6)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final double y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (valores.isEmpty) return;

    final double stepX =
        valores.length > 1 ? size.width / (valores.length - 1) : 0;

    Offset pontoParaOffset(int index) {
      final double valorClamp = valores[index].clamp(0, 100).toDouble();
      final double x = valores.length > 1 ? stepX * index : size.width / 2;
      final double y = size.height - (valorClamp / 100) * size.height;
      return Offset(x, y);
    }

    final List<Offset> pontos =
        List.generate(valores.length, pontoParaOffset);

    // Linha conectando os pontos.
    final Paint linhaPaint = Paint()
      ..color = linhaColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final Path path = Path()..moveTo(pontos.first.dx, pontos.first.dy);
    for (final ponto in pontos.skip(1)) {
      path.lineTo(ponto.dx, ponto.dy);
    }
    canvas.drawPath(path, linhaPaint);

    // Pontos (dots) em cada valor.
    final Paint pontoPaint = Paint()..color = pontoColor;
    for (final ponto in pontos) {
      canvas.drawCircle(ponto, 4, pontoPaint);
      canvas.drawCircle(ponto, 4, Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.valores != valores;
  }
}
