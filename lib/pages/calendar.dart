import 'package:flutter/material.dart';
import 'package:meuponto/data/shift.dart';
import 'package:meuponto/services/calendar.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/shift.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/widgets/button_time.dart';
import 'package:meuponto/widgets/calendar.dart';
import 'package:meuponto/widgets/shift.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<CalendarData> calendarShifts = [];

  Widget getShiftWidget(CalendarData data, final int index) {
    final (date, dateShifts, totalMinutes, deltaMinutes) = data;
    final shiftsWidgets = <Widget>[];
    for (var i = 0; i < dateShifts.length; i++) {
      shiftsWidgets.add(
        Row(
          mainAxisAlignment: .center,
          children: [
            ShiftWidget(
              shift: calendarShifts[index].$2[i],
              onUpdateStart: () async {
                final newTime = await timePicker(
                  context,
                  initialTime: calendarShifts[index].$2[i].start
                );
                if (newTime != null) {
                  setState(() {
                    calendarShifts[index].$2[i].start = newTime;
                    upinsertCurrentShift(calendarShifts[index].$2[i]);
                  });
                }
              },
              onUpdateEnd: () async {
                final newTime = await timePicker(
                  context,
                  initialTime: calendarShifts[index].$2[i].end
                );
                if (newTime != null) {
                  setState(() {
                    calendarShifts[index].$2[i].end = newTime;
                    upinsertCurrentShift(calendarShifts[index].$2[i]);
                  });
                }
              },
            )
          ]
        )
      );
    }

    return (
      Column(
        mainAxisAlignment: .center,
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
          ]),
        ],)
    );
  }

  Widget futureBuilder(BuildContext context, AsyncSnapshot<List<CalendarData>> snapshot) {
    Widget widget = Text("Loading...");

    if (snapshot.hasError) {
      widget = Text("Error: ${snapshot.error}");
    } else if (snapshot.hasData) {
      calendarShifts = snapshot.data!;

      final children = <Widget>[];
      for (var i = 0; i < calendarShifts.length; i++) {
        children.add(getShiftWidget(calendarShifts[i], i));
      }
      widget = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: children,
      );
    }

    return RefreshIndicator(
        onRefresh: () async {
          setState(() async {
            calendarShifts = await getCalendarWidgetData(DateTime.now());
            print(calendarShifts);
          });
        },
        child: Center(child: widget),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getCalendarWidgetData(DateTime.now()),
        builder: futureBuilder,
      ),
    );
  }
}
