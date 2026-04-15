import 'package:flutter/material.dart';
import 'package:meuponto/services/calendar.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/widgets/button_time.dart';
import 'package:meuponto/widgets/shift.dart';

const double defaultSpacing = 10;

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarWidget> {
  List<CalendarData> shifts = [];

  Widget futureBuilder(BuildContext context, AsyncSnapshot<List<CalendarData>> snapshot) {
    final children = <Widget>[];

    if (snapshot.hasData) {
      shifts = snapshot.data!;
      for (final (date, dateShifts, totalMinutes, deltaMinutes) in shifts) {
        final shiftsWidgets = <Widget>[];
        for (final shift in dateShifts) {
          shiftsWidgets.add(
            Row(
              mainAxisAlignment: .center,
              spacing: defaultSpacing,
              children: [
                ShiftWidget(
                  shift: shift,
                  onUpdateStart: (){},
                  onUpdateEnd: (){}
                )
              ],
            )
          );
        }

        children.add(
          Column(
            children: [
              Text(formatDateHuman(date)),
              ...shiftsWidgets,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: defaultSpacing,
                children: [
                  ButtonTimeWidget(
                    text: formatMinutesToHour(totalMinutes),
                  ),
                  ButtonTimeWidget(
                    text: formatMinutesToHour(deltaMinutes, showSignal: true),
                  ),
                ]
              ),
            ],
          )
        );
      }
    } else if (snapshot.hasError) {
      children.add(Text("Erro: ${snapshot.error}"));
    } else {
      children.add(Text("Loading..."));
    }

    return ListView(children: children,);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCalendarWidgetData(DateTime.now()),
      builder: futureBuilder,
    );
  }
}
