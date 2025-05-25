// Archivo: lib/presentation/providers/vinculacion/codigo_vinculacion_provider.dart

import 'package:flutter/material.dart';
import '../../../domain/services/codigo_vinculacion/codigo_vinculacion_services.dart';

class CodigoVinculacionProvider with ChangeNotifier {
  final CodigoVinculacionService _service;

  String? _codigoGenerado;
  bool _isLoading = false;
  String? _error;

  CodigoVinculacionProvider(this._service);

  String? get codigoGenerado => _codigoGenerado;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Genera o actualiza el código de vinculación de la materna
  Future<void> generarCodigo(String maternaUid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _codigoGenerado = await _service.generarCodigoParaMaterna(maternaUid);
    } catch (e) {
      _error = "Error al generar el código";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Consulta el código actual de una materna (si ya fue generado)
  Future<void> cargarCodigoExistente(String maternaUid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final doc = await _service.db
          .collection('codigos_vinculacion')
          .doc(maternaUid)
          .get();

      if (doc.exists) {
        _codigoGenerado = doc.data()?['codigo'];
      } else {
        _codigoGenerado = null;
      }
    } catch (e) {
      _error = "No se pudo cargar el código.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarEstado() {
    _codigoGenerado = null;
    _error = null;
    notifyListeners();
  }
}
