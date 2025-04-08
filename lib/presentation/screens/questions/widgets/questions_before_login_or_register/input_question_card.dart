// input_question_card.dart actualizado con TextEditingController
import 'package:flutter/material.dart';

class InputQuestionCard extends StatefulWidget {
  final String questionText;
  final String hintText;
  final TextInputType inputType;
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const InputQuestionCard({
    required this.questionText,
    required this.hintText,
    required this.inputType,
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  @override
  State<InputQuestionCard> createState() => _InputQuestionCardState();
}

class _InputQuestionCardState extends State<InputQuestionCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.questionText, style: const TextStyle(fontSize: 18)),
        TextFormField(
          controller: _controller,
          keyboardType: widget.inputType,
          decoration: InputDecoration(hintText: widget.hintText),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
  