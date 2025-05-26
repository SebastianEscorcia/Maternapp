import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SmartwatchServices {
  static final SmartwatchServices _instance = SmartwatchServices._internal();
  factory SmartwatchServices() => _instance;
  SmartwatchServices._internal() {
    platform.setMethodCallHandler(_handleNativeMessage);
  }

  static const platform = MethodChannel('com.example.watch/wearable');
  final StreamController<String> _messageController =
      StreamController.broadcast();

  // Escuchar mensajes desde cualquier parte de la app
  Stream<String> get onMessageReceived => _messageController.stream;

  Future<void> _handleNativeMessage(MethodCall call) async {
    if (call.method == "onMessageReceived") {
      final message = call.arguments as String;
      _messageController.add(message);
    }
  }

  // Enviar mensaje al reloj para iniciar el diagnóstico
  Future<void> enviarMensajeAlReloj() async {
    try {
      await platform.invokeMethod('sendMessage', {
        "message": "Start diagnosis",
      });
    } catch (e, s) {
      debugPrint('Error enviando mensaje al reloj: $e');
      debugPrint('$s');
      throw Exception("Conecte el Smartwatch a su teléfono e intente nuevamente");
    }
  }

  // Obtener signos vitales
  Future<Map<String, dynamic>> obtenerSignosVitales() async {
    try {
      await enviarMensajeAlReloj();
      var nodes = await obtenerNodosConectados();

      if (nodes.isEmpty) {
        return {"mensaje": "No tiene ningun Smartwatch conectado"};
      }
      // Espera la primera respuesta recibida
      final response = await onMessageReceived.first;

      return {"Frecuencia_cardiaca": response, "oxigenacion": response};
    } catch (e) {
      debugPrint('Error en comunicación con el reloj: $e');
      return {
        "error": "Conecte el Smartwatch a su teléfono e intente nuevamente"
      };
    }
  }

  // Obtener nodos conectados
  Future<List<Map<String, dynamic>>> obtenerNodosConectados() async {
    try {
      final nodes = await platform.invokeMethod('getConnectedNodes');
      if (nodes == null) {
        return [];
      }
      final nodeList = (nodes as List)
          .map((node) => Map<String, dynamic>.from(node as Map))
          .toList();
      return nodeList;
    } catch (e, s) {
      debugPrint('Error obteniendo nodos conectados: $e');
      debugPrint('$s');
      return [];
    }
  }
}
