import 'package:flutter/material.dart';

import 'package:meuponto/data/shift.dart';

import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/shift.dart';
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

Future<void> showDefaultShiftsPopup(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return FutureBuilder(future: listDefaultShifts(),
        builder: (BuildContext context, AsyncSnapshot<List<Shift>> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          List<Shift> shifts = snapshot.data!;
          return StatefulBuilder(
            builder: (context, setState) {
              List<Widget> shiftsWidgets = shiftsToWidgets(shifts, context, setState);
              return AlertDialog(
                title: const Text("Set your default shift."),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () async {
                      for (final shift in shifts) {
                        upinsertDefaultShift(shift);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("Save"),
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
                                start: defaultTimeOfDay,
                                end: defaultTimeOfDay,
                                turn: shifts.length + 1,
                              )));
                        },
                        child: Text("Add")
                      ),
                      // TextButton(
                      //   onPressed: () async {
                      //     for (final shift in shifts) {
                      //       upinsertDefaultShift(shift);
                      //     }
                      //   },
                      //   child: Text("Save")
                      // ),
                    ],
                  )
                ),
              );
            }
          );
        }
        return Text("Loading...");
      }
    );
  });
}

class PopupDefaultShiftsWidget extends StatefulWidget {
  const PopupDefaultShiftsWidget({super.key});

  @override
  State<PopupDefaultShiftsWidget> createState() => PopupDefaultShiftsState();
}

class PopupDefaultShiftsState extends State<PopupDefaultShiftsWidget> {
  void _showPopup() async {
    await showDefaultShiftsPopup(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(onPressed: _showPopup, label: const Text("Edit shifts"));
  }
}
