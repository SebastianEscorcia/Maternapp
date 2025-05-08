import 'package:flutter/material.dart';

class ButtonProfile extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;
  const ButtonProfile({
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
              Icons.person,
              color: isActive ? Colors.pinkAccent : Colors.grey,
            ),
            Text(
              "Perfil",
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
