import 'package:flutter/material.dart';

class InputQuestionCard extends StatelessWidget {
  final String questionText;
  final String hintText;
  final TextInputType inputType;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final IconData? icon;
  final String? imageAsset;
  final String? motivationalText;

  const InputQuestionCard({
    super.key,
    required this.questionText,
    required this.hintText,
    required this.inputType,
    required this.onChanged,
    this.initialValue,
    this.icon,
    this.imageAsset,
    this.motivationalText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Image.asset(
                imageAsset!,
                width: 150,
                height: 150,
              ),
            )
          else if (icon != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                size: 28,
                color: const Color(0xFFFF4B8A),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            questionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (motivationalText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                motivationalText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4B8A).withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              initialValue: initialValue,
              keyboardType: inputType,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF333333),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                filled: true,
                fillColor: const Color(0xFFFFF1F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF4B8A),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.edit,
                  color: Color(0xFFFF4B8A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
