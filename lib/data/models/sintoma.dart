import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroSintomasDiarios {
  final String id;
  final DateTime fecha;
  final List<String> sintomasIds;

  RegistroSintomasDiarios({
    required this.id,
    required this.fecha,
    required this.sintomasIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha.toIso8601String(),
      'sintomasIds': sintomasIds,
    };
  }

  factory RegistroSintomasDiarios.fromMap(String id, Map<String, dynamic> map) {
    return RegistroSintomasDiarios(
      id: id,
      //si viene como Timestamp de Firestore, lo convierte con .toDate(). Si es String, intenta convertirlo con DateTime.tryParse(...). Si falla, usa DateTime.now().
      fecha: map['fecha'] is Timestamp
          ? (map['fecha'] as Timestamp).toDate()
          : DateTime.tryParse(map['fecha'] ?? '') ?? DateTime.now(),
      sintomasIds: map['sintomasIds'] != null
          ? List<String>.from(map['sintomasIds'])
          : <String>[],
    );
  }
}
