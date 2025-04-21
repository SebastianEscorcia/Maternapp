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
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: isActive ? Colors.pink : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Calendario',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.pink : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
