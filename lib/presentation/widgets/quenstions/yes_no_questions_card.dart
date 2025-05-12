import 'package:flutter/material.dart';

class YesNoQuestionCard extends StatelessWidget {
  final String questionText;
  final bool? initialValue;
  final Function(bool?) onChanged;
  final IconData? icon;
  final String? imageAsset;
  final String? motivationalText;

  const YesNoQuestionCard({
    super.key,
    required this.questionText,
    required this.initialValue,
    required this.onChanged,
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionButton(
                label: "Sí",
                isSelected: initialValue == true,
                onTap: () => onChanged(true),
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(width: 20),
              _buildOptionButton(
                label: "No",
                isSelected: initialValue == false,
                onTap: () => onChanged(false),
                icon: Icons.cancel_outlined,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF4B8A) : const Color(0xFFFFF1F5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF4B8A).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
            border: isSelected
                ? null
                : Border.all(
                    color: const Color(0xFFFFD6E5),
                    width: 2,
                  ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFFFF4B8A),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF555555),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}