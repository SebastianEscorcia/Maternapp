import 'package:flutter/material.dart';

class InputQuestionCard extends StatelessWidget {
  final String questionText;
  final String hintText;
  final TextInputType inputType;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final IconData? icon;

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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              width: 250,
              child: TextFormField(
                initialValue: initialValue,
                keyboardType: inputType,
                onChanged: onChanged,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: const Color(0xFFFFF1F5),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
