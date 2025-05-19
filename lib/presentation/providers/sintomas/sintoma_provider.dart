import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/sintoma.dart';
import '../../../domain/services/sintomas/sintomas_services.dart';
import '../../widgets/sintoma/sintoma_visual.dart';

class SintomaProvider with ChangeNotifier {
  final SintomasDiariosService _service = SintomasDiariosService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<SintomaVisual> _catalogo = [];
  RegistroSintomasDiarios? _registroHoy;
  bool _isLoading = false;
  bool _guardandoSeleccion = false;

  List<SintomaVisual> get catalogo => _catalogo;
  RegistroSintomasDiarios? get registroHoy => _registroHoy;
  bool get isLoading => _isLoading;
  bool get guardandoSeleccion => _guardandoSeleccion;

  final Map<String, List<String>> _historialPorDia = {};
  Map<String, List<String>> get historialPorDia => _historialPorDia;

  //future para evitar múltiples cargas
  Future<void>? _historialFuture;
  Future<void>? get historialFuture => _historialFuture;

  // Método de cacheado de historial
  Future<void> cargarHistorialDelMesConCache(String maternaUid) {
    _historialFuture ??= () async {
      if (_catalogo.isEmpty) {
        await cargarCatalogo();
      }
      await cargarHistorialDelMes(maternaUid);
    }();
    return _historialFuture!;
  }

  //consultar síntomas del mes día por día
  Future<void> cargarHistorialDelMes(String maternaUid) async {
    final hoy = DateTime.now();
    final primerDia = DateTime(hoy.year, hoy.month, 1);
    final ultimoDia = DateTime(hoy.year, hoy.month + 1, 0);

    _historialPorDia.clear();

    for (int i = 0; i <= ultimoDia.difference(primerDia).inDays; i++) {
      final fecha = primerDia.add(Duration(days: i));
      final fechaId =
          "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

      final registroDoc = await _db
          .collection('sintomas_diarios')
          .doc(maternaUid)
          .collection(fechaId)
          .doc('registro')
          .get();

      if (registroDoc.exists) {
        final data = registroDoc.data();
        if (data != null) {
          final sintomas = List<String>.from(data['sintomasIds'] ?? []);
          _historialPorDia[fechaId] = sintomas;
        }
      }
    }

    notifyListeners();
  }

  String nombreSintomaPorId(String id) {
    return _catalogo
        .firstWhere((s) => s.id == id,
            orElse: () => SintomaVisual(
                id: "Desconocido",
                categoria: 'Otros',
                nombre: 'Desconocido',
                icono: Icons.help,
                color: Colors.grey))
        .nombre;
  }

  Color colorSintomaPorId(String id) {
    return _catalogo
        .firstWhere((s) => s.id == id,
            orElse: () => SintomaVisual(
                id: "desconocido",
                categoria: 'Otros',
                nombre: 'Desconocido',
                icono: Icons.help,
                color: Colors.grey))
        .color;
  }

  Future<void> cargarCatalogo() async {
    try {
      final snapshot = await _db.collection('catalogo_sintomas').get();
      _catalogo = snapshot.docs.map((doc) {
        final data = doc.data();
        return SintomaVisual.fromFirestore(doc.id, data);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error al cargar catálogo: $e");
    }
  }

  Future<void> cargarSintomasDeHoy(String maternaUid) async {
    _isLoading = true;
    notifyListeners();

    _registroHoy = await _service.obtenerSintomasHoy(maternaUid);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarSintomasDeHoy(
      String maternaUid, List<String> sintomasIds) async {
    _guardandoSeleccion = true;
    notifyListeners();

    await _service.registrarSintomasHoy(maternaUid, sintomasIds);

    _registroHoy = RegistroSintomasDiarios(
      id: maternaUid,
      fecha: DateTime.now(),
      sintomasIds: sintomasIds,
    );

    _guardandoSeleccion = false;
    notifyListeners();
  }

  bool estaSeleccionadoHoy(String sintomaId) {
    return _registroHoy?.sintomasIds.contains(sintomaId) ?? false;
  }

  Map<String, List<SintomaVisual>> get sintomasPorCategoria {
    final mapa = <String, List<SintomaVisual>>{};
    for (var sintoma in _catalogo) {
      mapa.putIfAbsent(sintoma.categoria, () => []).add(sintoma);
    }
    return mapa;
  }

  Future<void> inicializarDatosSiNecesario(String maternaUid) async {
    if (_catalogo.isEmpty) {
      await cargarCatalogo();
    }
    if (_registroHoy == null) {
      await cargarSintomasDeHoy(maternaUid);
    }
  }

  // Resetear el historial  recarga manual
  void limpiarCacheHistorial() {
    _historialFuture = null;
  }
}
