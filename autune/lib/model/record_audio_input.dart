import 'dart:async';
import 'dart:typed_data';

import 'package:autune/model/AudioInput.dart';
import 'package:record/record.dart';

class RecordAudioInput implements AudioInput {
  final _audioRecorder = AudioRecorder();
  void Function(Uint8List buffer)? _function;
  StreamSubscription<Uint8List>? _subscription;

  // Evita chamadas concorrentes/duplicadas de start/stop/dispose, que são a
  // causa mais comum do erro nativo "Recorder has not yet been created or
  // has already been disposed." ao trocar de tela rapidamente.
  bool _gravando = false;
  bool _descartado = false;

  @override
  void onBufferLoaded(void Function(Uint8List buffer) function) {
    _function = function;
  }

  @override
  Future<void> start() async {
    if (_gravando || _descartado) return;
    await checkMicPermission();
    final stream = await _audioRecorder.startStream(setUpRecordConfig());
    _gravando = true;
    _subscription = stream.listen((chunk) {
      final buffer = Uint8List.fromList(chunk);
      _function?.call(buffer);
    });
  }

  Future<void> checkMicPermission() async {
    if (!await _audioRecorder.hasPermission()) {
      throw Exception('Permissão de microfone não concedida.');
    }
  }

  RecordConfig setUpRecordConfig() {
    return const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 44100,
      numChannels: 1,
    );
  }

  @override
  Future<void> stop() async {
    if (!_gravando) return;
    _gravando = false;
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _audioRecorder.stop();
    } catch (_) {
      // O gravador nativo já pode ter sido parado/descartado (ex: usuário
      // trocou de aba rapidamente); não há nada a fazer nesse caso.
    }
  }

  @override
  void dispose() {
    if (_descartado) return;
    _descartado = true;
    _gravando = false;
    _subscription?.cancel();
    try {
      _audioRecorder.dispose();
    } catch (_) {
      // Idem: descartar um gravador já descartado não deve derrubar o app.
    }
  }
}
