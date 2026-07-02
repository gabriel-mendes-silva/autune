import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract class AudioInput {
  void onBufferLoaded(void Function(Uint8List buffer) function);
  Future<void> start();
  Future<void> stop();
  void dispose();
}