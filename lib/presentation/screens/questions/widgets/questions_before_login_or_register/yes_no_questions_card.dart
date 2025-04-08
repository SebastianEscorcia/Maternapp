import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class YesNoQuestionCard extends StatelessWidget {
  final String questionText;
  final bool? initialValue;
  final ValueChanged<bool?> onChanged;
  final IconData? icon; // 👈 ícono opcional

  const YesNoQuestionCard({
    super.key,
    required this.questionText,
    required this.initialValue,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: Colors.pink[50],
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(icon, size: 32, color: Colors.pink[300]),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(questionText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  RadioListTile<bool>(
                    title: const Text('Sí'),
                    value: true,
                    groupValue: initialValue,
                    onChanged: onChanged,
                    dense: true,
                  ),
                  RadioListTile<bool>(
                    title: const Text('No'),
                    value: false,
                    groupValue: initialValue,
                    onChanged: onChanged,
                    dense: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).moveY(begin: 30);
  }
}
