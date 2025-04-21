import 'package:flutter/material.dart';

class ButtonVitals extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const ButtonVitals({
    super.key,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.pink : Colors.grey;

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monitor_heart_outlined,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Vitales',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
