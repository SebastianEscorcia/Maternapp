import 'package:flutter/material.dart';

class QuestionStepCardDecorations extends StatelessWidget {
  const QuestionStepCardDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -20,
          right: -30,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD6E5).withAlpha(4),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -50,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD6E5).withAlpha(3),
            ),
          ),
        ),
      ],
    );
  }
}
