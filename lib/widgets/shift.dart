import 'package:flutter/material.dart';

import 'package:meuponto/data/shift.dart';
import 'package:meuponto/widgets/button_time.dart';
/*
class ShiftWidget extends StatefulWidget {
  final Shift shift;
  const ShiftWidget({super.key, required this.shift});

  @override
  State<StatefulWidget> createState() => _ShiftState();
}
*/

class ShiftWidget extends StatelessWidget {
  const ShiftWidget({
    super.key,
    required this.shift,
    required this.onUpdateStart,
    required this.onUpdateEnd,
  });

  final Shift shift;
  final Function() onUpdateStart;
  final Function() onUpdateEnd;

  List<Widget> getShiftTime(BuildContext context) {
    return [
      ButtonTimeWidget(
        text: shift.start.format(context),
        update: onUpdateStart,
      ),
      ButtonTimeWidget(
        text: shift.end.format(context),
        update: onUpdateEnd,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: getShiftTime(context),
    );
  }
}
