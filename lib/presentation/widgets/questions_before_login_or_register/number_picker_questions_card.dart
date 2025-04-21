import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberPickerQuestionCard extends StatelessWidget {
  final String questionText;
  final int? selectedValue;
  final int minValue;
  final int maxValue;
  final String unit;
  final ValueChanged<int> onChanged;
  final IconData? icon;

  const NumberPickerQuestionCard({
    super.key,
    required this.questionText,
    required this.selectedValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final initialIndex = selectedValue != null
        ? selectedValue! - minValue
        : ((maxValue - minValue) ~/ 2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, size: 28, color: Colors.pink),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: initialIndex),
              itemExtent: 40,
              onSelectedItemChanged: (index) => onChanged(minValue + index),
              children: List.generate(maxValue - minValue + 1, (i) {
                final val = minValue + i;
                return Center(
                  child: Text(
                    "$val $unit",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
