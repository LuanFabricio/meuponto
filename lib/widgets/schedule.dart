import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meuponto/data/schedule.dart';
import 'package:meuponto/widgets/button_time2.dart';

class ScheduleWidget extends StatefulWidget {
	const ScheduleWidget({super.key});

	@override
	State<ScheduleWidget> createState() => ScheduleState();
}

class ScheduleState extends State<ScheduleWidget> {
	final Schedule schedule = Schedule();

  Future<TimeOfDay?>  _newTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

  }

  void update() {
    setState(() {
      schedule.addTime();
    });
  }

  void updateStart() async {
    final TimeOfDay? newTime = await _newTime();
    if (newTime != null) {
      setState(() {
        schedule.start = newTime;
      });
    }
  }

  void updateEnd() async {
    final TimeOfDay? newTime = await _newTime();

    if (newTime != null) {
      setState(() {
        schedule.start = newTime;
      });
    }
  }

	@override
	Widget build(BuildContext context) {
    List<Widget> widgets = [
        ButtonTime2Widget(
          text: "teste",
          update: update,
        ),
    ];

    if (schedule.start != null) {
      widgets.add(
        ButtonTime2Widget(
          text: schedule.start!.format(context),
          update: updateStart,
        ));
    }
    if (schedule.end != null) {
      widgets.add(
        ButtonTime2Widget(
          text: schedule.end!.format(context),
          update: updateEnd,
        ));
    }

    if (schedule.delta != null) {
      widgets.add(Text(schedule.delta!.format(context)));
    }

		return Row(
			children: widgets,
		);
	}
}
