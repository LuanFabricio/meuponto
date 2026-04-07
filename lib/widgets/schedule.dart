import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:meuponto/data/shift.dart';
import 'package:meuponto/services/shift.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/widgets/button_time.dart';

const String tag = "ScheduleWidget";

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => ScheduleState();
}

class ScheduleState extends State<ScheduleWidget> {
  final List<Shift> turns = [];

  ScheduleState() : super() {
    for (Shift shift in baseShift){
      turns.add(shift);
    }

    for (Shift shift in baseShift){
      dev.log(name: tag, "Shifts: ${shift.start}/${shift.end} (${shift.deltaMinutes})");
    }

    for (Shift turn in turns){
      dev.log(name: tag, "Shifts: ${turn.start}/${turn.end} (${turn.deltaMinutes})");
    }
  }

  final List<Shift> baseShift = [
    Shift(
      start: TimeOfDay(hour: 8, minute: 0),
      end: TimeOfDay(hour: 13, minute: 0),
      turn: 1,
    ),
    Shift(
      start: TimeOfDay(hour: 14, minute: 20),
      end: TimeOfDay(hour: 18, minute: 8),
      turn: 1,
    ),
  ];

  List<Widget> getPunches(int i) {
    List<Widget> widgets = [];

    widgets.add(
      ButtonTimeWidget(
        text: turns[i].start.format(context),
        update: () async {
          final newTime = await timePicker(context, initialTime: turns[i].start);
          if (newTime != null) {
            setState(() => turns[i].start = newTime);
          }
        }
      ),
    );

    widgets.add(
      ButtonTimeWidget(
        text: turns[i].end.format(context),
        update: () async {
          final newTime = await timePicker(context, initialTime: turns[i].end);
          if (newTime != null) {
            setState(() => turns[i].end = newTime);
          }
        }
      ),
    );

    widgets.add(ButtonTimeWidget(text: minutesHourFormat(turns[i].deltaMinutes)));

    return widgets;
  }

  List<Widget> getTurns() {
    List<Widget> widgets = [];

    for (var i = 0; i < turns.length; i++) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: getPunches(i),
        )
      );
    }

    return widgets;
  }

  String getTotalDelta() {
    int totalDeltaMinutes = 0;
    for (final schedule in turns) {
      totalDeltaMinutes += schedule.deltaMinutes!;
    }

    dev.log(name: tag, "Turns: ${turns.length}");
    dev.log(name: tag, "totalDelta: $totalDeltaMinutes");

    return minutesHourFormat(totalDeltaMinutes);
  }

  void save() async {
    print(await getCurrentShift(DateTime.now()));
    for (var i = 0; i < turns.length; i++) {
      final schedule = turns[i];
      final _ = await upinsertCurrentShift(schedule);
    }

    final now = DateTime.now();
    final queryDate = DateTime(now.year, now.month, now.day);
    List<Shift> list = await getCurrentShift(queryDate);

    for (final item in list) {
      print("[${queryDate.toString()}]${item.start} -> ${item.end} (${item.deltaMinutes})");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        ...getTurns(),
        ButtonTimeWidget(text: getTotalDelta()),
        ButtonTimeWidget(
          text: "Save",
          update: save,
          bgColor: Colors.lightGreen,
        )
      ],
    );
  }
}
