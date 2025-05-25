// Archivo: lib/domain/services/vinculacion/codigo_vinculacion_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CodigoVinculacionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'codigos_vinculacion';
  FirebaseFirestore get db => _db;

  /// Genera o actualiza un código de vinculación único para una materna
  Future<String> generarCodigoParaMaterna(String maternaUid) async {
    final String codigo = _generarCodigoUnico();
    final DateTime ahora = DateTime.now();
    final DateTime expiracion = ahora.add(const Duration(minutes: 10));

    await _db.collection(_collection).doc(maternaUid).set({
      'codigo': codigo,
      'maternaUid': maternaUid,
      'creadoEn': ahora.toIso8601String(),
      'expiraEn': expiracion.toIso8601String(),
      'usado': false,
    });

    return codigo;
  }

  /// Valida un código ingresado por un familiar y devuelve el maternaUid si es válido
  Future<String?> validarCodigo(String codigo) async {
    final snapshot = await _db.collection(_collection).get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if ((data['codigo'] ?? '') == codigo) {
        final usado = data['usado'] ?? true;
        final expiraEn = DateTime.tryParse(data['expiraEn'] ?? '');
        if (!usado && expiraEn != null && DateTime.now().isBefore(expiraEn)) {
          return data['maternaUid'];
        }
        break;
      }
    }

    return null;
  }

  /// Marca un código como usado
  Future<void> marcarComoUsado(String codigo) async {
    final snapshot = await _db.collection(_collection).get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if ((data['codigo'] ?? '') == codigo) {
        await doc.reference.update({'usado': true});
        break;
      }
    }
  }

  /// Limpia los códigos expirados
  Future<void> limpiarCodigosExpirados() async {
    final ahora = DateTime.now();
    final snapshot = await _db.collection(_collection).get();

    for (final doc in snapshot.docs) {
      final expiraEn = DateTime.tryParse(doc['expiraEn'] ?? '');
      if (expiraEn != null && ahora.isAfter(expiraEn)) {
        await doc.reference.delete();
      }
    }
  }

  /// Generador de código único tipo ABC123
  String _generarCodigoUnico() {
    const caracteres = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    final random = Uuid().v4().replaceAll('-', '');
    final buffer = StringBuffer();
    for (int i = 0; i < 6; i++) {
      buffer.write(caracteres[random.codeUnitAt(i) % caracteres.length]);
    }
    return buffer.toString();
  }
}
