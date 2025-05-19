import 'package:flutter/services.dart';

class SmartwatchServices {
  static const MethodChannel _channel = MethodChannel('smartwatch_channel');

  Future<Map<String, dynamic>> obtenerSignosVitales() async {
    final result = await _channel.invokeMethod<Map>('obtenerSignosVitales');
    return Map<String, dynamic>.from(result!);
  }
}
