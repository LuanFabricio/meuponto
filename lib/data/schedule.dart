import 'package:flutter/material.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/time_utils.dart';

class ScheduleData {
  ScheduleData({required this.start_, required this.end_});

  final _date = DateTime.now();
  TimeOfDay start_ = TimeOfDay.now();
  TimeOfDay get start => start_;

  TimeOfDay end_ = TimeOfDay.now();
  TimeOfDay get end => end_;
  set end(TimeOfDay time) {
    end_ = time;
    deltaMinutes = getDeltaTime(start, end);
  }

  int? deltaMinutes;
  bool isComplete = false;

  ScheduleData.fromSchedule(ScheduleData schedule) {
    start_ = schedule.start;
    end_ = schedule.end;
    deltaMinutes = schedule.deltaMinutes;
    isComplete = schedule.isComplete;
  }
  set start(TimeOfDay time) {
    start_ = time;
    deltaMinutes = getDeltaTime(start, end);
  }

  Map<String, Object?> toMap() {
    return {
      "schedule_date": formatDate(_date),
      "start": formatTimeOfDay(start),
      "end": formatTimeOfDay(end),
      "delta_minutes": deltaMinutes.toString(),
    };
  }
}
