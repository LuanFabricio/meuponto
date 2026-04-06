import 'package:flutter/material.dart';

import 'package:meuponto/data/shift.dart';

import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/shift.dart';
import 'package:meuponto/services/time_picker.dart';

import 'package:meuponto/widgets/button_time.dart';

class ScheduleLazyWidget extends StatefulWidget {
  const ScheduleLazyWidget({super.key});

  @override
  State<ScheduleLazyWidget> createState() => ScheduleLazyState();
}

class ScheduleLazyState extends State<ScheduleLazyWidget> {
  List<Shift> shifts = [];

  Widget schedulesWidget() {
      List<Widget> children = [];
      for (final schedule in shifts) {
        children.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTimeWidget(
                text: schedule.start.format(context),
                update: () async {
                  final newTime = await timePicker(context, initialTime: schedule.start);
                  if (newTime != null) {
                    setState(() => schedule.start = newTime);
                  }
                },
              ),
              ButtonTimeWidget(
                text: schedule.end.format(context),
                update: () async {
                  final newTime = await timePicker(context, initialTime: schedule.end);
                  if (newTime != null) {
                    setState(() => schedule.end = newTime);
                  }
                },
              ),
              ButtonTimeWidget(
                text: minutesHourFormat(schedule.deltaMinutes),
              )
            ]
          )
        );
      }

      return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget buildLazy(BuildContext context, AsyncSnapshot<List<Shift>> snapshot) {
    print("Running buildLazy: ${snapshot.connectionState}");
    if (snapshot.hasData) {
      shifts = snapshot.data!;
      if (shifts.isEmpty) return Text("No shifts");

      return schedulesWidget();
    } else if (snapshot.hasError) {
      return Text("Error ${snapshot.error}");
    }
    return Text("Loading...");
  }

  @override
  Widget build(BuildContext context) {
    if (shifts.isNotEmpty) {
      return schedulesWidget();
    }

    return FutureBuilder(
      future: listDefaultShifts(),
      builder: buildLazy,
      initialData: shifts,
    );
  }
}
