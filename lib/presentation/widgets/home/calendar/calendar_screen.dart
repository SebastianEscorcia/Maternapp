import 'package:flutter/material.dart';
import 'package:maternapp/presentation/widgets/home/calendar/custom_table_calendar.dart';
import 'package:maternapp/presentation/widgets/home/navbar/botton_navbar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora de Embarazo")),
      body: CustomTableCalendar(),
      bottomNavigationBar: const BottonNavbar(),
    );
  }
}
