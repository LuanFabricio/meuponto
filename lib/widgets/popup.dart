import 'package:flutter/material.dart';

import 'package:meuponto/services/database.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/widgets/button_time.dart';

const TimeOfDay defaultTimeOfDay = TimeOfDay(hour: 0, minute: 0);

List<Widget> shiftsToWidgets(
  List<Shift> shifts,
  BuildContext context,
  void Function(void Function()) setState
) {
  List<Widget> shiftsWidgets = [];
  for (var i = 0; i < shifts.length; i++) {
    shiftsWidgets.add(Row(
      spacing: 15,
      children: [
        ButtonTimeWidget(
          text: shifts[i].start.format(context),
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
          text: shifts[i].end.format(context),
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
          text: minutesHourFormat(shifts[i].deltaMinutes))
      ])
    );
  }

  return shiftsWidgets;
}

Future<void> _showPopup(BuildContext context, List<Shift> shifts) async {
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
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              )
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ...shiftsWidgets,
                  TextButton(
                    onPressed: () async {
                      setState(() =>
                        shifts.add(
                          Shift(
                            defaultTimeOfDay,
                            defaultTimeOfDay,
                            turn: shifts.length
                          )));
                    },
                    child: Text("Add")
                  ),
                  TextButton(
                    onPressed: () async {
                      for (final shift in shifts) {
                        insertShift(shift);
                      }
                    },
                    child: Text("Save")
                  ),
                ],
              )
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
  List<Shift> shifts = [
    Shift(
      TimeOfDay(hour: 8, minute: 0,),
      TimeOfDay(hour: 13, minute: 0),
      turn: 1,
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
          text: shifts[i].start.format(context),
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
          text: shifts[i].end.format(context),
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
          text: minutesHourFormat(shifts[i].deltaMinutes))
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
