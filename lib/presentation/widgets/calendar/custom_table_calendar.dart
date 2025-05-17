import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/utils/calendar_logic.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/maternal_draft_provider.dart';
import '../../providers/maternal_provider.dart';

class CustomTableCalendar extends StatelessWidget {
  const CustomTableCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Selecciona la fecha de tu último periodo",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Calendario con estilo limpio
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pink.shade50, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade300.withAlpha(100),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: TableCalendar(
              locale: 'es_ES',
              key: ValueKey(
                  '${calendarProvider.focusedDay}-${calendarProvider.calendarFormat}'),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.pink.shade400,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.black87),
                defaultTextStyle: const TextStyle(color: Colors.black87),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.pink.shade300),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.pink.shade300),
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mes',
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
          ),

          const SizedBox(height: 30),

          // Información de seguimiento
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.shade50),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade300.withAlpha(100),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  calendarProvider.selectedDay != null &&
                          calendarProvider.weeksPregnant != 0
                      ? "🩸 Última menstruación: ${DateFormat('dd MMMM yyyy', 'es_ES').format(calendarProvider.selectedDay!)}"
                      : "Selecciona la fecha de tu última menstruación",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  calendarProvider.weeksPregnant == -1
                      ? "🤱 Semanas de embarazo: Menos de una semana"
                      : "🤱 Semanas de embarazo: ${calendarProvider.weeksPregnant}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: calendarProvider.weekColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (calendarProvider.dueDate != null)
                  Text(
                    "📅 Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_ES').format(calendarProvider.dueDate!)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
  }
}
