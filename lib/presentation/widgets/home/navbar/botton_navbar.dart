import 'package:flutter/material.dart';
import 'package:maternapp/presentation/widgets/home/buttons/button_calendar.dart';
import 'package:maternapp/presentation/widgets/home/buttons/button_home.dart';

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
          ButtonHome(),
          ButtonCalendar(),
        ],
      ),
    );
  }
}
