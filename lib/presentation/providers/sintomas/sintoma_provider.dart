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

  /// Historial de síntomas por día
  // Se usa para mostrar el historial de síntomas en la pantalla de selección
  final Map<String, List<String>> _historialPorDia = {};
  Map<String, List<String>> get historialPorDia => _historialPorDia;

  /// Cargar historial del mes actual
  Future<void> cargarHistorialDelMes(String maternaUid) async {
    final hoy = DateTime.now();
    final primerDia = DateTime(hoy.year, hoy.month, 1);
    final ultimoDia = DateTime(hoy.year, hoy.month + 1, 0);

    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('registro')
        .where('fecha', isGreaterThanOrEqualTo: primerDia)
        .where('fecha', isLessThanOrEqualTo: ultimoDia)
        .get();

    _historialPorDia.clear();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final fecha = DateTime.parse(data['fecha']);
      if (fecha.isAfter(primerDia.subtract(const Duration(days: 1))) &&
          fecha.isBefore(ultimoDia.add(const Duration(days: 1)))) {
        final fechaStr =
            "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
        final sintomas = List<String>.from(data['sintomasIds'] ?? []);
        _historialPorDia[fechaStr] = sintomas;
      }
    }

    notifyListeners();
  }

  /// Buscar nombre del síntoma a partir de su ID
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

  /// Cargar catálogo desde Firebase
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

  /// Cargar selección del día
  Future<void> cargarSintomasDeHoy(String maternaUid) async {
    _isLoading = true;
    notifyListeners();

    _registroHoy = await _service.obtenerSintomasHoy(maternaUid);

    _isLoading = false;
    notifyListeners();
  }

  /// Actualizar síntomas seleccionados del día SIN recargar todo el widget
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
    notifyListeners(); // Esto actualiza solo lo necesario
  }

  /// Saber si un síntoma está seleccionado hoy
  bool estaSeleccionadoHoy(String sintomaId) {
    return _registroHoy?.sintomasIds.contains(sintomaId) ?? false;
  }

  /// Obtener síntomas agrupados por categoría
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
}
