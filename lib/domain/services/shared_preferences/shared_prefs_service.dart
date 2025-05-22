import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _maternaUidKey = 'maternaUid';
  static const String _maternaTemporalUidKey = 'maternaTemporalUid';
  static const String _calendarioUidKey = 'calendarioUid';

  /// Guarda el UID de la materna autenticada
  Future<void> guardarMaternaUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_maternaUidKey, uid);
  }

  /// Obtiene el UID de la materna actual
  Future<String?> obtenerMaternaUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_maternaUidKey);
  }

  /// Guarda un UID temporal de materna
  Future<void> guardarMaternaTemporalUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_maternaTemporalUidKey, uid);
  }

  /// Obtiene el UID temporal
  Future<String?> obtenerMaternaTemporalUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_maternaTemporalUidKey);
  }

  /// Borra el UID temporal
  Future<void> eliminarMaternaTemporalUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_maternaTemporalUidKey);
  }

  /// Guarda el UID del calendario
  Future<void> guardarCalendarioUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calendarioUidKey, uid);
  }

  /// Obtiene el UID del calendario
  Future<String?> obtenerCalendarioUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_calendarioUidKey);
  }

  /// Limpia todos los valores guardados
  Future<void> limpiarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Solo recarga los valores en memoria
  Future<void> recargar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }
}
