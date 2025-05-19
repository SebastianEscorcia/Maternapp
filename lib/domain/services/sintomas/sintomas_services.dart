import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/sintoma.dart';

class SintomasDiariosService {
  final _db = FirebaseFirestore.instance;

  Future<void> registrarSintomasHoy(
      String maternaUid, List<String> sintomasIds) async {
    final fechaHoy = DateTime.now();
    final idFecha = _formatoFecha(fechaHoy);

    final docRef = _db
        .collection('sintomas_diarios')
        .doc(maternaUid)
        .collection(idFecha)
        .doc('registro');

    await docRef.set({
      'fecha': fechaHoy.toIso8601String(),
      'sintomasIds': sintomasIds,
    });
  }

  Future<RegistroSintomasDiarios> obtenerSintomasHoy(String maternaUid) async {
    final idFecha = _formatoFecha(DateTime.now());

    final docRef = _db
        .collection('sintomas_diarios')
        .doc(maternaUid)
        .collection(idFecha)
        .doc('registro');

    final doc = await docRef.get();

    if (!doc.exists) {
      final data = {
        'fecha': Timestamp.now(),
        'sintomasIds': <String>[],
      };

      await docRef.set(data);
      return RegistroSintomasDiarios.fromMap(docRef.id, data);
    }

    return RegistroSintomasDiarios.fromMap(doc.id, doc.data()!);
  }

  String _formatoFecha(DateTime fecha) {
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<void> subirCatalogoInicialDeSintomas() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final catalogoRef = db.collection('catalogo_sintomas');

    final sintomas = [
      // Síntomas físicos
      {
        "nombre": "Náuseas",
        "categoria": "Síntomas físicos",
        "icono": "sick",
        "color": "#FFA07A"
      },
      {
        "nombre": "Dolor abdominal",
        "categoria": "Síntomas físicos",
        "icono": "crisis_alert",
        "color": "#FF6B6B"
      },
      {
        "nombre": "Dolor de cabeza",
        "categoria": "Síntomas físicos",
        "icono": "headphones",
        "color": "#9C27B0"
      },
      {
        "nombre": "Cansancio",
        "categoria": "Síntomas físicos",
        "icono": "bedtime",
        "color": "#3F51B5"
      },
      {
        "nombre": "Insomnio",
        "categoria": "Síntomas físicos",
        "icono": "nightlight_round",
        "color": "#009688"
      },
      {
        "nombre": "Somnolencia",
        "categoria": "Síntomas físicos",
        "icono": "bed",
        "color": "#607D8B"
      },
      {
        "nombre": "Pechos sensibles",
        "categoria": "Síntomas físicos",
        "icono": "favorite_border",
        "color": "#E91E63"
      },

      // Estado de ánimo
      {
        "nombre": "Ansiedad",
        "categoria": "Estado de ánimo",
        "icono": "mood_bad",
        "color": "#F44336"
      },
      {
        "nombre": "Feliz",
        "categoria": "Estado de ánimo",
        "icono": "sentiment_satisfied_alt",
        "color": "#4CAF50"
      },
      {
        "nombre": "Triste",
        "categoria": "Estado de ánimo",
        "icono": "sentiment_dissatisfied",
        "color": "#607D8B"
      },
      {
        "nombre": "Irritada",
        "categoria": "Estado de ánimo",
        "icono": "warning_amber",
        "color": "#FF5722"
      },
      {
        "nombre": "Con energía",
        "categoria": "Estado de ánimo",
        "icono": "bolt",
        "color": "#FFC107"
      },
      {
        "nombre": "Deprimida",
        "categoria": "Estado de ánimo",
        "icono": "cloud",
        "color": "#9E9E9E"
      },

      // Digestión
      {
        "nombre": "Estreñimiento",
        "categoria": "Digestión",
        "icono": "block",
        "color": "#795548"
      },
      {
        "nombre": "Diarrea",
        "categoria": "Digestión",
        "icono": "water_drop",
        "color": "#00BCD4"
      },
      {
        "nombre": "Acidez",
        "categoria": "Digestión",
        "icono": "local_fire_department",
        "color": "#FF5722"
      },
      {
        "nombre": "Vómitos",
        "categoria": "Digestión",
        "icono": "sync_problem",
        "color": "#8BC34A"
      },
    ];

    for (var sintoma in sintomas) {
      await catalogoRef.add(sintoma);
    }

    print("✅ Catálogo de síntomas cargado exitosamente.");
  }

  // BUTTON DE REGISTRAR SÍNTOMAS
  /*
    ElevatedButton(
                        onPressed: () async {
                         await services.subirCatalogoInicialDeSintomas();
                          Navigator.pop(context);
                        },
                        child: const Text("GUARDAR SINTOMAS"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[300],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
    */
}
