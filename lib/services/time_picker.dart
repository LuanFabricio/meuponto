  import 'package:flutter/material.dart';


Future<TimeOfDay?> timePicker(BuildContext context, {TimeOfDay? initialTime}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    initialEntryMode: TimePickerEntryMode.inputOnly,
  );
}
