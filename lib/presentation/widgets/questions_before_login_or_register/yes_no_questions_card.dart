import 'package:flutter/material.dart';

class YesNoQuestionCard extends StatelessWidget {
  final String questionText;
  final bool? initialValue;
  final Function(bool?) onChanged;
  final IconData? icon;

  const YesNoQuestionCard({
    super.key,
    required this.questionText,
    required this.initialValue,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text("Sí"),
                selected: initialValue == true,
                selectedColor: Colors.pink[200],
                onSelected: (_) => onChanged(true),
              ),
              ChoiceChip(
                label: const Text("No"),
                selected: initialValue == false,
                selectedColor: Colors.pink[200],
                onSelected: (_) => onChanged(false),
              ),
            ],
          )
        ],
      ),
    );
  }
}
