import 'package:flutter/material.dart';

import '../../../core/utils/dialog_buttom_vitals/evaluador_signos.dart';
import '../../../data/models/signal_vital/signal_vital_model.dart';
import '../../../domain/services/signal_vitals/signal_vitals_services.dart';

class SignosVitalesProvider with ChangeNotifier {
  final SignosVitalesService _servicio = SignosVitalesService();
  Map <String,dynamic> nodosConectados = {};
  List<SignosVitales> _historial = [];
  List<SignosVitales> get historial => _historial;

  SignosVitales? _signos;
  SignosVitales? get signos => _signos;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _mensajeEvaluacion;
  String? get mensajeEvaluacion => _mensajeEvaluacion;

  final List<Map<String, dynamic>> _historialEvaluaciones = [];
  List<Map<String, dynamic>> get historialEvaluaciones =>
      _historialEvaluaciones;
  

  Future<bool> verificarConexiones() async {
    try {
      nodosConectados = await _servicio.obtenerNodosConectados();
      if (nodosConectados.isEmpty) {
        throw Exception(
            "No tiene ningún smartwatch vinculado. Por favor, vincule uno.");
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<void> actualizarSignos(String maternaId,
      {required bool esMaterna}) async {
    _cargando = true;
    notifyListeners();

    try {
      final nuevosSignos = await _servicio.obtenerSignosDesdeSmartwatch();

      // ✅ Validación de los datos recibidos
      if (nuevosSignos.frecuenciaCardiaca == "No disponible" ||
          nuevosSignos.oxigenacion == "No disponible") {
        throw Exception(
            "La medicion de los signos vitales no fue exitosa. Intentelo nuevamente.");
      }

      // ✅ Asignar el ID antes de guardar
      final signosConId = SignosVitales(
        maternaId: maternaId,
        frecuenciaCardiaca: nuevosSignos.frecuenciaCardiaca,
        oxigenacion: nuevosSignos.oxigenacion,
        temperatura: nuevosSignos.temperatura,
        fecha: nuevosSignos.fecha,
      );

      _signos = signosConId;

      await _servicio.guardarSignosVitales(
        signosConId,
        onOverwrite: agregarAlHistorialLocal,
      );

      final evaluador = EvaluadorSignosVitales(esMaterna: esMaterna);

      final mensajeFC = evaluador.evaluarFrecuenciaCardiaca(
          double.tryParse(signosConId.frecuenciaCardiaca) ?? 0);
      final mensajeOx = evaluador
          .evaluarOxigenacion(double.tryParse(signosConId.oxigenacion) ?? 0);
      final mensajeTemp = evaluador.evaluarTemperatura(signosConId.temperatura);

      final evaluaciones = {
        'frecuenciaCardiaca': mensajeFC,
        'oxigenacion': mensajeOx,
        'temperatura': mensajeTemp,
      };

      await _servicio.guardarEvaluacionVital(
        signos: signosConId,
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

  Future<void> actualizarSignosSimulados(String maternaId,
      {required bool esMaterna}) async {
    _cargando = true;
    notifyListeners();

    try {
      final signosSimulados =
          await _servicio.obtenerSignosSimulados(maternaId: maternaId);
      _signos = signosSimulados;

      await _servicio.guardarSignosVitales(
        signosSimulados,
        onOverwrite: agregarAlHistorialLocal,
      );

      final evaluador = EvaluadorSignosVitales(esMaterna: esMaterna);

      final mensajeFC = evaluador.evaluarFrecuenciaCardiaca(
          double.tryParse(signosSimulados.frecuenciaCardiaca) ?? 0);
      final mensajeOx = evaluador.evaluarOxigenacion(
          double.tryParse(signosSimulados.oxigenacion) ?? 0);
      final mensajeTemp =
          evaluador.evaluarTemperatura(signosSimulados.temperatura);

      final evaluaciones = {
        'frecuenciaCardiaca': mensajeFC,
        'oxigenacion': mensajeOx,
        'temperatura': mensajeTemp,
      };

      await _servicio.guardarEvaluacionVital(
        signos: signosSimulados,
        evaluaciones: evaluaciones,
        esMaterna: esMaterna,
      );

      _mensajeEvaluacion = "$mensajeFC\n$mensajeOx\n$mensajeTemp";
    } catch (e) {
      print("Error en simulación: $e");
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

  //HISTORIAL DE SIGNOS VITALES
  Future<void> cargarHistorialFirebase(String maternaId) async {
    try {
      _historial =
          await _servicio.obtenerHistorialGuardadoEnFirebase(maternaId);
      notifyListeners();
    } catch (e) {
      print("Error al cargar historial desde Firebase: $e");
    }
  }

  // EVALACUACIONES CUANDO SE TOMEN LOS SIGNOS VITALES
  Future<List<Map<String, dynamic>>> cargarHistorialEvaluaciones(
      String maternaId) async {
    try {
      final data = await _servicio.obtenerHistorialEvaluaciones(maternaId);
      _historialEvaluaciones.clear();
      _historialEvaluaciones.addAll(data);
      print("✅ Evaluaciones cargadas: ${_historialEvaluaciones.length}");
      notifyListeners();
      return data;
    } catch (e) {
      print("Error al cargar historial de evaluaciones: $e");
      return []; // Para que el FutureBuilder avance
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
