import 'dart:async';

import 'package:autune/services/tuner_service.dart';
import 'package:flutter/foundation.dart';
import 'package:pitchupdart/tuning_status.dart';

/// Gerencia o estado da tela do Afinador e notifica os widgets ouvintes
/// sempre que uma nova leitura de pitch chega do microfone.
///
/// Ao usar [ChangeNotifier] com o pacote Provider, apenas os widgets que
/// dependem de um valor específico (via [Consumer] ou [context.select])
/// são reconstruídos — ao contrário do [setState], que reconstruía toda a
/// árvore da [AfinadorPage] a cada leitura.
class AfinadorProvider extends ChangeNotifier {
  static const List<String> cordas = ['E3', 'A3', 'D3', 'G3', 'B3', 'E3'];

  final TunerService _tunerService;
  StreamSubscription<TunerReading>? _subscription;

  // Estado exposto para a UI
  TunerReading? _leituraAtual;
  int? _cordaSelecionadaIndex;
  String? _erro;
  bool _iniciado = false;

  TunerReading? get leituraAtual => _leituraAtual;
  int? get cordaSelecionadaIndex => _cordaSelecionadaIndex;
  String? get erro => _erro;
  bool get iniciado => _iniciado;

  String get mensagemStatus {
    if (_erro != null) return 'Ops!';
    final leitura = _leituraAtual;
    if (leitura == null) return 'Toque uma corda...';

    switch (leitura.status) {
      case TuningStatus.tuned:
        return 'Perfeito!';
      case TuningStatus.toolow:
        return 'Um pouco grave';
      case TuningStatus.waytoolow:
        return 'Muito grave';
      case TuningStatus.toohigh:
        return 'Um pouco agudo';
      case TuningStatus.waytoohigh:
        return 'Muito agudo';
      case TuningStatus.undefined:
        return 'Toque uma corda...';
    }
  }

  AfinadorProvider({TunerService? tunerService})
      : _tunerService = tunerService ?? TunerService();

  /// Inicia a captura de áudio e começa a escutar leituras de pitch.
  Future<void> iniciar() async {
    if (_iniciado) return;
    _subscription = _tunerService.readings.listen(_onLeitura);
    try {
      await _tunerService.start();
      _iniciado = true;
    } catch (e) {
      _erro = 'Não foi possível acessar o microfone. '
          'Verifique as permissões do app.';
      notifyListeners();
    }
  }

  /// Atualiza a corda selecionada manualmente pelo usuário.
  void selecionarCorda(int index) {
    if (_cordaSelecionadaIndex == index) return;
    _cordaSelecionadaIndex = index;
    notifyListeners();
  }

  void _onLeitura(TunerReading leitura) {
    _leituraAtual = leitura;
    _cordaSelecionadaIndex =
        _indexParaNota(leitura.note) ?? _cordaSelecionadaIndex;
    notifyListeners(); // avisa só os widgets que dependem desses dados
  }

  int? _indexParaNota(String nota) {
    final String letra = nota.replaceAll(RegExp(r'[0-9]'), '').toUpperCase();
    for (int i = 0; i < cordas.length; i++) {
      final String letraCorda =
          cordas[i].replaceAll(RegExp(r'[0-9]'), '').toUpperCase();
      if (letraCorda == letra) return i;
    }
    return null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _tunerService.dispose();
    super.dispose();
  }
}
