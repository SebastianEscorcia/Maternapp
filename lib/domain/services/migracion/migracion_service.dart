import 'package:cloud_firestore/cloud_firestore.dart';

class MigracionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  /*
  Future<void> migrarDocumentosRelacionados(
    String uidAntiguo,
    String uidNuevo,
  ) async {
    final sintomasRef = _db.collection('registros_diarios');
    final calendarsRef = _db.collection('calendars');
    final maternasRef = _db.collection('maternas');

    // 🔄 Migrar síntomas diarios (cambiar UID + renombrar documento)
    final sintomasSnapshot =
        await sintomasRef.where('maternaUid', isEqualTo: uidAntiguo).get();

    for (final doc in sintomasSnapshot.docs) {
      final data = doc.data();

      final fecha = (data['fecha'] as Timestamp).toDate();
      final sintomasIds = List<String>.from(data['sintomasIds'] ?? []);

      final fechaStr =
          "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
      final nuevoDocId = "${uidNuevo}_$fechaStr";

      // Crear nuevo documento con nuevo UID en el ID
      await sintomasRef.doc(nuevoDocId).set({
        'maternaUid': uidNuevo,
        'fecha': Timestamp.fromDate(fecha),
        'sintomasIds': sintomasIds,
      });

      // Eliminar documento antiguo
      await doc.reference.delete();
    }

    // 🔄 Migrar calendarios
    final calendariosSnapshot =
        await calendarsRef.where('maternaId', isEqualTo: uidAntiguo).get();

    for (final doc in calendariosSnapshot.docs) {
      await doc.reference.update({'maternaId': uidNuevo});
    }

    // 🔄 Actualizar campo calendarioId dentro de la nueva materna
    final maternaVieja = await maternasRef.doc(uidAntiguo).get();
    if (maternaVieja.exists && maternaVieja.data()?['calendarioId'] != null) {
      final calendarioId = maternaVieja.data()!['calendarioId'];
      await maternasRef.doc(uidNuevo).update({
        'calendarioId': calendarioId,
      });
    }

    print(
        "✅ Todos los documentos relacionados han sido migrados y renombrados correctamente.");
  } */

  Future<bool> migrarDocumentosRelacionados(
    String uidAntiguo,
    String uidNuevo,
  ) async {
    final sintomasRef = _db.collection('registros_diarios');
    final calendarsRef = _db.collection('calendars');
    final maternasRef = _db.collection('maternas');

    try {
      // 🔄 Migrar síntomas diarios (renombrando documento)
      final sintomasSnapshot =
          await sintomasRef.where('maternaUid', isEqualTo: uidAntiguo).get();

      for (final doc in sintomasSnapshot.docs) {
        final data = doc.data();

        final fecha = (data['fecha'] as Timestamp).toDate();
        final sintomasIds = List<String>.from(data['sintomasIds'] ?? []);

        final fechaStr =
            "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
        final nuevoDocId = "${uidNuevo}_$fechaStr";

        await sintomasRef.doc(nuevoDocId).set({
          'maternaUid': uidNuevo,
          'fecha': Timestamp.fromDate(fecha),
          'sintomasIds': sintomasIds,
        });

        await doc.reference.delete();
      }

      // 🔄 Migrar calendarios
      final calendariosSnapshot =
          await calendarsRef.where('maternaId', isEqualTo: uidAntiguo).get();

      for (final doc in calendariosSnapshot.docs) {
        await doc.reference.update({'maternaId': uidNuevo});
      }

      // 🔄 Copiar calendarioId a la nueva materna
      final maternaVieja = await maternasRef.doc(uidAntiguo).get();
      if (maternaVieja.exists && maternaVieja.data()?['calendarioId'] != null) {
        final calendarioId = maternaVieja.data()!['calendarioId'];
        await maternasRef.doc(uidNuevo).update({
          'calendarioId': calendarioId,
        });
      }

      print(
          "✅ Todos los documentos relacionados han sido migrados correctamente.");
      return true;
    } catch (e, stack) {
      print("❌ Error al migrar documentos relacionados: $e");
      print(stack);
      return false;
    }
  }
}
