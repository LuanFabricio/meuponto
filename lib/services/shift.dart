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

  final shifts = <Shift>[];
  for (var i = 0; i < list.length; i++) {
      final shift = list[i];
      shifts.add(
        Shift(
          dbStringToTimeOfDay(shift["start"] as String),
          dbStringToTimeOfDay(shift["end"] as String),
          turn: i+1,
        )
      );
  }

  return shifts;
}

Future<int> insertCurrentShift(Shift shift) async {
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
        dbStringToTimeOfDay(obj["start"] as String),
        dbStringToTimeOfDay(obj["end"] as String),
        turn: obj["turn"] as int));
  }

  return schedules;
}

Future<List<Shift>> getCurrentShift(DateTime date) async {
  date = DateTime(date.year, date.month, date.day);

  List<Shift> list = await listScheduleByDate(date);

  if (list.isEmpty) {
    for (final shift in await listDefaultShifts()) {
      insertCurrentShift(shift);
    }
    list = await listScheduleByDate(date);
  }

  return list;
}
