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
      children.add(ButtonTimeWidget(text: minutesHourFormat(totalDeltaMinutes)));

      return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget buildLazy(BuildContext context, AsyncSnapshot<List<Shift>> snapshot) {
    print("Running buildLazy: ${snapshot.connectionState}");
    if (snapshot.hasData) {
      shifts = snapshot.data!;
      if (shifts.isEmpty) return Text("No shifts");

      for (final shift in shifts) {
        print(shift.toString());
      }
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
      future: getCurrentShift(DateTime.now()),
      builder: buildLazy,
      initialData: shifts,
    );
  }
}
