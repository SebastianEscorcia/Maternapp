import '../maternal_model.dart';

class MaternaDraft {
  String? nombre;
  int? anioNacimiento;
  double? peso;
  double? estatura;
  bool? embarazoActual;
  bool? esPrimerEmbarazo;
  String? tipoEmbarazo;
  bool? tieneAntecedentes;
  DateTime? fum;
  String? uId;
  String? calendarId;
  MaternaDraft({
    this.nombre,
    this.anioNacimiento,
    this.peso,
    this.estatura,
    this.embarazoActual,
    this.esPrimerEmbarazo,
    this.tipoEmbarazo,
    this.tieneAntecedentes,
    this.uId,
  });
  factory MaternaDraft.fromMaterna(Materna materna) {
    return MaternaDraft(
      nombre: materna.nombre,
      anioNacimiento: DateTime.now().year - materna.edad,
      peso: materna.peso,
      estatura: materna.estatura,
      embarazoActual: materna.embarazoActual,
      esPrimerEmbarazo: materna.esPrimerEmbarazo,
      tipoEmbarazo: materna.tipoEmbarazo,
      tieneAntecedentes: materna.tieneAntecedentes,
      uId: materna.uid,
    );
  }
}
