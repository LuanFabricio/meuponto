import 'package:meuponto/data/shift.dart';
import 'package:meuponto/services/shift.dart';

typedef CalendarData = (DateTime, List<Shift>, int, int);

Future<List<CalendarData>> getCalendarWidgetData(DateTime date) async {
  final deltaTimes = <CalendarData>[];

  final defaultShiftMinutes = await getDefaultShiftDeltaMinutes();
  final lastWeekShifts = await getLastWeekShifts(date);
  for (final currentDate in lastWeekShifts.keys) {
    int totalMinutes = 0;
    final dateShifts = lastWeekShifts[currentDate]!;
    for (final shift in lastWeekShifts[currentDate]!) {
      totalMinutes += shift.deltaMinutes;
    }
    final shiftMinutesDiff = defaultShiftMinutes - totalMinutes;
    deltaTimes.add(
      (currentDate, dateShifts, totalMinutes, shiftMinutesDiff)
    );
  }

  return deltaTimes;
}
