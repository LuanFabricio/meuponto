import 'package:flutter/material.dart';

import 'package:meuponto/data/shift.dart';
import 'package:meuponto/services/format.dart';
import 'package:meuponto/services/shift.dart';
import 'package:meuponto/services/time_picker.dart';
import 'package:meuponto/widgets/button_time.dart';

class ShiftWidget extends StatefulWidget {
  final Shift shift;
  final int defaultDeltaMinutes;
  const ShiftWidget({super.key, required this.shift, required this.defaultDeltaMinutes});

  @override
  State<StatefulWidget> createState() => _ShiftState();
}

class _ShiftState extends State<ShiftWidget> {
  List<Widget> getShiftTime() {
    return [
      ButtonTimeWidget(
        text: widget.shift.start.format(context),
        update: () async {
          final newTime = await timePicker(
            context,
            initialTime: widget.shift.start,
          );
          if (newTime != null) {
            widget.shift.start = newTime;
            await upinsertCurrentShift(widget.shift);
            setState(() { });
          }
        },
      ),
      ButtonTimeWidget(
        text: widget.shift.end.format(context),
        update: () async {
          final newTime = await timePicker(
            context,
            initialTime: widget.shift.end,
          );
          if (newTime != null) {
            widget.shift.end = newTime;
            await upinsertCurrentShift(widget.shift);
            setState(() { });
          }
        },
      ),
    ];
  }

  List<Widget> getSpendTime() {
    return [
      ButtonTimeWidget(
        text: formatMinutesToHour(widget.shift.deltaMinutes),
      ),
      ButtonTimeWidget(
        text: formatMinutesToHour(widget.shift.deltaMinutes - widget.defaultDeltaMinutes),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2.5,
      children: [
        Row(
          spacing: 10,
          children: getShiftTime(),
        ),
        Row(
          spacing: 10,
          children: getSpendTime(),
        )
      ],
    );
  }
}
