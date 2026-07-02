import 'package:autune/providers/afinador_provider.dart';
import 'package:autune/view/widgets/app_colors.dart';
import 'package:autune/view/widgets/tuner_gauge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela do Afinador.
///
/// Agora é um [StatelessWidget] — toda a lógica e estado ficam no
/// [AfinadorProvider]. A tela apenas lê o que precisa com [context.select],
/// garantindo que cada sub-widget só seja reconstruído quando o dado
/// específico que ele exibe mudar.
class AfinadorPage extends StatefulWidget {
  const AfinadorPage({super.key});

  @override
  State<AfinadorPage> createState() => _AfinadorPageState();
}

// Mantemos StatefulWidget apenas para iniciar o afinador no initState.
// O estado em si vive no AfinadorProvider.
class _AfinadorPageState extends State<AfinadorPage> {
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para garantir que o contexto já está
    // montado antes de chamar o Provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AfinadorProvider>().iniciar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reconstrói SOMENTE este Text quando o status muda.
              _StatusTitle(),
              // Reconstrói SOMENTE quando há erro.
              _ErroWidget(),
              const SizedBox(height: 20),
              // Reconstrói quando nota/Hz/cents mudam.
              _GaugeCard(),
              const SizedBox(height: 28),
              Text(
                'CORDA',
                style: TextStyle(
                  fontFamily: 'AlanSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainColor,
                ),
              ),
              const SizedBox(height: 12),
              // Reconstrói SOMENTE quando o índice de corda muda.
              _SeletorCordas(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets internos — cada um escuta só o que precisa ──────────────────────

class _StatusTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // context.select: só reconstrói este widget quando mensagemStatus muda.
    final status = context.select<AfinadorProvider, String>(
      (p) => p.mensagemStatus,
    );
    return Text(
      status,
      style: TextStyle(
        fontFamily: 'NotoSerif',
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.mainColor,
      ),
    );
  }
}

class _ErroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final erro = context.select<AfinadorProvider, String?>(
      (p) => p.erro,
    );
    if (erro == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        erro,
        style: TextStyle(
          fontFamily: 'AlanSans',
          fontSize: 13,
          color: AppColors.oliveBrownColor,
        ),
      ),
    );
  }
}

class _GaugeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Seleciona apenas os três valores que o card usa.
    final nota = context.select<AfinadorProvider, String>(
      (p) => p.leituraAtual?.note ?? '--',
    );
    final frequencia = context.select<AfinadorProvider, double>(
      (p) => p.leituraAtual?.frequency ?? 0,
    );
    final cents = context.select<AfinadorProvider, double>(
      (p) => p.leituraAtual?.cents ?? 0,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.coffeishColor,
        border: Border.all(color: AppColors.borderCoffeishColor, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              left: -30,
              child: Opacity(
                opacity: 0.25,
                child: Transform.flip(
                  flipX: true,
                  child: Image.asset('assets/folha (1).png', width: 120),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              right: -40,
              child: Opacity(
                opacity: 0.25,
                child: Image.asset('assets/folha (1).png', width: 150),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Column(
                children: [
                  Text(
                    nota,
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppColors.mainColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${frequencia.toStringAsFixed(0)} Hz',
                    style: TextStyle(
                      fontFamily: 'AlanSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.oliveBrownColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TunerGauge(cents: cents),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeletorCordas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Só reconstrói quando o índice de corda selecionada mudar.
    final selecionada = context.select<AfinadorProvider, int?>(
      (p) => p.cordaSelecionadaIndex,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        AfinadorProvider.cordas.length,
        (index) => _CordaButton(
          label: AfinadorProvider.cordas[index],
          selecionada: index == selecionada,
          onTap: () => context.read<AfinadorProvider>().selecionarCorda(index),
        ),
      ),
    );
  }
}

class _CordaButton extends StatelessWidget {
  final String label;
  final bool selecionada;
  final VoidCallback onTap;

  const _CordaButton({
    required this.label,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selecionada ? AppColors.middleGreyColor : Colors.white,
          border: Border.all(color: AppColors.borderGreyColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'AlanSans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.mainColor,
          ),
        ),
      ),
    );
  }
}
