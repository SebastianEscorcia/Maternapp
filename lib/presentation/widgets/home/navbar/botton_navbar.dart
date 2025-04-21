import 'package:flutter/material.dart';

// buttons:
import '../buttons/button_calendar.dart';
import '../buttons/button_home.dart';
import '../buttons/button_profile.dart';
import '../buttons/button_tips.dart';
import '../buttons/button_vitals.dart';

class BottonNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottonNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonHome(
            isActive: currentIndex == 0,
            onPressed: () => onTap(0),
          ),
          ButtonCalendar(
            isActive: currentIndex == 1,
            onPressed: () => onTap(1),
          ),
          ButtonTips(
            isActive: currentIndex == 2,
            onPressed: () => onTap(2),
          ),
          ButtonProfile(
            isActive: currentIndex == 3,
            onPressed: () => onTap(3),
          ),
          ButtonVitals(
            isActive: currentIndex == 4,
            onPressed: () => onTap(4),
          )
        ],
      ),
    );
  }
}
