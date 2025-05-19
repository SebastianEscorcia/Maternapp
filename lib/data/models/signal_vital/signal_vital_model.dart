class SignosVitales {
  final String maternaId;
  final int frecuenciaCardiaca;
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

  factory SignosVitales.fromJson(Map<String, dynamic> json) {
    return SignosVitales(
      maternaId: json['maternaId'],
      frecuenciaCardiaca: json['frecuenciaCardiaca'],
      temperatura: json['temperatura'].toDouble(),
      oxigenacion: json['oxigenacion'],
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
