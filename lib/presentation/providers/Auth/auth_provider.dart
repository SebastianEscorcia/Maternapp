import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../domain/services/Firebase/auth_services.dart';

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

    // ✅ Actualizamos el provider con la nueva materna
    maternaProvider.setMaterna(maternaMigrada);
    print("✅ Materna migrada del UID temporal al de Google.");

    // ✅ Eliminamos el documento viejo si el UID anterior era distinto
    if (uidTemporal.isNotEmpty && uidTemporal != uidGoogle) {
      await FirebaseFirestore.instance
          .collection('maternas')
          .doc(uidTemporal)
          .delete();
      print("🗑️ Materna temporal eliminada con UID: $uidTemporal");
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
