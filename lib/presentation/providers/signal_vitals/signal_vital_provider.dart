import 'package:flutter/material.dart';

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

  Future<void> actualizarSignos(String maternaId) async {
    _cargando = true;
    notifyListeners();

    try {
      final nuevosSignos = await _servicio.obtenerSignosDesdeSmartwatch();

      _signos = SignosVitales(
        maternaId: maternaId,
        frecuenciaCardiaca: nuevosSignos.frecuenciaCardiaca,
        temperatura: nuevosSignos.temperatura,
        oxigenacion: nuevosSignos.oxigenacion,
        fecha: DateTime.now(),
      );

      await _servicio.guardarSignosVitales(_signos!);
    } catch (e) {
      print("Error al obtener signos vitales: $e");
      _signos = null;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarHistorial(String maternaId) async {
    try {
      _historial = await _servicio.obtenerHistorial(maternaId);
      notifyListeners();
    } catch (e) {
      print("Error al cargar historial de signos: $e");
    }
  }
}
