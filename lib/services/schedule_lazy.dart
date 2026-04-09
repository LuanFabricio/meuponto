import 'package:meuponto/services/shift.dart';

Future<Map<String, Object>> getWidgetData(DateTime date) async {
  return {
    "shifts": await getCurrentShift(date),
    "defaultDeltaMinutes": await getDefaultShiftDeltaMinutes(),
  };
}
