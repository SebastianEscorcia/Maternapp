import 'package:flutter/material.dart';

import '../buttons/button_home.dart';
import '../buttons/button_profile.dart';

class BottonNavbarFamiliar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottonNavbarFamiliar({
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
          _buildCustomIcon(
            icon: Icons.favorite,
            label: "Materna",
            isActive: currentIndex == 1,
            onPressed: () => onTap(1),
          ),
          _buildCustomIcon(
            icon: Icons.notifications,
            label: "Avisos",
            isActive: currentIndex == 2,
            onPressed: () => onTap(2),
          ),
          ButtonProfile(
            isActive: currentIndex == 3,
            onPressed: () => onTap(3),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIcon({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.pink : Colors.grey),
          Text(label,
              style: TextStyle(
                  color: isActive ? Colors.pink : Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
