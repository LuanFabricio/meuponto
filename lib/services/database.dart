import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tag = "Database";

const String tableDefaultShifts = "default_shifts";
const String tableCurrentShifts = "current_shifts";

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
  final dbFilename = "meu_ponto.db";

  // await deleteDatabase(join(await getDatabasesPath(), dbFilename));
  return openDatabase(
    join(await getDatabasesPath(), dbFilename),
    onCreate: (db, version) async {
      await db.execute("CREATE TABLE $tableDefaultShifts(turn int primary key, start time, end time, delta_minutes int);");
      await db.execute(
        "CREATE TABLE $tableCurrentShifts(shift_date date, turn int, start time, end time, delta_minutes int,"
        "primary key(shift_date, turn));");
    },
    version: 1,
  );
}
