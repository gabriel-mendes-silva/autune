import 'dart:typed_data';

import 'package:autune/model/frequency_receiver.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

/// Implementação de [FrequencyReceiver] baseada no algoritmo YIN do pacote
/// `pitch_detector_dart`.
///
/// Diferente da versão anterior (que criava seu próprio `AudioRecorder`
/// internamente, duplicando a responsabilidade de `RecordAudioInput`), esta
/// classe é "burra" quanto à captura: ela só recebe buffers PCM16 mono já
/// prontos via [processarBuffer] — tipicamente vindos de um `AudioInput` —
/// e mantém a última frequência detectada disponível através de
/// [calculateCurrentFrequency].
///
/// Para uma solução completa de afinador (frequência + nota + desvio em
/// cents), veja `TunerService` em `lib/services/tuner_service.dart`, que
/// combina esta detecção de pitch com o pacote `pitchupdart`.
class PitchDetectorDartReceiver implements FrequencyReceiver {
  final PitchDetector _pitchDetectorDart;
  double _ultimaFrequencia = 0;

  /// [sampleRate] deve bater com o `sampleRate` configurado no
  /// `RecordConfig` usado pela captura de áudio (44100 Hz, no nosso caso).
  PitchDetectorDartReceiver({int sampleRate = 44100, int bufferSize = 2000})
      : _pitchDetectorDart = PitchDetector(
          audioSampleRate: sampleRate.toDouble(),
          bufferSize: bufferSize,
        );

  /// Processa um buffer de áudio PCM16 mono e atualiza a frequência atual
  /// caso um pitch tenha sido identificado nesse trecho.
  Future<void> processarBuffer(Uint8List buffer) async {
    final result = await _pitchDetectorDart.getPitchFromIntBuffer(buffer);
    if (result.pitched) {
      _ultimaFrequencia = result.pitch;
    }
  }

  @override
  double calculateCurrentFrequency() => _ultimaFrequencia;
}
