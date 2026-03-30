import 'package:flutter/material.dart';

class ScheduleData {
  // TODO: Move start, end and deltaMinutes to
  // required properties
  TimeOfDay? _start;
  TimeOfDay? get start => _start;

  TimeOfDay? _end;
  TimeOfDay? get end => _end;
  set end(TimeOfDay time) {
    _end = time;
    if (isShiftFilled()) {
      deltaMinutes = _calcDeltaTime();
    }
  }

  int? deltaMinutes;
  bool isComplete = false;

  ScheduleData();

  ScheduleData.fromTime(TimeOfDay this._start, TimeOfDay this._end) {
    deltaMinutes = _calcDeltaTime();
    isComplete = true;
  }

  ScheduleData.fromSchedule(ScheduleData schedule) {
    _start = schedule.start;
    _end = schedule.end;
    deltaMinutes = schedule.deltaMinutes;
    isComplete = schedule.isComplete;
  }
  set start(TimeOfDay time) {
    _start = time;
    if (isShiftFilled()) {
      deltaMinutes = _calcDeltaTime();
    }
  }

  void addTime() {
    final TimeOfDay now = TimeOfDay.now();
    if (_start == null) {
      start = now;
    } else if (_end == null) {
      end = now;
    }
  }

  bool isShiftFilled() {
    return start != null && end != null;
  }

  Map<String, Object?> toMap() {
    DateTime now = DateTime.now();

    return {
      "schedule_date": DateTime(now.year, now.month, now.day).toString(),
      "start": DateTime(now.year, now.month, now.day, start!.hour, start!.minute).toString(),
      "end": DateTime(now.year, now.month, now.day, end!.hour, end!.minute).toString(),
      "delta_minutes": deltaMinutes.toString(),
    };
  }

  int _calcDeltaTime() {
    final int startHour = start!.hour * 60 + _start!.minute;
    final int endHour = end!.hour * 60 + end!.minute;

    assert(endHour >= startHour);
    return endHour - startHour;
  }
}
