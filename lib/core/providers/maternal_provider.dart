import 'package:flutter/material.dart';
import 'package:maternapp/data/models/maternal_model.dart';

class MaternaProvider with ChangeNotifier {
  Materna? _materna;

  Materna? get materna => _materna;

  void setMaterna(Materna nueva) {
    _materna = nueva;
    notifyListeners();
  }

  void clear() {
    _materna = null;
    notifyListeners();
  }
}