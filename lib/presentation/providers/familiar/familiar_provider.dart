// FamiliarProvider adaptado para funcionar con el servicio actualizado y ser usado desde onFinalizarFamiliar

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/familiar/familiar_model.dart';
import '../../../domain/services/codigo_vinculacion/codigo_vinculacion_services.dart';
import '../../../domain/services/familiar/familiar_services.dart';
import '../../../domain/services/familiar/questions/questions_service_familiar.dart';

class FamiliarProvider with ChangeNotifier {
  Familiar? _familiar;
  Familiar? get familiar => _familiar;

  late FamiliarService _familiarService;
  late CodigoVinculacionService _codigoService;
  final FamiliarQuestionService _questionService = FamiliarQuestionService();

  void setService(FamiliarService service) {
    _familiarService = service;
  }

  void setCodigoService(CodigoVinculacionService service) {
    _codigoService = service;
  }

  void setFamiliar(Familiar familiar) {
    _familiar = familiar;
    notifyListeners();
  }

  void clear() {
    _familiar = null;
    notifyListeners();
  }

  void updateNombre(String nombre) {
    if (_familiar != null) {
      _familiar = _familiar!.copyWith(nombre: nombre);
      notifyListeners();
    }
  }

  void updateEdad(int edad) {
    if (_familiar != null) {
      _familiar = _familiar!.copyWith(edad: edad);
      notifyListeners();
    }
  }

  void updateCodigoVinculacion(String codigo) {
    if (_familiar != null) {
      _familiar = _familiar!.copyWith(codigoVinculacion: codigo);
      notifyListeners();
    }
  }

  void inicializarFamiliar(String? uid) {
    _familiar = Familiar(nombre: "", edad: 0, uId: uid, codigoVinculacion: "");
    notifyListeners();
  }

  Future<void> validarVincularYGuardar() async {
    if (_familiar == null) throw Exception("Familiar no definido");

    final error = _questionService.validarFormulario(_familiar!);
    if (error != null) throw Exception(error);

    final codigo = _familiar!.codigoVinculacion;
    if (codigo == null || codigo.isEmpty) {
      throw Exception("El código de vinculación es requerido");
    }

    final maternaUid = await _codigoService.validarCodigo(codigo);
    if (maternaUid == null) {
      throw Exception("El código es inválido o ya expiró");
    }

    _familiar =
        await _familiarService.prepararYGuardarFamiliar(_familiar!, maternaUid);
    await _codigoService.marcarComoUsado(codigo);
    notifyListeners();
  }

  Future<void> cargarFamiliarDesdePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('familiarUid');
    if (uid != null && uid.isNotEmpty) {
      final cargado = await _familiarService.obtenerFamiliar(uid);
      if (cargado != null) {
        _familiar = cargado;
        notifyListeners();
      }
    }
  }

  Future<void> cargarFamiliarFirebase(String uid) async {
    final cargado = await _familiarService.cargarFamiliarFirebase(uid);
    if (cargado != null) {
      _familiar = cargado;
      notifyListeners();
    }
  }
}
