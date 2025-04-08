import 'package:flutter/material.dart';

class DropdownQuestionCard extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const DropdownQuestionCard({
    required this.questionText,
    required this.options,
    required this.onChanged,
    this.selectedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(questionText, style: TextStyle(fontSize: 18)),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(hintText: "Selecciona una opción"),
        ),
      ],
    );
  }
}
