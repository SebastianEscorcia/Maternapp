import 'package:flutter/material.dart';
import 'package:maternapp/presentation/screens/home/widgets/calendar/calendar_screen.dart';

class ButtonCalendar extends StatelessWidget {
  const ButtonCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalendarScreen()));
          },
          style: ElevatedButton.styleFrom(
            iconColor: Colors.pink[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Icon(Icons.calendar_month, size: 20),
        ),
      ],
    );
  }
}
