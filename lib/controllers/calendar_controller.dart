import 'package:flutter/material.dart';
import '../models/calendar_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends ChangeNotifier {
  final CalendarModel model = CalendarModel(
    focusedDay: DateTime.now(),
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Getters
  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;
  int get weeksPregnant => model.weeksPregnant;
  DateTime? get dueDate => model.dueDate;
  String get trimesterMessage => model.trimesterMessage;
  Color get weekColor => model.weekColor;

  // Métodos para actualizar el estado
  void updateCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  void updateFocusedDay(DateTime day) {
    model.focusedDay = day;
    notifyListeners();
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    model.selectedDay = selectedDay;
    model.focusedDay = focusedDay;
    _calculatePregnancyDetails();
    notifyListeners();
  }

  void _calculatePregnancyDetails() {
    if (model.selectedDay != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDate = DateTime(
        model.selectedDay!.year,
        model.selectedDay!.month,
        model.selectedDay!.day,
      );

      final difference = today.difference(selectedDate).inDays;

      if (difference <= 0) {
        model.weeksPregnant = 0;
        model.dueDate = null;
        model.trimesterMessage =
            "Tu último periodo no puede ser mayor o igual a la fecha actual";
        model.weekColor = Colors.black;
        return;
      }

      if (difference < 7) {
        model.weeksPregnant = -1;
      } else {
        model.weeksPregnant = (difference / 7).floor();
      }

      model.dueDate = selectedDate.add(const Duration(days: 280));
      _updateTrimesterMessage();
      _updateWeekColor();
    }
  }

  void _updateTrimesterMessage() {
    if (model.weeksPregnant < 13 && model.weeksPregnant > 0) {
      model.trimesterMessage =
          "🌱 Primer Trimestre: Desarrollo inicial del bebé. Es normal sentir náuseas y cansancio.";
    } else if (model.weeksPregnant < 27 && model.weeksPregnant > 12) {
      model.trimesterMessage =
          "🌟 Segundo Trimestre: El bebé empieza a moverse. Es un buen momento para ecografías.";
    } else if (model.weeksPregnant < 40 && model.weeksPregnant > 26) {
      model.trimesterMessage =
          "🤰 Tercer Trimestre: Prepara la llegada del bebé. Vigila las contracciones y síntomas.";
    } else if (model.weeksPregnant == 40) {
      model.trimesterMessage =
          "🎉 ¡Felicidades! Tu embarazo ya ha alcanzado el término. El parto puede ser en cualquier momento.";
    } else {
      model.trimesterMessage = "";
    }
  }

  void _updateWeekColor() {
    if (model.weeksPregnant < 13) {
      model.weekColor = Colors.green;
    } else if (model.weeksPregnant < 27) {
      model.weekColor = Colors.orange;
    } else if (model.weeksPregnant < 40) {
      model.weekColor = Colors.red;
    } else {
      model.weekColor = Colors.blue;
    }
  }
}
