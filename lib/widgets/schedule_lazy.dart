import 'package:flutter/material.dart';

import 'package:meuponto/data/shift.dart';

import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/schedule_lazy.dart';
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
  int defaultDeltaMinutes = 0;

  Widget schedulesWidget() {
      List<Widget> children = [];
      int totalDeltaMinutes = 0;
      for (var i = 0; i < shifts.length; i++) {
        print("Current shift: ${shifts[i].toString()}");
        totalDeltaMinutes += shifts[i].deltaMinutes;
        children.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTimeWidget(
                text: shifts[i].start.format(context),
                update: () async {
                  final newTime = await timePicker(context, initialTime: shifts[i].start);
                  if (newTime != null) {
                    setState(() {
                      shifts[i].start = newTime;
                    });
                    await upinsertCurrentShift(shifts[i]);
                  }
                },
              ),
              ButtonTimeWidget(
                text: shifts[i].end.format(context),
                update: () async {
                  final newTime = await timePicker(context, initialTime: shifts[i].end);
                  if (newTime != null) {
                    setState(() {
                      shifts[i].end = newTime;
                    });
                    await upinsertCurrentShift(shifts[i]);
                  }
                },
              ),
              ButtonTimeWidget(
                text: minutesHourFormat(shifts[i].deltaMinutes),
              )
            ]
          )
        );
      }

      final remainingMinutes = defaultDeltaMinutes - totalDeltaMinutes;
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ButtonTimeWidget(text: minutesHourFormat(totalDeltaMinutes)),
            ButtonTimeWidget(text: minutesHourFormat(remainingMinutes)),
          ],
        )
      );

      return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget buildLazy(BuildContext context, AsyncSnapshot<Map<String, Object>> snapshot) {
    print("Running buildLazy: ${snapshot.connectionState}");
    if (snapshot.hasData) {
      shifts = snapshot.data!["shifts"] as List<Shift>;
      defaultDeltaMinutes = snapshot.data!["defaultDeltaMinutes"] as int;

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
      future: getWidgetData(DateTime.now()),
      builder: buildLazy,
      initialData: {"shifts": <Shift>[], "defaultDeltaMinutes": 0},
    );
  }
}
