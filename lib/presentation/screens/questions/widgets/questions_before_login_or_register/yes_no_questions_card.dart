import 'package:flutter/material.dart';

class YesNoQuestionCard extends StatelessWidget {

  final String questionText;
  final bool? initialValue;
  final ValueChanged<bool?> onChanged;

  const YesNoQuestionCard({
    super.key,
    required this.questionText,
    required this.onChanged,
    this.initialValue,
  });
 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(questionText, style: TextStyle(fontSize: 18)),
        RadioListTile<bool>(
          title: Text('Sí'),
          value: true,
          groupValue: initialValue,
          onChanged: onChanged ,
        ),
        RadioListTile<bool>(
          title: Text('No'),
          value: false,
          groupValue: initialValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
