import 'package:flutter/material.dart';

class QuestionFooterMessage extends StatelessWidget {
  final String message;

  const QuestionFooterMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Color(0xFF888888),
        ),
      ),
    );
  }
}
