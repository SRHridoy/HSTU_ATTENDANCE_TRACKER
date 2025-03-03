import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CourseDBHelper {
  /// Singleton Class:
  CourseDBHelper._();

  static final CourseDBHelper getInstance = CourseDBHelper._();

  ///var for course table:
  static final String TABLE_COURSE = 'course';
  static final String COLUMN_COURSE_SNO = 'course_sno';
  static final String COLUMN_COUSE_CODE = 'course_code';
  static final String COLUMN_COUSE_NAME = 'course_name';
  static final String COLUMN_BATCH_NAME = 'batch_no';
  static final String COLUMN_SESSION = 'session';
  static final String COLUMN_CREDIT = "credit";

  Database? myDb;

  Future<Database> getDB() async {
    myDb ??= await createDB();
    return myDb!;
  }

  Future<Database> createDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'courseDB.db');

    return await openDatabase(dbPath, onCreate: (db, version) {
      db.execute('''
      CREATE TABLE $TABLE_COURSE(
        $COLUMN_COURSE_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_COUSE_CODE TEXT,
        $COLUMN_COUSE_NAME TEXT,
        $COLUMN_BATCH_NAME TEXT,
        $COLUMN_SESSION   TEXT,
        $COLUMN_CREDIT  INTEGER
      );
      ''');
    }, version: 1);
  }

  Future<bool> addCourse(
      {required String courseCode,
      required String courseName,
      required String batchName,
      required String session,
      required int credit
      }) async {
    var db = await getDB();

    int rowsEffected = await db.insert(TABLE_COURSE, {
      COLUMN_COUSE_CODE: courseCode,
      COLUMN_COUSE_NAME: courseName,
      COLUMN_BATCH_NAME: batchName,
      COLUMN_SESSION: session,
      COLUMN_CREDIT: credit
    });

    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllCourse() async {
    var db = await getDB();

    List<Map<String, dynamic>> courses = await db.query(TABLE_COURSE);
    return courses;
  }

  Future<bool> updateCourse(
      {required String courseCode,
      required String courseName,
      required String batchName,
      required String session,
      required int credit,
      required int sno}) async {
    var db = await getDB();

    int rowsEffected = await db.update(
        TABLE_COURSE,
        {
          COLUMN_COUSE_CODE: courseCode,
          COLUMN_COUSE_NAME: courseName,
          COLUMN_BATCH_NAME: batchName,
          COLUMN_SESSION: session,
          COLUMN_CREDIT: credit
        },
        where: "$COLUMN_COURSE_SNO = $sno");

    return rowsEffected > 0;
  }

  Future<bool> deleteCourse({required int sno}) async {
    var db = await getDB();

    int rowsEffected = await db.delete(TABLE_COURSE,
        where: "$COLUMN_COURSE_SNO = ?", whereArgs: ["$sno"]);
    return rowsEffected > 0;
  }
}