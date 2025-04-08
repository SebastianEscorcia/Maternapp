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

  Materna({
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
      };
  factory Materna.fromJson(Map<String, dynamic> json) {
    return Materna(
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
    );
  }
}
