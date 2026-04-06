import 'package:sqflite/sqflite.dart';

import 'package:meuponto/services/database.dart';

import 'package:meuponto/data/shift.dart';

Future<void> insertShift(Shift shift) async {
  final db = await initializeDB();
  await db.insert(
    "shifts",
    shift.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Shift>> listShifts() async {
  final db = await initializeDB();
  final list = await db.query("shifts");

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
