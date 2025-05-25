import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../layout/layout_scaffold.dart';
import '../../providers/calendar_provider.dart';
import '../../widgets/calendar/custom_table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  Future<bool> _cargarCalendario(BuildContext context) async {
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);

    if (calendarProvider.model.selectedDay == null) {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('calendarioUid');
      if (uid != null && uid.isNotEmpty) {
        await calendarProvider.cargarCalendario(uid);
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _cargarCalendario(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LayoutScaffold(
            useMaternalBackground: true,
            centerContent: true,
            child: Text('Cargando calendario...'),
          );
        }

        return const LayoutScaffold(
          title: 'Calculadora de embarazo 📅',
          useMaternalBackground: true,
          child: CustomTableCalendar(),
        );
        
      },
    );
  }
}
