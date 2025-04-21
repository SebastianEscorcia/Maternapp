import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearPickerQuestionCard extends StatelessWidget {
  final String questionText;
  final int? selectedYear;
  final ValueChanged<int> onChanged;
  final IconData? icon;

  const YearPickerQuestionCard({
    super.key,
    required this.questionText,
    required this.selectedYear,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(100, (index) => currentYear - index);
    final initialIndex = selectedYear != null
        ? years.indexOf(selectedYear!)
        : years.indexOf(currentYear - 25);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(icon, color: Colors.pink, size: 28),
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
              onSelectedItemChanged: (index) =>
                  onChanged(years[index]),
              children: years.map((y) => Center(
                child: Text(
                  y.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
