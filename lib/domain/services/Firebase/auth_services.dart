import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthServices {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithGoogle(String mensaje) async {
    try {
      final googleSignIn = GoogleSignIn(
        // Solo se necesita clientId en móviles si se configuró en consola
        clientId: !kIsWeb ? dotenv.env['GOOGLE_CLIENT_ID'] : null,
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      mensaje = 'Error al iniciar sesión con Google: ${e.message}';
      return null;
    } catch (e) {
      mensaje = 'Error desconocido: $e';
      return null;
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? dotenv.env['GOOGLE_CLIENT_ID'] : null,
    );

    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
