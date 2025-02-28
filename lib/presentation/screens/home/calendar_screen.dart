import 'package:flutter/material.dart';
import 'package:maternapp/presentation/screens/home/widgets/custom_table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora de Embarazo")),
      body: CustomTableCalendar(),
    );
  }
}
