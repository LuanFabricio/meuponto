import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:meuponto/data/schedule.dart';
import 'package:meuponto/services/database.dart';
import 'package:meuponto/widgets/button_time2.dart';

const String tag = "ScheduleWidget";

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => ScheduleState();
}

class ScheduleState extends State<ScheduleWidget> {
  final List<ScheduleData> turns = [];

  ScheduleState() : super() {
    for (ScheduleData shift in baseShift){
      final ScheduleData schedule = ScheduleData.fromSchedule(shift);
      schedule.isComplete = false;
      turns.add(schedule);
    }

    for (ScheduleData shift in baseShift){
      dev.log(name: tag, "Shifts: ${shift.start}/${shift.end} (${shift.deltaMinutes}) - ${shift.isComplete}");
    }

    for (ScheduleData turn in turns){
      dev.log(name: tag, "Shifts: ${turn.start}/${turn.end} (${turn.deltaMinutes}) - ${turn.isComplete}");
    }
  }

  final List<ScheduleData> baseShift = [
    ScheduleData.fromTime(
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 13, minute: 0)
    ),
    ScheduleData.fromTime(
      TimeOfDay(hour: 14, minute: 20),
      TimeOfDay(hour: 18, minute: 8)
    )
  ];

  void updateSchedule() {
    setState(() {
      int lastIndex = turns.length - 1;
      if (turns.isEmpty || turns[lastIndex].isShiftFilled()) {
        turns.add(ScheduleData());
        lastIndex++;
      }

      turns[lastIndex].addTime();
    });
  }

  List<Widget> getPunches(int i) {
    List<Widget> widgets = [];

    if (turns[i].start != null) {
      widgets.add(
        ButtonTime2Widget(
          text: turns[i].start!.format(context),
          update: () async {
            final TimeOfDay? newTime = await _newTime(initialTime: turns[i].start);
            if (newTime != null) {
              setState(() => turns[i].start = newTime);
            }
          },
        ),
      );
    }
    if (turns[i].end != null) {
      widgets.add(
        ButtonTime2Widget(
          text: turns[i].end!.format(context),
          update: () async {
            final TimeOfDay? newTime = await _newTime(initialTime: turns[i].end);
            if (newTime != null) {
              setState(() => turns[i].end = newTime);
            }
          },
        ),
      );
    }

    if (turns[i].deltaMinutes != null) {
      widgets.add(ButtonTime2Widget(text: ScheduleData.minutesToString(turns[i].deltaMinutes!)));
    }

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
    for (ScheduleData schedule in turns) {
      if (schedule.deltaMinutes == null) continue;
      totalDeltaMinutes += schedule.deltaMinutes!;
    }

    dev.log(name: tag, "Turns: ${turns.length}");
    dev.log(name: tag, "totalDelta: $totalDeltaMinutes");

    return ScheduleData.minutesToString(totalDeltaMinutes);
  }

  void save() async {
    for (final schedule in turns) {
      final _ = await insertSchedule(schedule);
    }

    final now = DateTime.now();
    final queryDate = DateTime(now.year, now.month, now.day);
    List<ScheduleData> list = await listScheduleByDate(queryDate);

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
        ButtonTime2Widget(text: "Punch", update: updateSchedule),
        ...getTurns(),
        ButtonTime2Widget(text: getTotalDelta()),
        ButtonTime2Widget(
          text: "Save",
          update: save,
          bgColor: Colors.lightGreen,
        )
      ],
    );
  }

  Future<TimeOfDay?> _newTime({TimeOfDay? initialTime}) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
  }
}
