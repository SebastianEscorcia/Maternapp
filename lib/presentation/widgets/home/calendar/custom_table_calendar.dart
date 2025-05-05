import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/utils/calendar_logic.dart';
import '../../../providers/calendar_provider.dart';
import '../../../providers/maternal_draft_provider.dart';
import '../../../providers/maternal_provider.dart';

class CustomTableCalendar extends StatelessWidget {
  const CustomTableCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Selecciona la fecha de tu ultimo periodo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TableCalendar(
            locale: 'es_ES',
            key: ValueKey(
                '${calendarProvider.focusedDay}-${calendarProvider.calendarFormat}'),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.pink[200],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.pink[300],
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayTextStyle: const TextStyle(color: Colors.white),
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Semana',
              CalendarFormat.twoWeeks: 'Mes',
              CalendarFormat.week: '2 Semanas',
            },
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: calendarProvider.lastDayYear,
            focusedDay: calendarProvider.focusedDay,
            calendarFormat: calendarProvider.calendarFormat,
            selectedDayPredicate: (day) => day == calendarProvider.selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              final maternaProvider =
                  Provider.of<MaternaProvider>(context, listen: false);
              final draftProvider =
                  Provider.of<MaternaDraftProvider>(context, listen: false);
              manejarSeleccionDeFecha(
                context: context,
                selectedDay: selectedDay,
                focusedDay: focusedDay,
                draftProvider: draftProvider,
                maternaProvider: maternaProvider,
              );
            },
            onFormatChanged: (format) {
              calendarProvider.updateCalendarFormat(format);
            },
            onPageChanged: (focusedDay) {
              calendarProvider.updateFocusedDay(focusedDay);
            },
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                calendarProvider.selectedDay != null &&
                        calendarProvider.weeksPregnant != 0
                    ? "Última menstruación: ${DateFormat('dd MMMM yyyy', 'es_ES').format(calendarProvider.selectedDay!)}"
                    : "Selecciona la fecha de tu última menstruación",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                calendarProvider.weeksPregnant == -1
                    ? "Semanas de embarazo: Menos de una semana"
                    : "Semanas de embarazo: ${calendarProvider.weeksPregnant}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: calendarProvider.weekColor,
                ),
              ),
              const SizedBox(height: 10),
              if (calendarProvider.dueDate != null)
                Text(
                  "Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_ES').format(calendarProvider.dueDate!)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                calendarProvider.trimesterMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
