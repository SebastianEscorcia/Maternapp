import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DropdownQuestionCard extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final IconData? icon; // 👈 ícono opcional

  const DropdownQuestionCard({
    required this.questionText,
    required this.options,
    required this.onChanged,
    this.selectedValue,
    this.icon,
    super.key,
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
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedValue,
                    decoration: InputDecoration(
                      hintText: "Selecciona una opción",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
