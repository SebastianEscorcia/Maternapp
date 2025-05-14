import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // ✅ Actualizar modelo en memoria
  calendarProvider.forzarActualizarFecha(selectedDay, focusedDay);

  // ✅ Guardar calendario en Firebase si ya existe (ya tiene UID asignado)
  if (calendarProvider.model.uId.isNotEmpty) {
    await calendarProvider.guardarCambiosCalendarioEnFirebase();
  }

  // ✅ Si ya hay materna cargada, también la actualizamos en memoria
  if (maternaProvider.materna != null) {
    if (calendarProvider.dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Fecha inválida. No se pudo calcular el parto.")),
      );
      return;
    }
    
    if (draftProvider.draft.uId == null || draftProvider.draft.uId!.isEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        draftProvider.draft.uId = user.uid;
      } else {
        // UID temporal si no hay sesión
        draftProvider.draft.uId =
            FirebaseFirestore.instance.collection('maternas').doc().id;
      }
    }

    maternaProvider.crearMaterna(
      draft: draftProvider.draft,
      calendar: calendarProvider.model,
    );
    // Actualizamos la fecha de última menstruación (FUM) en Firebase y en el modelo de MaternaProvider
    await maternaProvider.actualizarFUMDesdeCalendario(context);
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
