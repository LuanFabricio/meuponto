import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tag = "Database";

TimeOfDay dbStringToTimeOfDay(String format) {
  List<String> properties = format.split(":");

  return TimeOfDay(
    hour: int.parse(properties[0]),
    minute: int.parse(properties[1]),
  );
}

class Shift {
  Shift({required this.date, required this.start, required this.end, required this.deltaMinutes});

  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  final int deltaMinutes;

  Map<String, Object?> toMap() {
    return {
      "shift_date": date.toString(),
      "start": start.toString(),
      "end": end.toString(),
      "delta_minutes": deltaMinutes,
    };
  }

  @override
  String toString() {
    return "date: ${date.toString()} "
      "start: ${start.toString()} "
      "end: ${end.toString()} "
      "delta_minutes: $deltaMinutes "
    ;
  }
}


Future<Database> initializeDB() async {
  final _ = WidgetsFlutterBinding.ensureInitialized();

  return openDatabase(
    join(await getDatabasesPath(), "my_shift.db"),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE shifts(shift_date datetime, start time, end time, delta_minutes int);");
    },
    version: 1,
  );
}

Future<void> insertShift(Shift shift) async {
  final db = await initializeDB();
  await db.insert(
    "shifts",
    shift.toMap(),
    conflictAlgorithm: ConflictAlgorithm.fail,
  );
}

Future<List<Shift>> listShifts() async {
  final db = await initializeDB();
  final list = await db.query("shifts");

  print("list.length: ${list.length}");

  return [
    for (final s in list)
      Shift(
        date: DateTime.parse(s["shift_date"] as String),
        deltaMinutes: s["delta_minutes"] as int,
        start: dbStringToTimeOfDay(["start"] as String),
        end: dbStringToTimeOfDay(["end"] as String),
      ),
  ];
}
