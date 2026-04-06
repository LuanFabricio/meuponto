import 'package:flutter/material.dart';
import 'package:meuponto/data/schedule.dart';

import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/time_utils.dart';

class Shift {
  Shift(TimeOfDay start, TimeOfDay end, {required this.turn}) {
    _start = start;
    _end = end;
    deltaMinutes = getDeltaTime(start, end);
    print("Delta minutes: $deltaMinutes");
  }

  final _date = DateTime.now();
  final int turn;
  TimeOfDay _start = TimeOfDay.now();
  TimeOfDay get start => _start;
  set start(TimeOfDay time) {
    _start = time;
    deltaMinutes = getDeltaTime(start, start);
  }

  TimeOfDay get end => _end;
  TimeOfDay _end = TimeOfDay.now();
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
