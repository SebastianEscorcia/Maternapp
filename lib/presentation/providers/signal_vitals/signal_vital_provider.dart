import 'package:flutter/material.dart';

import '../../../core/utils/dialog_buttom_vitals/evaluador_signos.dart';
import '../../../data/models/signal_vital/signal_vital_model.dart';
import '../../../domain/services/signal_vitals/signal_vitals_services.dart';

class SignosVitalesProvider with ChangeNotifier {
  final SignosVitalesService _servicio = SignosVitalesService();

  List<SignosVitales> _historial = [];
  List<SignosVitales> get historial => _historial;

  SignosVitales? _signos;
  SignosVitales? get signos => _signos;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _mensajeEvaluacion;
  String? get mensajeEvaluacion => _mensajeEvaluacion;

  List<Map<String, dynamic>> _historialEvaluaciones = [];
  List<Map<String, dynamic>> get historialEvaluaciones =>
      _historialEvaluaciones;

  Future<void> cargarHistorialEvaluaciones(String maternaId) async {
    _historialEvaluaciones =
        await _servicio.obtenerHistorialEvaluaciones(maternaId);
    notifyListeners();
  }

  Future<void> actualizarSignos(String maternaId,
      {required bool esMaterna}) async {
    _cargando = true;
    notifyListeners();

    try {
      final nuevosSignos = await _servicio.obtenerSignosDesdeSmartwatch();

      _signos = nuevosSignos;
      //final fc = nuevosSignos.frecuenciaCardiaca;
      //final ox = nuevosSignos.oxigenacion;

      // Validar si los datos son correctos ******* esta validacion estaba mal hecha, se puede mantener pero debe refactorizarse**********
      /*if (fc == "No message received" || ox == "No message received") {
        throw Exception(
            "Smartwatch no está conectado o no envió datos válidos");
      }*/

      //****** aqui no es necesario crear un nuevo objeto porque el metodo obtenerSignosDesdeSmartwatch() devuelve el objeto creado */
      /*_signos = SignosVitales(
        maternaId: maternaId,
        frecuenciaCardiaca: fc,
        temperatura: nuevosSignos.temperatura,
        oxigenacion: ox,
        fecha: DateTime.now(),
      );*/

      await _servicio.guardarSignosVitales(
        nuevosSignos!,
        onOverwrite: agregarAlHistorialLocal,
      );

      final evaluador = EvaluadorSignosVitales(esMaterna: esMaterna);

      final mensajeFC = evaluador.evaluarFrecuenciaCardiaca(
          double.tryParse(nuevosSignos.frecuenciaCardiaca) ?? 0);
      final mensajeOx = evaluador
          .evaluarOxigenacion(double.tryParse(nuevosSignos.oxigenacion) ?? 0);
      final mensajeTemp = evaluador.evaluarTemperatura(_signos!.temperatura);

      final evaluaciones = {
        'frecuenciaCardiaca': mensajeFC,
        'oxigenacion': mensajeOx,
        'temperatura': mensajeTemp,
      };

      await _servicio.guardarEvaluacionVital(
        signos: _signos!,
        evaluaciones: evaluaciones,
        esMaterna: esMaterna,
      );

      _mensajeEvaluacion = "$mensajeFC\n$mensajeOx\n$mensajeTemp";
    } catch (e) {
      print("Error al obtener signos vitales: $e");
      _signos = null;
      rethrow;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void agregarAlHistorialLocal(SignosVitales previos) {
    _historial.add(previos);
    notifyListeners();
  }

  Future<void> cargarHistorial(String maternaId) async {
    try {
      _historial = await _servicio.obtenerHistorial(maternaId);
      notifyListeners();
    } catch (e) {
      print("Error al cargar historial de signos: $e");
    }
  }

  Future<void> cargarHistorialFirebase(String maternaId) async {
    try {
      _historial =
          await _servicio.obtenerHistorialGuardadoEnFirebase(maternaId);
      notifyListeners();
    } catch (e) {
      print("Error al cargar historial desde Firebase: $e");
    }
  }

  Map<String, List<Map<String, dynamic>>> agruparEvaluacionesPorMes() {
    final Map<String, List<Map<String, dynamic>>> agrupado = {};

    for (final item in _historialEvaluaciones) {
      final fecha = item['fecha'] ?? '';
      final partes = fecha.split('-'); // formato: YYYY-MM-DD
      if (partes.length >= 2) {
        final mes = '${partes[0]}-${partes[1]}'; // Ej: 2025-05
        agrupado.putIfAbsent(mes, () => []).add(item);
      }
    }

    // Ordenar los registros de cada mes por día descendente
    agrupado.forEach((key, value) {
      value.sort((a, b) => b['fecha'].compareTo(a['fecha']));
    });

    return agrupado;
  }
}
