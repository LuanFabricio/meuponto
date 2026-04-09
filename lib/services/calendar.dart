
import 'package:meuponto/services/shift.dart';

Future<List<(DateTime, int, int)>> getCalendarWidgetData(DateTime date) async {
  final deltaTimes = <(DateTime, int, int)>[];

  final defaultShiftMinutes = await getDefaultShiftDeltaMinutes();
  final lastWeekShifts = await getLastWeekShifts(date);
  for (final currentDate in lastWeekShifts.keys) {
    int totalMinutes = 0;
    for (final shift in lastWeekShifts[currentDate]!) {
      totalMinutes += shift.deltaMinutes;
    }
    final shiftMinutesDiff = defaultShiftMinutes - totalMinutes;
    deltaTimes.add((currentDate, totalMinutes, shiftMinutesDiff));
  }

  return deltaTimes;
}
