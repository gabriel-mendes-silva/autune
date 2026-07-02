import 'package:autune/view/widgets/app_colors.dart';
import 'package:autune/view/widgets/line_chart.dart';
import 'package:flutter/material.dart';

/// Modelo simples de uma sessão de afinação exibida no histórico.
///
/// TODO: substituir os dados mockados por consultas reais ao
/// [DatabaseService] quando as sessões passarem a ser persistidas.
class SessaoAfinacao {
  final String titulo;
  final String data;
  final double afinacaoPorcentagem;
  final bool favorita;

  const SessaoAfinacao({
    required this.titulo,
    required this.data,
    required this.afinacaoPorcentagem,
    this.favorita = false,
  });
}

class HistoricoPage extends StatelessWidget {
  HistoricoPage({super.key});

  // Dados de demonstração para preencher a tela conforme o protótipo.
  final List<double> _afinacaoPorMes = const [20, 42, 88, 38, 90];
  final List<String> _mesesEixoX = const ['JAN', 'JAN', 'JAN', 'JAN'];

  final List<SessaoAfinacao> _sessoes = const [
    SessaoAfinacao(
      titulo: 'Sessão Nº10',
      data: 'Data: 10/20/30',
      afinacaoPorcentagem: 89,
    ),
    SessaoAfinacao(
      titulo: 'Sessão Nº10',
      data: 'Data: 10/20/30',
      afinacaoPorcentagem: 89,
    ),
    SessaoAfinacao(
      titulo: 'Sessão Nº10',
      data: 'Data: 10/20/30',
      afinacaoPorcentagem: 89,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Histórico',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 16),
            _GraficoCard(
              valores: _afinacaoPorMes,
              rotulosEixoX: _mesesEixoX,
            ),
            const SizedBox(height: 24),
            Text(
              'SESSÕES',
              style: TextStyle(
                fontFamily: 'AlanSans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.mainColor,
              ),
            ),
            Divider(color: AppColors.borderGreyColor),
            const SizedBox(height: 8),
            Text(
              'Gostou de alguma afinação? Você pode repetí-las quando quiser!',
              style: TextStyle(
                fontFamily: 'AlanSans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.oliveBrownColor,
              ),
            ),
            const SizedBox(height: 16),
            ..._sessoes.map((sessao) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SessaoCard(sessao: sessao),
                )),
          ],
        ),
      ),
    );
  }
}

class _GraficoCard extends StatelessWidget {
  final List<double> valores;
  final List<String> rotulosEixoX;

  const _GraficoCard({required this.valores, required this.rotulosEixoX});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGreyColor, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: AppColors.rosehColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AFINAÇÃO POR MÊS (%)',
                style: TextStyle(
                  fontFamily: 'AlanSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppLineChart(valores: valores, rotulosEixoX: rotulosEixoX),
        ],
      ),
    );
  }
}

class _SessaoCard extends StatelessWidget {
  final SessaoAfinacao sessao;

  const _SessaoCard({required this.sessao});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.coffeishColor,
        border: Border.all(color: AppColors.borderCoffeishColor, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.play_arrow_rounded,
              color: AppColors.oliveBrownColor,
              size: 30,
            ),
            onPressed: () {
              // TODO: reproduzir/repetir a sessão de afinação selecionada.
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessao.titulo,
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sessao.data,
                  style: TextStyle(
                    fontFamily: 'AlanSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.oliveBrownColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              sessao.favorita ? Icons.star_rounded : Icons.star_border_rounded,
              color: AppColors.oliveBrownColor,
              size: 20,
            ),
            onPressed: () {
              // TODO: marcar/desmarcar sessão como favorita.
            },
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 40, color: AppColors.borderCoffeishColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'AFINAÇÃO (%)',
                style: TextStyle(
                  fontFamily: 'AlanSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.oliveBrownColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${sessao.afinacaoPorcentagem.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontFamily: 'NotoSerif',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.oliveBrownColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
