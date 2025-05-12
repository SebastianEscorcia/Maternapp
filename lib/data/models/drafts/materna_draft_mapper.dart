import 'package:maternapp/data/models/drafts/maternal_draft.dart';
import '../maternal_model.dart';

extension MaternaDraftMapper on MaternaDraft {
  Materna toMaterna() {
    final fechaActual = DateTime.now();
    final edad = (anioNacimiento != null)
        ? fechaActual.year - anioNacimiento!
        : 0;

    final fumCalculada = fum ?? fechaActual;
    final semanas = fechaActual.difference(fumCalculada).inDays ~/ 7;
    final fechaEstimada = fumCalculada.add(const Duration(days: 280));
    
    return Materna(
      uid: uId ?? '',
      nombre: nombre ?? '',
      edad: edad,
      peso: peso ?? 0.0,
      estatura: estatura ?? 0.0,
      fum: fumCalculada,
      fechaEstimadaParto: fechaEstimada,
      semanasGestacion: semanas,
      embarazoActual: embarazoActual,
      esPrimerEmbarazo: esPrimerEmbarazo,
      tipoEmbarazo: tipoEmbarazo,
      tieneAntecedentes: tieneAntecedentes,
      calendarioId: calendarId ?? '',
    );
  }
}
