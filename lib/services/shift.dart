import 'package:meuponto/services/format.dart';
import 'package:sqflite/sqflite.dart';

import 'package:meuponto/services/database.dart';

import 'package:meuponto/data/shift.dart';

Future<void> upinsertDefaultShift(Shift shift) async {
  final db = await initializeDB();
  final map = shift.toMap();
  map.remove("shift_date");
  await db.insert(
    tableDefaultShifts,
    map,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Shift>> listDefaultShifts() async {
  final db = await initializeDB();
  final list = await db.query(tableDefaultShifts);

  print("list.length: ${list.length}");
  print("list: $list");

  final shifts = <Shift>[];
  for (final obj in list) {
      print(obj);
      shifts.add(
        Shift(
          start: dbStringToTimeOfDay(obj["start"] as String),
          end: dbStringToTimeOfDay(obj["end"] as String),
          turn: obj["turn"] as int,
        )
      );
  }

  return shifts;
}

Future<int> upinsertCurrentShift(Shift shift) async {
  final db = await initializeDB();

  return db.insert(
    tableCurrentShifts,
    shift.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Shift>> listScheduleByDate(DateTime date) async {
  final db = await initializeDB();

  List<Shift> schedules = [];

  final list = await db.query(
    tableCurrentShifts,
    where: "shift_date = ?",
    whereArgs: [formatDate(date)],
    orderBy: "turn asc"
  );

  for (final obj in list) {
    print(obj.toString());
    schedules.add(
      Shift(
        start: dbStringToTimeOfDay(obj["start"] as String),
        end: dbStringToTimeOfDay(obj["end"] as String),
        turn: obj["turn"] as int));
  }

  return schedules;
}

Future<List<Shift>> getCurrentShift(DateTime date) async {
  date = DateTime(date.year, date.month, date.day);

  List<Shift> list = await listScheduleByDate(date);

  if (list.isEmpty) {
    for (final shift in await listDefaultShifts()) {
      upinsertCurrentShift(shift);
    }
    list = await listScheduleByDate(date);
  }

  return list;
}

Future<Map<DateTime, List<Shift>>> getLastWeekShifts(DateTime date) async {
  date = DateTime(date.year, date.month, date.day);
  Map<DateTime, List<Shift>> map = {};
  for (var i = 0; i < 7; i++) {
    final currentDate = date.add(Duration(days: -i));
    map[currentDate] = await getCurrentShift(currentDate);
  }

  return map;
}

Future<int> getDefaultShiftDeltaMinutes() async {
  List<Shift> defaultShifts = await listDefaultShifts();

  int totalDeltaMinutes = 0;
  for (final shift in defaultShifts) {
    totalDeltaMinutes += shift.deltaMinutes;
  }
  return totalDeltaMinutes;
}
