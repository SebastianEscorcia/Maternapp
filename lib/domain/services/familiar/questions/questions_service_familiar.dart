
import '../../../../data/models/familiar/familiar_model.dart';


class FamiliarQuestionService {

  /// Valida los datos del familiar antes de guardarlos
  String? validarFormulario(Familiar familiar) {
  if (familiar.nombre.isEmpty) return "Por favor, ingresa tu nombre.";
  if (familiar.edad <= 0) return "La edad debe ser mayor a 0.";
  if (familiar.edad <= 10) return "La edad parece muy baja para registrarse.";
  if (familiar.codigoVinculacion == null || familiar.codigoVinculacion!.length != 6) {
    return "El código de vinculación debe tener 6 caracteres.";
  }
  return null;
}

}
