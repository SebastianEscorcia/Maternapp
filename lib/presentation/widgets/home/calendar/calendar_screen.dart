import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/calendar_provider.dart';
import 'custom_table_calendar.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _cargando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verificarCarga();
  }

  Future<void> _verificarCarga() async {
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);

    if (calendarProvider.model.selectedDay == null) {
      final prefs = await SharedPreferences.getInstance();
      final calendarioId = prefs.getString('calendarioUid');

      if (calendarioId != null && calendarioId.isNotEmpty) {
        await calendarProvider.cargarCalendario(calendarioId);
      }
    }

    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: Text('Cargando calendario...')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de embarazo 📅'),
      ),
      body: const CustomTableCalendar(),
    );
  }
}
