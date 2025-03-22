import 'package:flutter/material.dart';

class CalendarModel {
  DateTime? selectedDay ;
  DateTime focusedDay;
  int weeksPregnant;
  DateTime? dueDate;
  String trimesterMessage;
  Color weekColor;

  CalendarModel({
    this.selectedDay,
    required this.focusedDay,
    this.weeksPregnant = 0,
    this.dueDate,
    this.trimesterMessage = "",
    this.weekColor = Colors.black,
  });
}
