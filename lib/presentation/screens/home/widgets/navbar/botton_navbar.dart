import 'package:flutter/material.dart';
import 'package:maternapp/presentation/screens/home/widgets/buttons/button_calendar.dart';

class BottonNavbar extends StatelessWidget {
  const BottonNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.pink[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonCalendar(),
          Icon(Icons.home, size: 30),
        ],
      ),
    );
  }
}
