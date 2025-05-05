import 'package:maternapp/data/models/calendar_model.dart';
import 'package:maternapp/data/models/drafts/materna_draft_mapper.dart';
import 'package:maternapp/data/models/drafts/maternal_draft.dart';
import 'package:maternapp/data/models/maternal_model.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class MaternalService {
  final String _maternaCollection = 'maternas';
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Materna construirMaterna(MaternaDraft draft, CalendarModel calendar) {
    return Materna(
      nombre: draft.nombre!,
      edad: DateTime.now().year - draft.anioNacimiento!,
      peso: draft.peso!,
      estatura: draft.estatura!,
      fum: calendar.selectedDay!,
      fechaEstimadaParto:
          calendar.dueDate ?? calendar.selectedDay!.add(Duration(days: 280)),
      semanasGestacion: calendar.weeksPregnant,
      embarazoActual: draft.embarazoActual,
      esPrimerEmbarazo: draft.esPrimerEmbarazo,
      tipoEmbarazo: draft.tipoEmbarazo,
      tieneAntecedentes: draft.tieneAntecedentes,
      uid: draft.uId ?? '',
    );
  }

  Future<String> crearMaternaFirebase(
      MaternaDraft draft, CalendarModel calendar) async {
    final uid =
        draft.uId ?? FirebaseFirestore.instance.collection('maternas').doc().id;

    final materna = construirMaterna(draft, calendar);
    final maternaData = materna.toJson();

    await FirebaseFirestore.instance
        .collection('maternas')
        .doc(uid)
        .set(maternaData, SetOptions(merge: false));

    return uid;
  }

  Future<void> actualizarMaternaFirebase(
      MaternaDraft draft, CalendarModel calendar) async {
    try {
      final materna = construirMaterna(draft, calendar);
      final maternaData = materna.toJson();
      await _firestore
          .collection(_maternaCollection)
          .doc(draft.uId)
          .set(maternaData, SetOptions(merge: true));
    } catch (e) {
      print("Error al actualizar materna");
      rethrow;
    }
  }

  Future<Materna?> obternerMaterna(String uid) async {
    final doc = await _firestore.collection(_maternaCollection).doc(uid).get();
    if (doc.exists) {
      return Materna.fromJson(uid, doc.data()!);
    }
    return null;
  }

  Stream<Materna?> streamMaterna(String uid) {
    return _firestore.collection(_maternaCollection).doc(uid).snapshots().map(
        (snapshot) =>
            snapshot.exists ? Materna.fromJson(uid, snapshot.data()!) : null);
  }
}
