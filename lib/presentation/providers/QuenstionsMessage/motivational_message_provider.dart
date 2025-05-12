import 'package:flutter/material.dart';

class MotivationalMessageProvider extends ChangeNotifier {
  final List<String> _mensajes = [
    "✨ Cada paso que das es un acto de amor hacia tu bebé",
    "🌸 Tu embarazo es una hermosa historia que se escribe día a día",
    "💖 Estás creando vida, ¡qué maravillosa eres!",
    "🌈 Este viaje de 9 meses te transformará para siempre",
    "🍃 Respira, confía y deja que la naturaleza haga su magia",
    "✨ Llevas dentro el regalo más precioso del universo",
  ];

  String? _mensajeActual;
  int? _ultimoIndex;

  String get mensajeActual => _mensajeActual ?? _mensajes.first;

  void actualizarMensaje() {
    int nuevoIndex = _generarIndexDiferente();
    _mensajeActual = _mensajes[nuevoIndex];
    _ultimoIndex = nuevoIndex;
    notifyListeners();
  }

  int _generarIndexDiferente() {
    final total = _mensajes.length;
    final random = DateTime.now().microsecondsSinceEpoch % total;
    if (random == _ultimoIndex) {
      return (random + 1) % total;
    }
    return random;
  }
}
