import 'package:flutter/material.dart';

import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/time_utils.dart';

class Shift {
  Shift({
    required TimeOfDay start,
    required TimeOfDay end,
    required this.turn,
    DateTime? date,
  }) {
    _date = date ?? DateTime.now();
    _start = start;
    _end = end;
    deltaMinutes = getDeltaTime(start, end);
    print("Delta minutes: $deltaMinutes");
  }

  late final DateTime _date;
  final int turn;
  late TimeOfDay _start;
  TimeOfDay get start => _start;
  set start(TimeOfDay time) {
    _start = time;
    deltaMinutes = getDeltaTime(start, end);
  }

  TimeOfDay get end => _end;
  late TimeOfDay _end;
  set end(TimeOfDay time) {
    _end = time;
    deltaMinutes = getDeltaTime(start, end);
  }
  int deltaMinutes = 0;

  Map<String, Object?> toMap() {
    return {
      "turn": turn,
      "shift_date": formatDate(_date),
      "start": formatTimeOfDay(start),
      "end": formatTimeOfDay(end),
      "delta_minutes": deltaMinutes,
    };
  }

  @override
  String toString() {
    return
      "shift_date: ${_date.toString()} "
      "turn: $turn "
      "start: ${start.toString()} "
      "end: ${end.toString()} "
      "delta_minutes: $deltaMinutes "
    ;
  }
}
