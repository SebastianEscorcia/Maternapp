class SignosVitales {
  final String maternaId;
  final String frecuenciaCardiaca;
  final double temperatura;
  final int oxigenacion;
  final DateTime fecha;

  SignosVitales({
    required this.maternaId,
    required this.frecuenciaCardiaca,
    required this.temperatura,
    required this.oxigenacion,
    required this.fecha,
  });
  SignosVitales.empty(String f)
      : maternaId = '',
        frecuenciaCardiaca = f,
        temperatura = 0.0,
        oxigenacion = 0,
        fecha = DateTime.now();

  factory SignosVitales.fromJson(Map<String, dynamic> json) {
    return SignosVitales(
      maternaId: json['maternaId'],
      frecuenciaCardiaca: json['Frecuencia_cardiaca'],
      temperatura: json['temperatura'].toDouble() ??
          json['temperatura']?.toDouble() ??
          0.0,
      oxigenacion: json['oxigenacion'] ?? json['oxigenacion'] ?? 0,
      fecha: DateTime.parse(json['fecha']),
    );
  }

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
