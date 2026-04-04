import 'package:flutter/material.dart';
import 'package:meuponto/data/schedule.dart';
import 'package:meuponto/services/database.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/widgets/button_time.dart';

List<Widget> shiftsToWidgets(
  List<ScheduleData> shifts,
  BuildContext context,
  void Function(void Function()) setState
) {
  List<Widget> shiftsWidgets = [];
  for (var i = 0; i < shifts.length; i++) {
    shiftsWidgets.add(Row(
      children: [
        ButtonTimeWidget(
          text: shifts[i].start!.format(context),
          update: () async {
            final newTime = await timePicker(
              context, initialTime: shifts[i].start
            );
            if (newTime != null) {
              shifts[i].start = newTime;
              setState(() => shifts[i].start = newTime);
            }
          }
        ),
        ButtonTimeWidget(
          text: shifts[i].end!.format(context),
          update: () async {
            final newTime = await timePicker(
              context, initialTime: shifts[i].end
            );
            if (newTime != null) {
              setState(() => shifts[i].end = newTime);
            }
          }
        ),
        ButtonTimeWidget(
          text: minutesHourFormat(shifts[i].deltaMinutes!))
      ])
    );
  }

  return shiftsWidgets;
}

Future<void> _showPopup(BuildContext context, List<ScheduleData> shifts) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          List<Widget> shiftsWidgets = shiftsToWidgets(shifts, context, setState);
          return AlertDialog(
            title: const Text("Set your default shift."),
            actions: [
              TextButton(
                onPressed: () {
                  for (var i = 0; i < shifts.length; i++) {
                    final shift = shifts[i];
                    print("$i: ${shift.start!.format(context)} "
                      "- ${shift.end!.format(context)} "
                      "(${minutesHourFormat(shift.deltaMinutes!)})}");
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              )
            ],
            content: SingleChildScrollView(
              child: Column(children: shiftsWidgets)
            ),
          );
      }
    );
  });
}

class PopupWidget extends StatefulWidget {
  const PopupWidget({super.key});

  @override
  State<PopupWidget> createState() => PopupState();
}

class PopupState extends State<PopupWidget> {
  List<ScheduleData> shifts = [
    ScheduleData.fromTime(
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
    )
  ];

  void showPopup() async {
    print("Abrindo popup...");

    await _showPopup(context, shifts);
  }

  Widget getPopupWidget() {
    List<List<Widget>> shiftsWidgets = [];
    for (var i = 0; i < shifts.length; i++) {
      shiftsWidgets.add([
        ButtonTimeWidget(
          text: shifts[i].start!.format(context),
          update: () async {
            final newTime = await timePicker(
              context,
              initialTime: shifts[i].start
            );
            if (newTime != null) {
              shifts[i].start = newTime;
              setState(() => shifts[i].start = newTime);
            }
          }
        ),
        ButtonTimeWidget(
          text: shifts[i].end!.format(context),
          update: () async {
            final newTime = await timePicker(
              context,
              initialTime: shifts[i].end
            );
            if (newTime != null) {
              setState(() => shifts[i].end = newTime);
            }
          }
        ),
        ButtonTimeWidget(
          text: minutesHourFormat(shifts[i].deltaMinutes!))
      ]);
    }

    return ListBody(
      children: shiftsWidgets.map(
        (turn) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: turn
        )
      ).toList(growable: false)
    );
  }
@override
  Widget build(BuildContext context) {
    return TextButton.icon(onPressed: showPopup, label: const Text("Edit shifts"));
  }
}
