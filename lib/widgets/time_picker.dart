import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({super.key});

  @override
  State<TimePickerWidget> createState() => TimePickerState();
}

class TimePickerState extends State<TimePickerWidget> {
  final List<TimeOfDay> _time = [];

  void _selectTime() async {
    if (_time.length >= 3) return;

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (newTime != null) {
      setState(() {
        _time.add(newTime);
        if (_time.length == 2) {
          final double start = _time[0].hour + _time[0].minute / 60.0;
          final double end = _time[1].hour + _time[1].minute / 60.0;
          final double deltaTime = end - start;

          final int hour = deltaTime.floor();
          final int minute = (deltaTime - hour.toDouble()).toInt();

          _time.add(TimeOfDay(hour: hour, minute: minute));
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
    ];

    for (final time in _time) {
      children.add(Text(time.format(context)));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          spacing: 10.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
        SizedBox(height: 8,),
        ElevatedButton(
          onPressed: _selectTime,
          child: Text("Select Time"),
        ),
      ],
    );
  }
}
