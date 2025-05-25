import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/familiar/familiar_model.dart';

class FamiliarService {
  final String _collection = 'familiares';
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Familiar construirFamiliar(Familiar base, String idMaterna) {
    final String uid = base.uId ?? FirebaseAuth.instance.currentUser?.uid ?? _firestore.collection(_collection).doc().id;
    return base.copyWith(
      uId: uid,
      idMaterna: idMaterna,
    );
  }

  Future<String> guardarFamiliar(Familiar familiar) async {
    final uid = familiar.uId!;
    await _firestore.collection(_collection).doc(uid).set(familiar.toJson());
    return uid;
  }

  Future<void> actualizarFamiliar(Familiar familiar) async {
    await _firestore.collection(_collection).doc(familiar.uId).set(
      familiar.toJson(),
      SetOptions(merge: true),
    );
  }

  Future<Familiar?> obtenerFamiliar(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists) {
      return Familiar.fromJson(uid, doc.data()!);
    }
    return null;
  }

  Future<Familiar> prepararYGuardarFamiliar(Familiar familiar, String idMaterna) async {
    final familiarFinal = construirFamiliar(familiar, idMaterna);
    await guardarFamiliar(familiarFinal);
    return familiarFinal;
  }
  Future<Familiar?> cargarFamiliarFirebase(String uid) async {
  return await obtenerFamiliar(uid);
}
}
