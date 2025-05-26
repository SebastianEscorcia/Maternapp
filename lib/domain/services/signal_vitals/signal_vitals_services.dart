import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/signal_vital/signal_vital_model.dart';
import '../smartwatch/smartwatch_services.dart';

class SignosVitalesService {
  final SmartwatchServices _smartwatch = SmartwatchServices();
  String _formatoFecha(DateTime fecha) {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<SignosVitales> obtenerSignosDesdeSmartwatch() async {
    final result = await _smartwatch.obtenerSignosVitales();
    print("Datos recibidos del smartwatch: $result");

    if (result.containsKey("error")) {
      throw Exception(result["error"]);
    }

    final fc =
        result['Frecuencia_cardiaca']?.toString() ?? 'No message received';
    final ox = result['Oxigenacion']?.toString() ?? 'No message received';

    return SignosVitales.empty(fc, ox);
  }

  Future<void> guardarSignosVitales(
    SignosVitales signos, {
    void Function(SignosVitales anterior)? onOverwrite,
  }) async {
    final fechaStr = _formatoFecha(signos.fecha);
    final docId = "${signos.maternaId}_$fechaStr";

    final docRef =
        FirebaseFirestore.instance.collection('signos_vitales').doc(docId);

    final snapshot = await docRef.get();

    // Si ya hay un registro, se llama el callback para guardar en historial
    if (snapshot.exists) {
      try {
        final datosPrevios = SignosVitales.fromJson(snapshot.data()!);

        // Guardar en subcolección 'historial'
        final historialRef = docRef.collection('historial').doc();
        await historialRef.set(datosPrevios.toJson());

        // Llamar también al callback local
        if (onOverwrite != null) {
          onOverwrite(datosPrevios);
        }
      } catch (e) {
        print("Error guardando historial previo: $e");
      }
    }

    await docRef.set(signos.toJson());
  }

  // Método para obtener el historial de signos vitales
  Future<List<SignosVitales>> obtenerHistorial(String maternaId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('signos_vitales')
        .doc(maternaId)
        .collection('registros')
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SignosVitales.fromJson(doc.data()))
        .toList();
  }

  Future<List<SignosVitales>> obtenerHistorialGuardadoEnFirebase(
      String maternaId) async {
    final now = DateTime.now();
    final fechaStr = _formatoFecha(now);
    final docId = "${maternaId}_$fechaStr";

    final historialSnap = await FirebaseFirestore.instance
        .collection('signos_vitales')
        .doc(docId)
        .collection('historial')
        .orderBy('fecha')
        .get();

    return historialSnap.docs
        .map((doc) => SignosVitales.fromJson(doc.data()))
        .toList();
  }

  Future<SignosVitales> obtenerDesdeSmartwatch() async {
    final data = await _smartwatch.obtenerSignosVitales();
    return SignosVitales.fromJson(data);
  }

  Future<void> guardarEvaluacionVital({
    required SignosVitales signos,
    required Map<String, String> evaluaciones,
    required bool esMaterna,
  }) async {
    final fecha = DateTime.now();
    final fechaStr =
        "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

    final docId = "${signos.maternaId}_$fechaStr";

    final docRef = FirebaseFirestore.instance
        .collection('evaluaciones_vitales')
        .doc(docId);

    await docRef.set({
      'maternaId': signos.maternaId,
      'fecha': fechaStr,
      'frecuenciaCardiaca': signos.frecuenciaCardiaca,
      'oxigenacion': signos.oxigenacion,
      'temperatura': signos.temperatura,
      'evaluaciones': evaluaciones,
      'esMaterna': esMaterna,
    });
  }

  // método para leer las evaluaciones guardadas
  Future<List<Map<String, dynamic>>> obtenerHistorialEvaluaciones(
      String maternaId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('evaluaciones_vitales')
        .where('maternaId', isEqualTo: maternaId)
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'fecha': data['fecha'] ?? '',
        'frecuenciaCardiaca': data['frecuenciaCardiaca'],
        'oxigenacion': data['oxigenacion'],
        'temperatura': data['temperatura'],
        'evaluaciones': Map<String, String>.from(data['evaluaciones'] ?? {}),
        'esMaterna': data['esMaterna'] ?? true,
      };
    }).toList();
  }
}
