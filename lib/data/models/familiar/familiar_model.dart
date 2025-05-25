class Familiar {
  final String? idMaterna;
  final String nombre;
  final int edad;
  final String? uId;
  final String? codigoVinculacion;

  Familiar({
    required this.nombre,
    required this.edad,
    required this.uId,
    this.idMaterna = '',
    this.codigoVinculacion,
  });

  factory Familiar.fromJson(String uId, Map<String, dynamic> json) {
    return Familiar(
      nombre: json['nombre'],
      edad: json['edad'],
      uId: uId,
      idMaterna: json['idMaterna'],
      codigoVinculacion: json['codigoVinculacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'edad': edad,
      'uId': uId,
      'idMaterna': idMaterna,
      'codigoVinculacion': codigoVinculacion,
    };
  }

  Familiar copyWith({
    String? nombre,
    int? edad,
    String? uId,
    String? idMaterna,
    String? codigoVinculacion,
  }) {
    return Familiar(
      nombre: nombre ?? this.nombre,
      edad: edad ?? this.edad,
      uId: uId ?? this.uId,
      idMaterna: idMaterna ?? this.idMaterna,
      codigoVinculacion: codigoVinculacion ?? this.codigoVinculacion,
    );
  }
}
