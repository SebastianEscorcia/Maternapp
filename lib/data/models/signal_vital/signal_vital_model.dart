class SignosVitales {
  final String maternaId;
  final String frecuenciaCardiaca;
  final double temperatura;
  final String oxigenacion;
  final DateTime fecha;

  SignosVitales({
    required this.maternaId,
    required this.frecuenciaCardiaca,
    required this.temperatura,
    required this.oxigenacion,
    required this.fecha,
  });

  factory SignosVitales.fromJson(Map<String, dynamic> json) {
    return SignosVitales(
      maternaId: json['maternaId'],
      frecuenciaCardiaca: json['frecuenciaCardiaca'],
      temperatura: json['temperatura'].toDouble(),
      oxigenacion: json['oxigenacion'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
  SignosVitales.empty(String f, String o)
      : maternaId = '',
        frecuenciaCardiaca = f,
        temperatura = 0.0,
        oxigenacion = o,
        fecha = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'maternaId': maternaId,
      'frecuenciaCardiaca': frecuenciaCardiaca,
      'temperatura': temperatura,
      'oxigenacion': oxigenacion,
      'fecha': fecha.toIso8601String(),
    };
  }
}
