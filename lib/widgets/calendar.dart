import 'package:flutter/material.dart';
import 'package:meuponto/data/shift.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/shift.dart';
import 'package:meuponto/widgets/button_time.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  Widget futureBuilder(BuildContext context, AsyncSnapshot<Map<DateTime, List<Shift>>> snapshot) {
    final children = <Widget>[];

    if (snapshot.hasData) {
      print(snapshot.data!);
      for (final key in snapshot.data!.keys) {
        children.add(Text(formatDateHuman(key)));
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
      future: getLastWeekShifts(),
      builder: futureBuilder,
    );
  }
}
