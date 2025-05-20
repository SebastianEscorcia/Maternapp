import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../../data/models/signal_vital/signal_vital_model.dart';
import '../smartwatch/smartwatch_services.dart';

class SignosVitalesService {
  final SmartwatchServices _smartwatch = SmartwatchServices();

  Future<SignosVitales> obtenerSignosDesdeSmartwatch() async {
    try {
      final result = await _smartwatch.obtenerSignosVitales();
      var f =
          result['Frecuencia_cardiaca']?.toString() ?? 'No message received';
      final signos = SignosVitales.empty(f);
      return signos;
      //return SignosVitales.fromJson(Map<String, dynamic>.from(result!));
    } catch (e) {
      log("Error al obtener signos vitales: $e");
      rethrow;
    }
  }

  // Método para guardar los signos vitales en Firestore
  Future<void> guardarSignosVitales(SignosVitales signos) async {
    final docRef = FirebaseFirestore.instance
        .collection('signos_vitales')
        .doc(signos.maternaId)
        .collection('registros')
        .doc(signos.fecha.toIso8601String());

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

  Future<SignosVitales> obtenerDesdeSmartwatch() async {
    final data = await _smartwatch.obtenerSignosVitales();
    return SignosVitales.fromJson(data);
  }
}
