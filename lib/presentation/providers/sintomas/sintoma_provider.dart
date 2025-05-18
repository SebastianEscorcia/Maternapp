import 'package:flutter/material.dart';
import '../../../data/models/sintoma.dart';
import '../../../domain/services/sintomas/sintomas_services.dart';
import '../../widgets/sintoma/sintoma_visual.dart';

class SintomaProvider with ChangeNotifier {
  final SintomaService _service = SintomaService();

  List<Sintoma> _sintomas = [];
  bool _isLoading = false;

  List<Sintoma> get sintomas => _sintomas;
  bool get isLoading => _isLoading;

  Future<void> cargarSintomasDeMaterna(String maternaUid) async {
    _isLoading = true;
    notifyListeners();

    _sintomas = await _service.obtenerSintomasDeMaterna(maternaUid);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarSintoma(Sintoma sintoma) async {
    await _service.registrarSintoma(sintoma);
    await cargarSintomasDeMaterna(sintoma.maternaUid);
  }

  Sintoma? get ultimoSintoma => _sintomas.isNotEmpty ? _sintomas.first : null;

  final Map<String, List<SintomaVisual>> sintomasVisualesPorCategoria = {
    "Síntomas físicos": [
      SintomaVisual(nombre: "Náuseas", icono: Icons.sick, color: Colors.orange),
      SintomaVisual(
          nombre: "Dolor abdominal",
          icono: Icons.crisis_alert,
          color: Colors.redAccent),
      SintomaVisual(
          nombre: "Dolor de cabeza",
          icono: Icons.headphones,
          color: Colors.purple),
      SintomaVisual(
          nombre: "Cansancio", icono: Icons.bedtime, color: Colors.indigo),
      SintomaVisual(
          nombre: "Insomnio",
          icono: Icons.nightlight_round,
          color: Colors.teal),
      SintomaVisual(
          nombre: "Somnolencia", icono: Icons.bed, color: Colors.blueGrey),
      SintomaVisual(
          nombre: "Pechos sensibles",
          icono: Icons.favorite_border,
          color: Colors.pinkAccent),
    ],
    "Estado de ánimo": [
      SintomaVisual(
          nombre: "Ansiedad", icono: Icons.mood_bad, color: Colors.red),
      SintomaVisual(
          nombre: "Feliz",
          icono: Icons.sentiment_satisfied_alt,
          color: Colors.green),
      SintomaVisual(
          nombre: "Triste",
          icono: Icons.sentiment_dissatisfied,
          color: Colors.blueGrey),
      SintomaVisual(
          nombre: "Irritada",
          icono: Icons.warning_amber,
          color: Colors.deepOrange),
      SintomaVisual(
          nombre: "Con energía", icono: Icons.bolt, color: Colors.amber),
      SintomaVisual(
          nombre: "Deprimida", icono: Icons.cloud, color: Colors.grey),
    ],
    "Digestión": [
      SintomaVisual(
          nombre: "Estreñimiento", icono: Icons.block, color: Colors.brown),
      SintomaVisual(
          nombre: "Diarrea", icono: Icons.water_drop, color: Colors.cyan),
      SintomaVisual(
          nombre: "Acidez",
          icono: Icons.local_fire_department,
          color: Colors.deepOrangeAccent),
      SintomaVisual(
          nombre: "Vómitos",
          icono: Icons.sync_problem,
          color: Colors.greenAccent),
    ]
  };

  Future<void> eliminarSintomaPorDescripcion({
    required String uid,
    required String descripcion,
  }) async {
    final sintomasAEliminar =
        _sintomas.where((s) => s.descripcion == descripcion).toList();

    for (final s in sintomasAEliminar) {
      await _service.eliminarSintoma(s.id, uid); 
    }

    await cargarSintomasDeMaterna(uid);
  }
}
