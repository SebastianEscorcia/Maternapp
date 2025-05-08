import 'package:flutter/material.dart';

class ButtonCalendar extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;

  const ButtonCalendar({
    super.key,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: isActive ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              color: isActive ? Colors.pinkAccent : Colors.grey,
            ),
            Text(
              "Calendario",
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.pinkAccent : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
