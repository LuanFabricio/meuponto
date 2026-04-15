import 'package:flutter/material.dart';
import 'package:meuponto/data/shift.dart';

import 'package:meuponto/pages/calendar.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/schedule_lazy.dart';
import 'package:meuponto/services/shift.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/widgets/button_time.dart';
import 'package:meuponto/widgets/popup_default_shifts.dart';
import 'package:meuponto/widgets/schedule_lazy.dart';
import 'package:meuponto/widgets/shift.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _headerFontSize = 32.0;
  static const _paddingHeight = 48.0;

  List<Shift> shifts = [];
  int defaultDeltaMinutes = 0;

  Widget getShiftsWidget() {
    int totalDeltaMinutes = 0;
    final children = <Widget>[];
    for (var i = 0; i < shifts.length; i++) {
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
                  }); await upinsertCurrentShift(shifts[i]);
                }
              },
            ),
            ButtonTimeWidget(
              text: formatMinutesToHour(shifts[i].deltaMinutes),
            )
          ]
        )
      );
    }

    final remainingMinutes = totalDeltaMinutes - defaultDeltaMinutes;
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          ButtonTimeWidget(text: formatMinutesToHour(totalDeltaMinutes)),
          ButtonTimeWidget(text: formatMinutesToHour(remainingMinutes, showSignal: true)),
        ],
      )
    );

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget builderCurrentShift(BuildContext context, AsyncSnapshot<Map<String, Object?>> snapshot) {
    Widget widget = Text("Loading...");
    if (snapshot.hasError) {
      widget = Text("Error: ${snapshot.error}");
    } else if (snapshot.hasData) {
      shifts = snapshot.data!["shifts"] as List<Shift>;
      defaultDeltaMinutes = snapshot.data!["defaultDeltaMinutes"] as int;

      widget = getShiftsWidget();
    }

    return Center(child: widget);
  }

  Widget getCurrentShift() {
    return FutureBuilder(
      future: getWidgetData(DateTime.now()),
      builder: builderCurrentShift,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarPage(title: "Calendar")
                )
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final shiftData = await getWidgetData(DateTime.now());
          setState(() {
            shifts = shiftData["shifts"] as List<Shift>;
            defaultDeltaMinutes = shiftData["defaultDeltaMinutes"] as int;
          });
        },
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Center(
                child: Text(
                  formatDateHuman(DateTime.now()),
                  style: TextStyle(fontSize: _headerFontSize),
                ),
              ),
              SizedBox(height: _paddingHeight),
              getCurrentShift(),
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDefaultShiftsPopup(context);
        },
        tooltip: 'Settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
