import 'package:flutter/material.dart';
import 'package:meuponto/services/calendar.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/widgets/button_time.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  Widget futureBuilder(BuildContext context, AsyncSnapshot<List<(DateTime, int, int)>> snapshot) {
    final children = <Widget>[];

    if (snapshot.hasData) {
      for (final (date, totalMinutes, deltaMinutes) in snapshot.data!) {
        children.add(
          Column(
            children: [
              Text(formatDateHuman(date)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10),
                    child: ButtonTimeWidget(
                      text: minutesHourFormat(totalMinutes),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10),
                    child: ButtonTimeWidget(
                      text: minutesHourFormat(deltaMinutes, showSignal: true),
                    ),
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

    return Column(children: children,);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCalendarWidgetData(DateTime.now()),
      builder: futureBuilder,
    );
  }
}
