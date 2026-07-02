import 'dart:async';
import 'dart:typed_data';

import 'package:autune/model/AudioInput.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class RecordAudioInput implements AudioInput{
  final _audioRecorder = AudioRecorder();
  void Function(Uint8List buffer)? _function;
  StreamSubscription<Uint8List>? _subscription;

  @override
  void onBufferLoaded(void Function(Uint8List buffer) function) {
    _function = function;
  }


  @override
  Future<void> start() async {
    await checkMicPermission();
    final stream = await _audioRecorder.startStream(setUpRecordConfig());
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

  RecordConfig setUpRecordConfig(){
    return const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 44100,
      numChannels: 1,
    );
  }

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _audioRecorder.stop();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _audioRecorder.dispose();
  }

}