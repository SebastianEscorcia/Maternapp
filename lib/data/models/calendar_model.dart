import 'package:flutter/material.dart';

class CalendarModel {
  DateTime? selectedDay;
  DateTime focusedDay;
  int weeksPregnant;
  DateTime? dueDate;
  String trimesterMessage;
  Color weekColor;
  DateTime? lastDayYear;
  String uId;
  String maternaId;
  final String? calendarioId;

  CalendarModel(
      {required this.uId,
      this.selectedDay,
      required this.focusedDay,
      this.weeksPregnant = 0,
      this.dueDate,
      this.trimesterMessage = "",
      this.weekColor = Colors.black,
      this.maternaId = "",
      this.lastDayYear,
      this.calendarioId});

  Map<String, dynamic> toJson() {
    return {
      'selectedDay': selectedDay?.toIso8601String(),
      'focusedDay': focusedDay.toIso8601String(),
      'weeksPregnant': weeksPregnant,
      'dueDate': dueDate?.toIso8601String(),
      'trimesterMessage': trimesterMessage,
      'weekColor': weekColor.value,
      'lastDayYear': lastDayYear?.toIso8601String(),
      'uId': uId,
      'maternaId': maternaId,
    };
  }

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      uId: json['uId'],
      selectedDay: json['selectedDay'] != null
          ? DateTime.parse(json['selectedDay'])
          : null,
      focusedDay: DateTime.parse(json['focusedDay']),
      weeksPregnant: json['weeksPregnant'] ?? 0,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      trimesterMessage: json['trimesterMessage'] ?? "",
      weekColor: Color(json['weekColor'] ?? Colors.black.value),
      lastDayYear: json['lastDayYear'] != null
          ? DateTime.parse(json['lastDayYear'])
          : DateTime(DateTime.now().year + 1, 12, 31),
      maternaId: json['maternaId'] ?? "",
    );
  }
  void copyFrom(CalendarModel other) {
    focusedDay = other.focusedDay;
    selectedDay = other.selectedDay;
    weeksPregnant = other.weeksPregnant;
    dueDate = other.dueDate;
    trimesterMessage = other.trimesterMessage;
    weekColor = other.weekColor;
    lastDayYear = other.lastDayYear;
    maternaId = other.maternaId;
  }
}
