import 'package:flutter/material.dart';
import 'package:meuponto/data/schedule.dart';
import 'package:meuponto/services/database.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/widgets/button_time2.dart';

class ScheduleLazyWidget extends StatefulWidget {
  const ScheduleLazyWidget({super.key});

  @override
  State<ScheduleLazyWidget> createState() => ScheduleLazyState();
}

class ScheduleLazyState extends State<ScheduleLazyWidget> {
  List<ScheduleData> schedules = [];

  Widget schedulesWidget() {
      List<Widget> children = [];
      for (final schedule in schedules) {
        children.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTime2Widget(
                text: schedule.start!.format(context),
                // TODO: Check how to handle the update state
                update: () async {
                  final newTime = await timePicker(context, initialTime: schedule.start);
                  if (newTime != null) {
                    setState(() => schedule.start = newTime);
                  }
                },
              ),
              ButtonTime2Widget(
                text: schedule.end!.format(context),
                update: () async {
                  final newTime = await timePicker(context, initialTime: schedule.end);
                  if (newTime != null) {
                    setState(() => schedule.end = newTime);
                  }
                },
              ),
              ButtonTime2Widget(
                text: minutesHourFormat(schedule.deltaMinutes!),
              )
            ]
          )
        );
      }

      return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget buildLazy(BuildContext context, AsyncSnapshot<List<ScheduleData>> snapshot) {
    print("Running buildLazy: ${snapshot.connectionState}");
    if (snapshot.hasData) {
      schedules = snapshot.data!;
      if (schedules.isEmpty) return Text("No shifts");

      return schedulesWidget();
    } else if (snapshot.hasError) {
      return Text("Error ${snapshot.error}");
    }
    return Text("Loading...");
  }

  @override
  Widget build(BuildContext context) {
    if (schedules.isNotEmpty) {
      return schedulesWidget();
    }

    return FutureBuilder(
      future: listScheduleByDate(DateTime(2026, 3, 30)),
      builder: buildLazy,
      initialData: schedules,
    );
  }
}
