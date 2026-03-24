import 'package:flutter/material.dart';

class ScheduleData {
  ScheduleData();

  TimeOfDay? _start;
  TimeOfDay? get start => _start;
  set start(TimeOfDay time) {
    _start = time;
    if (_isShouldCalcDelta()) {
      delta = _calcDeltaTime();
    }
  }

  TimeOfDay? _end;
  TimeOfDay? get end => _end;
  set end(TimeOfDay time) {
    _end = time;
    if (_isShouldCalcDelta()) {
      delta = _calcDeltaTime();
    }
  }

  TimeOfDay? delta;

  void addTime() {
    final TimeOfDay now = TimeOfDay.now();
    if (_start == null) {
      start = now;
    } else if (_end == null) {
      end = now;
    }
  }

  bool _isShouldCalcDelta() {
    return start != null && end != null;
  }

  TimeOfDay _calcDeltaTime() {
    final double startHour = start!.hour + _start!.minute / 60.0;
    final double endHour = end!.hour + end!.minute / 60.0;

    assert(endHour >= startHour);
    final double delta = endHour - startHour;

    final int hour = delta.floor();
    final int minute = ((delta - hour) * 60).toInt();

    return TimeOfDay(hour: hour, minute: minute);
  }
}
