import 'dart:async';
import 'dart:typed_data';

import 'package:autune/model/AudioInput.dart';
import 'package:autune/model/record_audio_input.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:pitchupdart/tuning_status.dart';

/// Taxa de amostragem usada na captura (bate com o `RecordConfig` de
/// [RecordAudioInput]) e tamanho, em amostras, da janela analisada a cada
/// detecção de pitch. Os valores seguem o exemplo oficial do pacote
/// pitch_detector_dart (https://pub.dev/packages/pitch_detector_dart).
const int tunerSampleRate = 44100;
const int tunerBufferSizeSamples = 2000;

// Áudio PCM16 mono = 2 bytes por amostra.
const int _bytesPorAmostra = 2;
const int _bytesPorJanela = tunerBufferSizeSamples * _bytesPorAmostra;

/// Uma leitura já processada do afinador: nota mais próxima, frequência
/// detectada (Hz), desvio em cents (-50 a +50, negativo = grave, positivo =
/// agudo) e o status de afinação retornado pelo pacote `pitchupdart`.
class TunerReading {
  final String note;
  final double frequency;
  final double cents;
  final TuningStatus status;

  const TunerReading({
    required this.note,
    required this.frequency,
    required this.cents,
    required this.status,
  });
}

/// Orquestra três peças:
/// 1. Captura de áudio do microfone ([AudioInput]/[RecordAudioInput]);
/// 2. Detecção de pitch (algoritmo YIN, via `pitch_detector_dart`);
/// 3. Checagem de afinação de violão (via `pitchupdart`);
///
/// e expõe tudo como um [Stream] de [TunerReading], pronto para a UI
/// (ex: [AfinadorPage]) consumir com um simples `listen`.
class TunerService {
  final AudioInput _audioInput;
  late final PitchDetector _pitchDetector;
  late final PitchHandler _pitchHandler;

  final StreamController<TunerReading> _controller =
      StreamController<TunerReading>.broadcast();

  final List<int> _bufferAcumulado = [];
  bool _processando = false;
  bool _iniciado = false;

  TunerService({AudioInput? audioInput})
      : _audioInput = audioInput ?? RecordAudioInput() {
    _pitchDetector = PitchDetector(
      audioSampleRate: tunerSampleRate.toDouble(),
      bufferSize: tunerBufferSizeSamples,
    );
    _pitchHandler = PitchHandler(InstrumentType.guitar);
  }

  /// Stream de leituras processadas. Um novo evento é emitido sempre que
  /// um trecho de áudio contém um pitch identificável e correspondente a
  /// uma nota de violão.
  Stream<TunerReading> get readings => _controller.stream;

  /// Pede permissão de microfone (se necessário) e começa a escutar o
  /// áudio. Lança uma [Exception] se a permissão for negada.
  Future<void> start() async {
    if (_iniciado) return;
    _bufferAcumulado.clear();
    _audioInput.onBufferLoaded(_onBuffer);
    try {
      await _audioInput.start();
      _iniciado = true;
    } catch (e) {
      _iniciado = false;
      rethrow;
    }
  }

  Future<void> stop() async {
    if (!_iniciado) return;
    _iniciado = false;
    await _audioInput.stop();
  }

  /// Para a captura (se estiver rodando) e só então libera os recursos.
  /// Chamar [stop] e [dispose] em sequência dentro de um único método evita
  /// a corrida entre as duas chamadas assíncronas que causava o erro nativo
  /// "Recorder has not yet been created or has already been disposed."
  Future<void> dispose() async {
    await stop();
    _audioInput.dispose();
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }

  Future<void> _onBuffer(Uint8List chunk) async {
    _bufferAcumulado.addAll(chunk);

    // Processa uma janela por vez; se já houver uma detecção em andamento,
    // apenas continua acumulando bytes até a próxima chamada.
    if (_processando || _bufferAcumulado.length < _bytesPorJanela) return;

    _processando = true;
    try {
      final Uint8List janela = Uint8List.fromList(
        _bufferAcumulado.take(_bytesPorJanela).toList(),
      );
      _bufferAcumulado.removeRange(0, _bytesPorJanela);

      final resultadoPitch =
          await _pitchDetector.getPitchFromIntBuffer(janela);
      if (!resultadoPitch.pitched) return;

      final resultadoAfinacao =
          await _pitchHandler.handlePitch(resultadoPitch.pitch);

      final String? notaDetectada = resultadoAfinacao.note;
      if (notaDetectada == null || _controller.isClosed) return;

      _controller.add(TunerReading(
        note: notaDetectada,
        frequency: resultadoPitch.pitch,
        cents: resultadoAfinacao.diffCents.toDouble(),
        status: resultadoAfinacao.tuningStatus,
      ));
    } finally {
      _processando = false;
    }
  }
}
