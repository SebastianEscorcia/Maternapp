import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

class CustomTableCalendar extends StatefulWidget {
  const CustomTableCalendar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _weeksPregnant = 0;
  DateTime? _dueDate;
  String _trimesterMessage = "";
  Color _weekColor = Colors.black;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null); // Formato de la fecha en español
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Selecciona una fecha",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TableCalendar(
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.pink[200],
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.pink[300],
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayTextStyle: TextStyle(color: Colors.white),
          ),
          locale: 'es_ES',
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(3000, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (DateTime day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _calculatePregnancyDetails();
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),
        SizedBox(height: 20),
        Text(
          _selectedDay != null && _weeksPregnant != 0
              ? "Última menstruación: ${DateFormat('dd MMMM yyyy', 'es_ES').format(_selectedDay!)}"
              : "Selecciona la fecha de tu última menstruación",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          _weeksPregnant == -1
              ? "Semanas de embarazo: Menos de una semana"
              : "Semanas de embarazo: $_weeksPregnant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _weekColor,
          ),
        ),
        SizedBox(height: 10),
        if (_dueDate != null)
          Text(
            "Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_ES').format(_dueDate!)}",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
        SizedBox(height: 10),
        Text(
          _trimesterMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  // Calcula las semanas de embarazo y la fecha probable de parto
  void _calculatePregnancyDetails() {
    if (_selectedDay != null) {
      final now = DateTime.now();
      final difference = now.difference(_selectedDay!).inDays;
      if (difference <= 0) {
        _weeksPregnant = 0;
        _dueDate = null;
        _trimesterMessage =
            "Tu último periodo no puede ser mayor o igual a la fecha actual";
        _weekColor = Colors.black;
        return;
      }
      setState(() {
        if (difference < 7) {
          _weeksPregnant = -1;
        } else {
          _weeksPregnant = (difference / 7).floor();
        }
        _dueDate = _selectedDay!.add(Duration(days: 280));
        _updateTrimesterMessage();
        _updateWeekColor();
      });
    }
  }

  // Mensaje según el trimestre del embarazo
  void _updateTrimesterMessage() {
    if (_weeksPregnant < 13 && _weeksPregnant > 0) {
      _trimesterMessage =
          "🌱 Primer Trimestre: Desarrollo inicial del bebé. Es normal sentir náuseas y cansancio.";
    } else if (_weeksPregnant < 27 && _weeksPregnant > 12) {
      _trimesterMessage =
          "🌟 Segundo Trimestre: El bebé empieza a moverse. Es un buen momento para ecografías.";
    } else if (_weeksPregnant < 40 && _weeksPregnant > 26) {
      _trimesterMessage =
          "🤰 Tercer Trimestre: Prepara la llegada del bebé. Vigila las contracciones y síntomas.";
    } else if (_weeksPregnant == 40) {
      _trimesterMessage =
          "🎉 ¡Felicidades! Tu embarazo ya ha alcanzado el término. El parto puede ser en cualquier momento.";
    } else {
      _trimesterMessage = "";
    }
  }

  /// Cambia el color del texto según las semanas de embarazo
  void _updateWeekColor() {
    if (_weeksPregnant < 13) {
      _weekColor = Colors.green;
    } else if (_weeksPregnant < 27) {
      _weekColor = Colors.orange;
    } else if (_weeksPregnant < 40) {
      _weekColor = Colors.red;
    } else {
      _weekColor = Colors.blue;
    }
  }
}
