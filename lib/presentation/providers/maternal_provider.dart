import 'package:flutter/foundation.dart';

import 'package:maternapp/data/models/maternal_model.dart';

import '../../data/models/calendar_model.dart';
import '../../data/models/drafts/maternal_draft.dart';
import '../../domain/services/calendar_services.dart';
import '../../domain/services/maternal_services.dart';

class MaternaProvider with ChangeNotifier {
  Materna? _materna;
  Materna? get materna => _materna;
  final MaternalService _maternalService;
  final CalendarService _calendarService;
  bool _isLoading = false;
  String? _error;
  MaternalService get maternalService => _maternalService;
  CalendarService get calendarService => _calendarService;

  bool get isLoading => _isLoading;
  String? get error => _error;
  /* MaternaProvider({required MaternalService maternalService}) {
    _maternalService = maternalService;
  }*/

  MaternaProvider(
      {required MaternalService maternalService,
      required CalendarService calendarService})
      : _maternalService = maternalService,
        _calendarService = calendarService;
  // Inyección del servicio
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

  void actualizarDatos({required double peso, required double estatura}) {
    if (_materna == null) return;

    _materna = Materna(
        nombre: _materna!.nombre,
        edad: _materna!.edad,
        peso: peso,
        estatura: estatura,
        fum: _materna!.fum,
        fechaEstimadaParto: _materna!.fechaEstimadaParto,
        semanasGestacion: _materna!.semanasGestacion,
        embarazoActual: _materna!.embarazoActual,
        esPrimerEmbarazo: _materna!.esPrimerEmbarazo,
        tipoEmbarazo: _materna!.tipoEmbarazo,
        tieneAntecedentes: _materna!.tieneAntecedentes,
        uid: _materna!.uid);

    notifyListeners();
  }

  Future<void> cargarMaternaFirebase(String uid) async {
    _isLoading = true;
    notifyListeners();
    try {
      print("🌀 Buscando materna con UID: $uid");
      _materna = await _maternalService.obternerMaterna(uid);
      print("✅ Materna encontrada: ${_materna?.nombre}");
      _error = null;
    } catch (e) {
      _error = 'Error al cargar la materna $e';
      if (kDebugMode) print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> crearOActualizarMaternaFirebase(
      MaternaDraft draft, CalendarModel calendar) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (draft.uId != null && draft.uId!.isNotEmpty) {
        final existe = await _maternalService.obternerMaterna(draft.uId!);
        if (existe != null) {
          await _maternalService.actualizarMaternaFirebase(draft, calendar);
          return draft.uId!;
        }
      }

      final newUid =
          await _maternalService.crearMaternaFirebase(draft, calendar);
      draft.uId = newUid;
      return newUid;
    } catch (e) {
      _error = 'Error al guardar la materna $e';
      if (kDebugMode) print(_error);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
