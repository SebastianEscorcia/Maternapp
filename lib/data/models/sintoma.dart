class Sintoma {
  final String id;
  final String descripcion;
  final DateTime fecha;
  final String maternaUid;

  Sintoma({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.maternaUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'maternaUid': maternaUid,
    };
  }

  factory Sintoma.fromMap(String id, Map<String, dynamic> map) {
    return Sintoma(
      id: id,
      descripcion: map['descripcion'] ?? '',
      fecha: DateTime.parse(map['fecha']),
      maternaUid: map['maternaUid'],
    );
  }
}
