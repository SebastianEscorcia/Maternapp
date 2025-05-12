import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearPickerQuestionCard extends StatelessWidget {
  final String questionText;
  final int? selectedYear;
  final ValueChanged<int> onChanged;
  final IconData? icon;
  final String? imageAsset;
  final String? motivationalText;

  const YearPickerQuestionCard({
    super.key,
    required this.questionText,
    required this.selectedYear,
    required this.onChanged,
    this.icon,
    this.imageAsset,
    this.motivationalText,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(100, (index) => currentYear - index);
    final initialIndex = selectedYear != null
        ? years.indexOf(selectedYear!)
        : years.indexOf(currentYear - 25);

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
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Decoración de selección
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4B8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF4B8A),
                      width: 2,
                    ),
                  ),
                ),
                // Selector de años
                CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 46,
                  looping: false,
                  onSelectedItemChanged: (index) => onChanged(years[index]),
                  selectionOverlay: Container(),
                  children: years
                      .map((y) => Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                y.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),

                // Flechas indicadoras
                Positioned(
                  right: 0,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: const Color(0xFFFF4B8A).withOpacity(0.7),
                    size: 32,
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: const Color(0xFFFF4B8A).withOpacity(0.7),
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
