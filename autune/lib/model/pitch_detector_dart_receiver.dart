import 'dart:typed_data';

import 'package:autune/model/frequency_receiver.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

class PitchDetectorDartReceiver implements FrequencyReceiver{
  final _audioRecorder = AudioRecorder();
  final _pitchDetectorDart = PitchDetector(bufferSize: 44100, audioSampleRate: 2000);

  Future<void> iniciar() async {
    final stream = await _audioRecorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        numChannels: 1,
        sampleRate: 44100,
      ),
    );

    // O stream entrega chunks de bytes; você acumula/agrupa e passa pro detector
    stream.listen((chunk) async {
      final buffer = Uint8List.fromList(chunk);
      final result = await _pitchDetectorDart.getPitchFromIntBuffer(buffer);

      if (result.pitched) {
        print('Frequência: ${result.pitch} Hz');
      }
    });
  }

  @override
  double calculateCurrentFrequency() {
    // TODO: implement getCurrentFrequency
    return 0;
  }


}