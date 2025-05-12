import 'package:flutter/material.dart';

class QuestionProgressBar extends StatelessWidget {
  final int index;
  final int total;

  const QuestionProgressBar({
    super.key,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (index + 1) / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFFFD6E5),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF4B8A)),
          minHeight: 8,
        ),
      ),
    );
  }
}
