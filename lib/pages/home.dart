import 'package:flutter/material.dart';

import 'package:meuponto/pages/calendar.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/widgets/popup_default_shifts.dart';
import 'package:meuponto/widgets/schedule_lazy.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _headerFontSize = 32.0;
  static const _paddingHeight = 48.0;

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
          setState(() {});
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
              ScheduleLazyWidget(),
              // CalendarWidget(),
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
