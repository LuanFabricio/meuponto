import 'package:flutter/material.dart';

String formatMinutesToHour(int totalMinutes, {bool showSignal = false}) {
  String format = "";
  if (showSignal && totalMinutes != 0) {
    format += (totalMinutes < 0) ? "-" : "+";
  }
  totalMinutes = totalMinutes.abs();

  int hour = (totalMinutes / 60).floor();
  int minutes = totalMinutes % 60;

  format += hour.toString().padLeft(2, "0");
  format += ":";
  format += minutes.toString().padLeft(2, "0");

  return format;
}

String formatTimeOfDay(final TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, "0");
  final minute = time.minute.toString().padLeft(2, "0");
  return "$hour:$minute:00";
}

String formatDate(final DateTime date) {
  final year = date.year.toString().padLeft(4, "0");
  final month = date.month.toString().padLeft(2, "0");
  final day = date.day.toString().padLeft(2, "0");

  return "$year-$month-$day";
}

String formatDateHuman(final DateTime date) {
  final year = date.year.toString().padLeft(4, "0");
  final month = date.month.toString().padLeft(2, "0");
  final day = date.day.toString().padLeft(2, "0");

  return "$day/$month/$year";
}
