import 'dart:math' as math;

import 'package:autune/view/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Medidor semicircular que mostra o quão afinada (em cents, de -50 a +50)
/// está a corda selecionada. 0 = afinação perfeita (ponteiro para cima).
class TunerGauge extends StatelessWidget {
  final double cents;
  final double height;

  const TunerGauge({super.key, required this.cents, this.height = 170});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _TunerGaugePainter(
              cents: cents.clamp(-50, 50).toDouble(),
              color: AppColors.oliveBrownColor,
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: _EdgeLabel(texto: '-50'),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: _EdgeLabel(texto: '+50'),
          ),
        ],
      ),
    );
  }
}

class _EdgeLabel extends StatelessWidget {
  final String texto;
  const _EdgeLabel({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontFamily: 'AlanSans',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.oliveBrownColor,
      ),
    );
  }
}

class _TunerGaugePainter extends CustomPainter {
  final double cents;
  final Color color;

  _TunerGaugePainter({required this.cents, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min(size.width / 2, size.height) - 6;
    final Offset center = Offset(size.width / 2, size.height);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    // Arco de fundo (semicírculo superior).
    final Paint arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, math.pi, math.pi, false, arcPaint);

    // Marcações (ticks) ao longo do arco.
    final Paint tickPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const int totalTicks = 20;
    for (int i = 0; i <= totalTicks; i++) {
      final double t = i / totalTicks;
      final double angle = math.pi + t * math.pi;
      final bool tickPrincipal = i % 5 == 0;
      final double tickLen = tickPrincipal ? 12 : 6;

      final Offset externo = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final Offset interno = Offset(
        center.dx + (radius - tickLen) * math.cos(angle),
        center.dy + (radius - tickLen) * math.sin(angle),
      );
      canvas.drawLine(interno, externo, tickPaint);
    }

    // Ponteiro (needle): 0 cents = reto para cima (3*pi/2).
    final double anguloPonteiro =
        (3 * math.pi / 2) + (cents / 50) * (math.pi / 2);
    final double comprimentoPonteiro = radius - 18;

    final Offset ponta = Offset(
      center.dx + comprimentoPonteiro * math.cos(anguloPonteiro),
      center.dy + comprimentoPonteiro * math.sin(anguloPonteiro),
    );

    // Perpendicular ao ponteiro, para desenhar a base "em losango".
    final double anguloPerp = anguloPonteiro + math.pi / 2;
    const double larguraBase = 7;
    final Offset baseEsquerda = Offset(
      center.dx + larguraBase * math.cos(anguloPerp),
      center.dy + larguraBase * math.sin(anguloPerp),
    );
    final Offset baseDireita = Offset(
      center.dx - larguraBase * math.cos(anguloPerp),
      center.dy - larguraBase * math.sin(anguloPerp),
    );

    final Path needlePath = Path()
      ..moveTo(baseEsquerda.dx, baseEsquerda.dy)
      ..lineTo(ponta.dx, ponta.dy)
      ..lineTo(baseDireita.dx, baseDireita.dy)
      ..close();

    canvas.drawPath(needlePath, Paint()..color = color);

    // Pivô circular na base do ponteiro.
    canvas.drawCircle(center, 6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TunerGaugePainter oldDelegate) {
    return oldDelegate.cents != cents || oldDelegate.color != color;
  }
}
