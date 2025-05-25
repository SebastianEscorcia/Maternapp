import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Routes/routes.dart';
import '../../../../domain/services/questions_service_materna.dart';
import '../../../providers/calendar_provider.dart';
import '../../../providers/maternal_draft_provider.dart';

Future<void> onFinalizar(BuildContext context) async {
  final draftProvider =
      Provider.of<MaternaDraftProvider>(context, listen: false);
  final calendarProvider =
      Provider.of<CalendarProvider>(context, listen: false);
  final questionService = context.read<QuestionService>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset(
                'assets/animations/loading_heart.json',
                repeat: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Guardando tu información...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );

  try {
    final mensajeError = questionService.validarFormulario(
        draftProvider.draft, calendarProvider.model);
    if (mensajeError != null) {
      Navigator.pop(context); // Cierra el modal de carga
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children:  [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                ' $mensajeError',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
      return; 
    }
    await questionService.guardarMaternaYCalendario(
      draft: draftProvider.draft,
      calendar: calendarProvider.model,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('maternaUid', draftProvider.draft.uId!);
    await prefs.setString('calendarioUid', calendarProvider.model.uId);
    await prefs.setString('maternaTemporalUid', draftProvider.draft.uId!);
    await prefs.reload();

    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Lottie.asset(
                  'assets/animations/success.json',
                  repeat: false,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "¡Perfecto!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF4B8A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tus datos se han guardado correctamente. ¡Comienza tu maravilloso viaje!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.splashScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4B8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } catch (e) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: const [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ocurrió un error al guardar tus datos. Intenta nuevamente.',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red[400],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
  }
}
