import 'package:flutter/material.dart';
import 'package:maternapp/data/models/drafts/maternal_draft.dart';

class MaternaDraftProvider with ChangeNotifier {
  final MaternaDraft _draft = MaternaDraft();
  MaternaDraft get draft => _draft;

  void updateNombre(String nombre) {
    _draft.nombre = nombre;
    notifyListeners();
  }

  void updateAnioNacimiento(int year) {
    _draft.anioNacimiento = year;
    notifyListeners();
  }

  void updatePeso(double peso) {
    _draft.peso = peso;
    notifyListeners();
  }

  void updateEstatura(double estatura) {
    _draft.estatura = estatura;
    notifyListeners();
  }

  void updateFUM(DateTime fum) {
    _draft.fum = fum;
    notifyListeners();
  }

  void updateEmbarazoActual(bool val) {
    _draft.embarazoActual = val;
    notifyListeners();
  }

  void updateEsPrimerEmbarazo(bool val) {
    _draft.esPrimerEmbarazo = val;
    notifyListeners();
  }

  void updateTipoEmbarazo(String val) {
    _draft.tipoEmbarazo = val;
    notifyListeners();
  }

  void updateTieneAntecedentes(bool val) {
    _draft.tieneAntecedentes = val;
    notifyListeners();
  }
}