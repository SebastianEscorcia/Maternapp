import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InputQuestionCard extends StatelessWidget {
  final String questionText;
  final String hintText;
  final TextInputType inputType;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final IconData? icon; // 👈 ícono opcional

  const InputQuestionCard({
    super.key,
    required this.questionText,
    required this.hintText,
    required this.inputType,
    required this.onChanged,
    this.initialValue,
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
                  Text(
                    questionText,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: initialValue,
                    keyboardType: inputType,
                    decoration: InputDecoration(
                      hintText: hintText,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: onChanged,
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
