import 'package:flutter/material.dart';

import 'package:meuponto/data/schedule.dart';
import 'package:meuponto/widgets/button_time2.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => ScheduleState();
}

class ScheduleState extends State<ScheduleWidget> {
  // TODO: Use this list as default values,
  // and makes the punch button just update
  // the current shift
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

  final List<ScheduleData> turns = [];

  ScheduleState() : super() {
    for (ScheduleData shift in baseShift){
      final ScheduleData schedule = ScheduleData.fromSchedule(shift);
      schedule.isComplete = false;
      turns.add(schedule);
    }

    for (ScheduleData shift in baseShift){
      print("Shifts: ${shift.start}/${shift.end} (${shift.delta}) - ${shift.isComplete}");
    }

    for (ScheduleData turn in turns){
      print("Shifts: ${turn.start}/${turn.end} (${turn.delta}) - ${turn.isComplete}");
    }
  }

  Future<TimeOfDay?> _newTime({TimeOfDay? initialTime}) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
  }

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

    if (turns[i].delta != null) {
      widgets.add(ButtonTime2Widget(text: turns[i].delta!.format(context)));
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
    double totalDelta = 0;
    for (ScheduleData schedule in turns) {
      if (schedule.delta == null) continue;
      totalDelta += schedule.delta!.hour + schedule.delta!.minute / 60.0;
    }

    String totalTime = "";
    final int hour = totalDelta.floor();
    if (hour > 0) {
      totalTime += hour.toString().padLeft(2, '0');
    } else {
      totalTime += "00";
    }

    final int minutes = ((totalDelta - hour) * 60).ceil();
    totalTime += ":${minutes.toString().padLeft(2, '0')}";
    print("Turns: ${turns.length}");
    print("totalDelta: $totalDelta");

    return totalTime;
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
      ],
    );
  }
}
