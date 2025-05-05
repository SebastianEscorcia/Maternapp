import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/providers/calendar_provider.dart';
import '../../presentation/providers/maternal_draft_provider.dart';
import '../../presentation/providers/maternal_provider.dart';

Future<void> manejarSeleccionDeFecha({
  required BuildContext context,
  required DateTime selectedDay,
  required DateTime focusedDay,
  required MaternaDraftProvider draftProvider,
  required MaternaProvider maternaProvider,
}) async {
  final calendarProvider =
      Provider.of<CalendarProvider>(context, listen: false);

  // ❌ Validar si la fecha es válida
  if (!calendarProvider.esFechaSeleccionValida(selectedDay)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("La fecha debe ser anterior a hoy."),
      ),
    );
    return;
  }

  final necesitaConfirmacion =
      calendarProvider.necesitaConfirmacion(selectedDay);
  if (necesitaConfirmacion) {
    final continuar = await mostrarConfirmacionCambioFecha(context);
    if (!continuar) return;
  }

  calendarProvider.forzarActualizarFecha(selectedDay, focusedDay);

  if (maternaProvider.materna != null) {
    if (calendarProvider.dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Fecha inválida. No se pudo calcular el parto.")),
      );
      return;
    }

    maternaProvider.crearMaterna(
      draft: draftProvider.draft,
      calendar: calendarProvider.model,
    );
  }
}

Future<bool> mostrarConfirmacionCambioFecha(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Estás segura?'),
          content: const Text(
              'Cambiar la fecha modificará tus semanas de embarazo y fecha probable de parto. ¿Deseas continuar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí, cambiar'),
            ),
          ],
        ),
      ) ??
      false;
}
