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
      throw Exception(
          "Conecte el Smartwatch a su teléfono e intente nuevamente");
    }
  }

  // Obtener signos vitales
  Future<Map<String, dynamic>> obtenerSignosVitales() async {
    try {
      await enviarMensajeAlReloj();
      final nodes = await obtenerNodosConectados();

      if (nodes.isEmpty) {
        throw Exception(
            "No tiene ningún smartwatch vinculado. Por favor, vincule uno.");
      }

      final response = await onMessageReceived.first;
      debugPrint('Respuesta del smartwatch: $response');
      final signos = response.split(";");

      //Si se recibe el mensaje nunca será null o vacío, llegarán los signos vitales o dira "No disponible"//
      //por lo que no es necesario validar si signos es null o vacío//
      //no se está recibiendo la temperatura, para que validarla?//
      final fc = signos[0];
      final ox = signos[1];
      final temp = 36.5;

      //Aqui si validamos si los signos son "No disponible"//
      //lo que significaría que la medición no fue exitosa y se lanza la excepcion//
      if (fc == "No disponible" || ox == "No disponible") {
        throw Exception(
            "La medicion de los signos vitales no fue exitosa. Intentelo nuevamente.");
      }

      //si llega al return significa que los signos son válidos//
      return {
        "Frecuencia_cardiaca": fc,
        "Oxigenacion": ox,
        "Temperatura": temp,
      };
    } catch (e) {
      debugPrint('Ups! algo salió mal $e');
      return {"error": "Ups! algo salió mal: $e"};
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
