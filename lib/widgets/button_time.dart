import 'package:flutter/material.dart';

class ButtonTimeWidget extends StatefulWidget {
  const ButtonTimeWidget({super.key});

  @override
  State<ButtonTimeWidget> createState() => ButtonTimeState();
}

class ButtonTimeState extends State<ButtonTimeWidget> {
  TimeOfDay? _time;

  void _updateTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

   @override
   Widget build(BuildContext context) {
    String buttonText = "-";
    String? format = _time?.format(context);
    if (format != null) {
      buttonText = format;
    }

    return TextButton(
      onPressed: _updateTime,
      child: Text(buttonText),
    );
   }
}
