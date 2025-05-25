import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/familiar/familiar_model.dart';
import '../../../domain/services/Firebase/auth_services.dart';

import '../../../domain/services/migracion/migracion_service.dart';
import '../../../domain/services/shared_preferences/shared_prefs_service.dart';
import '../familiar/familiar_provider.dart';
import '../maternal_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthServices _authServices;

  User? _user;
  String _errorMessage = '';
  bool _isLoading = true;
  bool _userCancelledLogin = false;
  bool _needsProfileCompletion = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthProvider(this._authServices) {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  //GETTERS
  User? get user => _user;
  String? get errorMesagge => _errorMessage;
  bool get isLoading => _isLoading;
  bool get userCancelledLogin => _userCancelledLogin;
  bool get needsProfileCompletion => _needsProfileCompletion;

  // Iniciar sesión
  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      _userCancelledLogin = false;
      _needsProfileCompletion = false;
      notifyListeners();

      final user = await _authServices.signInWithGoogle(_errorMessage);
      if (user == null) {
        _userCancelledLogin = true;
        _errorMessage = 'No se pudo iniciar sesión';
        return null;
      }

      _user = user; // 🔥 aquí actualizas el usuario autenticado
      return user;
    } catch (e) {
      print('🔥 Error al iniciar sesión: $e');
      if (e.toString().contains('popup_closed')) {
        _userCancelledLogin = true;
        _errorMessage = '';
      } else if (e is FirebaseAuthException) {
        _errorMessage = 'Error: ${e.message}';
      } else {
        _errorMessage = 'Error desconocido al iniciar sesión';
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> migrarMaternaSiExiste({
    required MaternaProvider maternaProvider,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final uidGoogle = user.uid;

    // ✅ Verificamos si ya hay una materna guardada en Firebase con este UID
    final maternaFirebase = await FirebaseFirestore.instance
        .collection('maternas')
        .doc(uidGoogle)
        .get();

    if (maternaFirebase.exists) {
      // ✅ Ya existe, simplemente la cargamos
      await maternaProvider.cargarMaternaFirebase(uidGoogle);
      print(
          "🔄 Materna ya registrada con UID de Google. Cargada correctamente.");
      return;
    }

    // ⚠️ No existe en Firebase, intentamos migrar la local
    final maternaLocal = maternaProvider.materna;
    if (maternaLocal == null) {
      print("❗ No hay materna local para migrar.");
      return;
    }

    final uidTemporal = maternaLocal.uid;

    // ✅ Migramos la materna local al nuevo UID
    final maternaMigrada = maternaLocal.copyWith(uid: uidGoogle);
    await FirebaseFirestore.instance
        .collection('maternas')
        .doc(uidGoogle)
        .set(maternaMigrada.toJson());

    // ✅ Migramos los documentos relacionados
    final migracionService = MigracionService();
    final exito = await migracionService.migrarDocumentosRelacionados(
        uidTemporal, uidGoogle);
    if (!exito) {
      print("⚠️ La migración no fue completamente exitosa.");
    }

    // ✅ Actualizamos el provider con la nueva materna
    maternaProvider.setMaterna(maternaMigrada);
    print("✅ Materna migrada del UID temporal al de Google.");

    // ✅ Actualizamos SharedPreferences
    final prefsService = SharedPrefsService();
    await prefsService.guardarMaternaUid(uidGoogle);
    await prefsService.eliminarMaternaTemporalUid();

    // ✅ Eliminamos el documento viejo si el UID anterior era distinto
    if (uidTemporal.isNotEmpty && uidTemporal != uidGoogle) {
      await FirebaseFirestore.instance
          .collection('maternas')
          .doc(uidTemporal)
          .delete();
      print("🗑️ Materna temporal eliminada con UID: $uidTemporal");
    }
  }

  Future<void> migrarFamiliarSiExiste({
    required FamiliarProvider familiarProvider,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final uidGoogle = user.uid;

    // ✅ Verificamos si ya hay un familiar guardado en Firebase con este UID
    final familiarFirebase = await FirebaseFirestore.instance
        .collection('familiares')
        .doc(uidGoogle)
        .get();

    if (familiarFirebase.exists) {
      // ✅ Ya existe, simplemente lo cargamos
      final cargado = Familiar.fromJson(uidGoogle, familiarFirebase.data()!);
      familiarProvider.setFamiliar(cargado);
      print(
          "🔄 Familiar ya registrado con UID de Google. Cargado correctamente.");
      return;
    }

    // ⚠️ No existe en Firebase, intentamos migrar el local
    final familiarLocal = familiarProvider.familiar;
    if (familiarLocal == null) {
      print("❗ No hay familiar local para migrar.");
      return;
    }

    final uidTemporal = familiarLocal.uId;

    // ✅ Migramos el familiar local al nuevo UID
    final familiarMigrado = familiarLocal.copyWith(uId: uidGoogle);
    await FirebaseFirestore.instance
        .collection('familiares')
        .doc(uidGoogle)
        .set(familiarMigrado.toJson());

    // ✅ Actualizamos el provider con el nuevo familiar
    familiarProvider.setFamiliar(familiarMigrado);
    print("✅ Familiar migrado del UID temporal al de Google.");

    // ✅ Actualizamos SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('familiarUid', uidGoogle);
    if (uidTemporal != null && uidTemporal != uidGoogle) {
      await prefs.remove('familiarTemporalUid');
    }

    // ✅ Eliminamos el documento viejo si el UID anterior era distinto
    if (uidTemporal != null && uidTemporal != uidGoogle) {
      await FirebaseFirestore.instance
          .collection('familiares')
          .doc(uidTemporal)
          .delete();
      print("🗑️ Familiar temporal eliminado con UID: $uidTemporal");
    }
  }

  Future<void> signOut() async {
    await _authServices.signOut();
    _isLoading = false;
    _user = null;
    print("Usuario actual: ${_user?.uid}");
    _needsProfileCompletion = false;
    notifyListeners();
  }
}
