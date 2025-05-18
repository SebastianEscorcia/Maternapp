class Materna {
  final String nombre;
  final int edad;
  final double peso;
  final double estatura;
  final DateTime fum;
  final DateTime fechaEstimadaParto;
  final int semanasGestacion;
  final bool? embarazoActual;
  final bool? esPrimerEmbarazo;
  final String? tipoEmbarazo;
  final bool? tieneAntecedentes;
  final String calendarioId;
  final String uid;
  final List<String> sintomasIds;

  Materna({
    required this.uid,
    required this.nombre,
    required this.edad,
    required this.peso,
    required this.estatura,
    required this.fum,
    required this.fechaEstimadaParto,
    required this.semanasGestacion,
    this.embarazoActual,
    this.esPrimerEmbarazo,
    this.tipoEmbarazo,
    this.tieneAntecedentes,
    this.calendarioId = '',
    this.sintomasIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'edad': edad,
        'peso': peso,
        'estatura': estatura,
        'fum': fum.toIso8601String(),
        'fechaEstimadaParto': fechaEstimadaParto.toIso8601String(),
        'semanasGestacion': semanasGestacion,
        'embarazoActual': embarazoActual,
        'esPrimerEmbarazo': esPrimerEmbarazo,
        'tipoEmbarazo': tipoEmbarazo,
        'tieneAntecedentes': tieneAntecedentes,
        'calendarioId': calendarioId,
        'sintomasIds': sintomasIds,
      };
  factory Materna.fromJson(String uid, Map<String, dynamic> json) {
    return Materna(
      uid: uid,
      nombre: json['nombre'],
      edad: json['edad'],
      peso: (json['peso'] as num).toDouble(),
      estatura: (json['estatura'] as num).toDouble(),
      fum: DateTime.parse(json['fum']),
      fechaEstimadaParto: DateTime.parse(json['fechaEstimadaParto']),
      semanasGestacion: json['semanasGestacion'],
      embarazoActual: json['embarazoActual'],
      esPrimerEmbarazo: json['esPrimerEmbarazo'],
      tipoEmbarazo: json['tipoEmbarazo'],
      tieneAntecedentes: json['tieneAntecedentes'],
      calendarioId: json['calendarioId'],
      sintomasIds: List<String>.from(json['sintomasIds'] ?? []),
    );
  }
  Materna copyWith({
    String? nombre,
    int? edad,
    double? peso,
    double? estatura,
    DateTime? fum,
    DateTime? fechaEstimadaParto,
    int? semanasGestacion,
    bool? embarazoActual,
    bool? esPrimerEmbarazo,
    String? tipoEmbarazo,
    bool? tieneAntecedentes,
    String? calendarioId,
    List<String> sintomasIds = const [],
    String? uid,
  }) {
    return Materna(
      nombre: nombre ?? this.nombre,
      edad: edad ?? this.edad,
      peso: peso ?? this.peso,
      estatura: estatura ?? this.estatura,
      fum: fum ?? this.fum,
      fechaEstimadaParto: fechaEstimadaParto ?? this.fechaEstimadaParto,
      semanasGestacion: semanasGestacion ?? this.semanasGestacion,
      embarazoActual: embarazoActual ?? this.embarazoActual,
      esPrimerEmbarazo: esPrimerEmbarazo ?? this.esPrimerEmbarazo,
      tipoEmbarazo: tipoEmbarazo ?? this.tipoEmbarazo,
      tieneAntecedentes: tieneAntecedentes ?? this.tieneAntecedentes,
      calendarioId: calendarioId ?? this.calendarioId,
      sintomasIds: sintomasIds,
      uid: uid ?? this.uid,
    );
  }
}
