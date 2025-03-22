import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maternapp/controllers/calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class CustomTableCalendar extends StatelessWidget {
  const CustomTableCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            "Selecciona una fecha",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Consumer<CalendarController>(
            builder: (context, controller, child) {
              return TableCalendar(
                locale: 'es_ES',
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
                lastDay: DateTime.utc(3000, 12, 31),
                focusedDay: controller.focusedDay,
                calendarFormat: controller.calendarFormat,
                selectedDayPredicate: (day) =>
                    day == controller.selectedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectDay(selectedDay, focusedDay);
                },
                onFormatChanged: (format) {
                  controller.updateCalendarFormat(format);
                },
                onPageChanged: (focusedDay) {
                  controller.updateFocusedDay(focusedDay);
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Consumer<CalendarController>(
            builder: (context, controller, child) {
              return Column(
                children: [
                  Text(
                    controller.selectedDay != null &&
                            controller.weeksPregnant != 0
                        ? "Última menstruación: ${DateFormat('dd MMMM yyyy', 'es_Es').format(controller.selectedDay!)}"
                        : "Selecciona la fecha de tu última menstruación",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.weeksPregnant == -1
                        ? "Semanas de embarazo: Menos de una semana"
                        : "Semanas de embarazo: ${controller.weeksPregnant}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: controller.weekColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (controller.dueDate != null)
                    Text( 
                      "Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_Es').format(controller.dueDate!)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    controller.trimesterMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
