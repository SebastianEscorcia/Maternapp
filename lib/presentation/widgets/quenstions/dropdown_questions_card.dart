import 'package:flutter/material.dart';

class DropdownQuestionCard extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final IconData? icon;
  final String? imageAsset;
  final String? motivationalText;

  const DropdownQuestionCard({
    super.key,
    required this.questionText,
    required this.options,
    required this.selectedValue,
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
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Color(0xFFFF4B8A),
              ),
              iconSize: 28,
              elevation: 16,
              isExpanded: true,
              dropdownColor: Colors.white,
              style: const TextStyle(
                color: Color(0xFF444444),
                fontSize: 18,
              ),
              items: options.map<DropdownMenuItem<String>>((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
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
                hintText: "Selecciona una opción",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Iconos indicadores para los tipos de embarazo
          if (options.contains("Único") && options.contains("Gemelar"))
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptionIconCard(
                    label: "Único",
                    isSelected: selectedValue == "Único",
                    icon: Icons.child_care,
                  ),
                  const SizedBox(width: 20),
                  _buildOptionIconCard(
                    label: "Gemelar",
                    isSelected: selectedValue == "Gemelar",
                    icon: Icons.people,
                  ),
                  const SizedBox(width: 20),
                  _buildOptionIconCard(
                    label: "Trillizos+",
                    isSelected: selectedValue == "Trillizos o más",
                    icon: Icons.groups,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionIconCard({
    required String label,
    required bool isSelected,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF4B8A).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: const Color(0xFFFF4B8A), width: 2)
            : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF4B8A) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFFFF4B8A) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}