import 'package:flutter/material.dart';
import 'package:meuponto/services/database.dart';
import 'package:meuponto/widgets/button_time2.dart';

class ScheduleLazyWidget extends StatefulWidget {
  const ScheduleLazyWidget({super.key});

  @override
  State<ScheduleLazyWidget> createState() => ScheduleLazyState();
}

class ScheduleLazyState extends State<ScheduleLazyWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listShifts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          List<Shift> shifts = snapshot.data!;
          if (shifts.isEmpty) return Text("No shifts");
          return ButtonTime2Widget(text: shifts[0].toString());
        }
        return Text("Loading...");
      }
    );
  }
}
