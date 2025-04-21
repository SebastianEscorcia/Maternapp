import 'package:flutter/material.dart';

class DropdownQuestionCard extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final IconData? icon;

  const DropdownQuestionCard({
    super.key,
    required this.questionText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 28, color: Colors.pink),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFFFF1F5),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
