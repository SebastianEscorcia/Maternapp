import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/signal_vital/signal_vital_model.dart';
import '../smartwatch/smartwatch_services.dart';

class SignosVitalesService {
  final SmartwatchServices _smartwatch = SmartwatchServices();
  String _formatoFecha(DateTime fecha) {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<SignosVitales> obtenerSignosDesdeSmartwatch() async {
    //metemos el codigo en un try-catch para capturar la excepción
    try {
      final result = await _smartwatch.obtenerSignosVitales();
      print("Datos recibidos del smartwatch: $result");

      // Procesamos el map
      final fc = result['Frecuencia_cardiaca'].toString();
      final ox = result['Oxigenacion'].toString();
      final temp = result['Temperatura'].toDouble();

      // Usamos el constructor que recibe los valores
      return SignosVitales.empty(fc, ox, temp);
    } catch (e) {
      print("Error al obtener signos desde el smartwatch: $e");
      rethrow; // Puedes lanzar de nuevo la excepción o retornar un valor por defecto si lo prefieres
    }
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

    print("Guardando signos vitales: $signos");
    await docRef.set(signos.toJson());
  }

  Future<SignosVitales> obtenerSignosSimulados(
      {required String maternaId}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula espera

    return SignosVitales(
      maternaId: maternaId,
      frecuenciaCardiaca: "85", // bpm
      temperatura: 36.6, // °C
      oxigenacion: "98", // %
      fecha: DateTime.now(),
    );
  }

  // Método para obtener el historial de signos vitales
  Future<List<SignosVitales>> obtenerHistorialGuardadoEnFirebase(
      String maternaId) async {
    final signosCollection =
        FirebaseFirestore.instance.collection('signos_vitales');

    // Filtrar todos los documentos que comiencen con el ID de la materna
    final querySnapshot =
        await signosCollection.where('maternaId', isEqualTo: maternaId).get();

    List<SignosVitales> historialCompleto = [];

    for (final doc in querySnapshot.docs) {
      final historialSnap = await signosCollection
          .doc(doc.id)
          .collection('historial')
          .orderBy('fecha')
          .get();

      for (final histDoc in historialSnap.docs) {
        historialCompleto.add(SignosVitales.fromJson(histDoc.data()));
      }
    }

    return historialCompleto;
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
