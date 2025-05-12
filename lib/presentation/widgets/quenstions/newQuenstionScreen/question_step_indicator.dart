import 'package:flutter/material.dart';

class QuestionStepIndicator extends StatelessWidget {
  final int index;
  final int total;

  const QuestionStepIndicator({
    super.key,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite,
            color: Color(0xFFFF4B8A),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Pregunta ${index + 1} de $total',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }
}
