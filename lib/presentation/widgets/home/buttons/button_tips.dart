import 'package:flutter/material.dart';

class ButtonTips extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;

  const ButtonTips({
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
            Icons.lightbulb_outline,
            color: isActive ? Colors.pink : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Consejos',
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
