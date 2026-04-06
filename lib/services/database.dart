import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:meuponto/data/schedule.dart';

const String tag = "Database";

TimeOfDay dbStringToTimeOfDay(String format) {
  print("format: $format");
  List<String> properties = format.split(":");

  return TimeOfDay(
    hour: int.parse(properties[0]),
    minute: int.parse(properties[1]),
  );
}


Future<Database> initializeDB() async {
  final _ = WidgetsFlutterBinding.ensureInitialized();

  // await deleteDatabase(join(await getDatabasesPath(), "meu_ponto.db"));
  return openDatabase(
    join(await getDatabasesPath(), "meu_ponto.db"),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE shifts(turn int primary key, start time, end time, delta_minutes int);"
        "CREATE TABLE schedules(schedule_date datetime, start time, end time, delta_minutes int)");
    },
    version: 1,
  );
}

Future<int> insertSchedule(ScheduleData schedule) async {
  final db = await initializeDB();

  print("Schedule map: ${schedule.toMap()}");
  return db.insert(
    "schedules",
    schedule.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<ScheduleData>> listScheduleByDate(DateTime date) async {
  final db = await initializeDB();

  List<ScheduleData> schedules = [];

  final list = await db.query(
    "schedules",
    where: "schedule_date = ?",
    whereArgs: [date.toString()]
  );

  for (final obj in list) {
    print(obj.toString());
    ScheduleData schedule = ScheduleData();

    schedule.start = dbStringToTimeOfDay(obj["start"] as String);
    schedule.end = dbStringToTimeOfDay(obj["end"] as String);
    schedule.deltaMinutes = obj["delta_minutes"] as int;

    schedules.add(schedule);
  }

  return schedules;
}
