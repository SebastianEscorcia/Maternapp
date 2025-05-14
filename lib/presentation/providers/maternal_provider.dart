  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/widgets.dart';

  import 'package:maternapp/data/models/maternal_model.dart';
  import 'package:provider/provider.dart';

  import '../../data/models/calendar_model.dart';
  import '../../data/models/drafts/maternal_draft.dart';
  import '../../domain/services/calendar_services.dart';
  import '../../domain/services/maternal_services.dart';
  import 'calendar_provider.dart';

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

    Future<void> actualizarFUMDesdeCalendario(BuildContext context) async {
      if (_materna == null) return;

      final calendarProvider =
          Provider.of<CalendarProvider>(context, listen: false);
      final nuevaFUM = calendarProvider.selectedDay;
      final parto = calendarProvider.dueDate;
      final semanas = calendarProvider.weeksPregnant;

      if (nuevaFUM == null || parto == null) return;

      // Actualizamos en memoria
      _materna = _materna!.copyWith(
        fum: nuevaFUM,
        fechaEstimadaParto: parto,
        semanasGestacion: semanas,
      );

      notifyListeners();

      // Actualizamos en Firebase
      await _maternalService.actualizarFUMyPartoEnMaterna(
        uid: _materna!.uid,
        nuevaFUM: nuevaFUM,
        fechaEstimadaParto: parto,
        semanasGestacion: semanas,
      );
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
      if (draft.uId == null || draft.uId!.isEmpty) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          draft.uId = user.uid;
        }
      }
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

    Future<void> guardarCambiosMaternaFirebase(BuildContext context) async {
      if (_materna == null || _materna!.uid.isEmpty) {
        if (kDebugMode) print("❌ No se puede guardar: UID de materna vacío.");
        return;
      }

      _isLoading = true;
      notifyListeners();

      try {
        final draft = MaternaDraft.fromMaterna(_materna!);

        //  Obteniendo el calendar model del provider
        final calendarProvider =
            Provider.of<CalendarProvider>(context, listen: false);
        final calendar = calendarProvider.model;

        await _maternalService.actualizarMaternaFirebase(draft, calendar);
      } catch (e) {
        _error = 'Error al guardar en Firebase: $e';
        if (kDebugMode) print(_error);
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
