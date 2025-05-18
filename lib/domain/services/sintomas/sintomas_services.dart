import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/sintoma.dart';

class SintomaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String sintomasCollection = 'sintomas';
  final String maternasCollection = 'maternas';

  Future<void> registrarSintoma(Sintoma sintoma) async {
    final batch = _db.batch();

    final sintomasRef = _db.collection(sintomasCollection).doc();
    final maternaRef =
        _db.collection(maternasCollection).doc(sintoma.maternaUid);

    // Agrega el nuevo síntoma
    batch.set(sintomasRef, sintoma.toMap());

    // Agrega su ID al array de materna
    batch.update(maternaRef, {
      'sintomasIds': FieldValue.arrayUnion([sintomasRef.id])
    });

    await batch.commit();
  }

  Future<List<Sintoma>> obtenerSintomasDeMaterna(String maternaUid) async {
    final query = await _db
        .collection(sintomasCollection)
        .where('maternaUid', isEqualTo: maternaUid)
        .orderBy('fecha', descending: true)
        .get();

    return query.docs
        .map((doc) => Sintoma.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> eliminarSintoma(String sintomaId, String maternaUid) async {
    final batch = _db.batch();

    final sintomaRef = _db.collection('sintomas').doc(sintomaId);
    final maternaRef = _db.collection('maternas').doc(maternaUid);

    batch.delete(sintomaRef);
    batch.update(maternaRef, {
      'sintomasIds': FieldValue.arrayRemove([sintomaId]),
    });

    await batch.commit();
  }
}
