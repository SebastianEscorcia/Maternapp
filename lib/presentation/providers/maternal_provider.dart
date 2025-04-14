import 'package:flutter/material.dart';
import 'package:maternapp/data/models/maternal_model.dart';

import '../../data/models/calendar_model.dart';
import '../../data/models/drafts/maternal_draft.dart';
import '../../domain/services/maternal_services.dart';

class MaternaProvider with ChangeNotifier {
  Materna? _materna;
  Materna? get materna => _materna;
  final MaternalService _maternalService;
  /* MaternaProvider({required MaternalService maternalService}) {
    _maternalService = maternalService;
  }*/
 MaternaProvider({required MaternalService maternalService})
    : _maternalService = maternalService; // Inyección del servicio 
  void setMaterna(Materna nueva) {
    _materna = nueva;
    notifyListeners();
  }

  void clear() {
    _materna = null;
    notifyListeners();
  }

  void crearMaterna({
    required MaternaDraft draft,
    required CalendarModel calendar,
  }) {
    final materna = _maternalService.construirMaterna(draft, calendar);
    setMaterna(materna);
  }
}
