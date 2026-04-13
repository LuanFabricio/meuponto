import 'package:flutter/material.dart';
import 'package:meuponto/services/calendar.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/widgets/button_time.dart';

const double defaultSpacing = 10;

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  Widget futureBuilder(BuildContext context, AsyncSnapshot<List<CalendarData>> snapshot) {
    final children = <Widget>[];

    if (snapshot.hasData) {
      for (final (date, dateShifts, totalMinutes, deltaMinutes) in snapshot.data!) {
        final shiftsWidgets = <Widget>[];
        for (final shift in dateShifts) {
          shiftsWidgets.add(
            Row(
              mainAxisAlignment: .center,
              spacing: defaultSpacing,
              children: [
                ButtonTimeWidget(
                  text: shift.start.format(context),
                  update: () { },
                ),
                ButtonTimeWidget(
                  text: shift.end.format(context),
                  update: () { },
                )
              ]
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
