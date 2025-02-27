import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Get database instance (initialize only once)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'students.db');
    return await openDatabase(
      path,
      version: 2, // Migration version
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Schema updates (if needed)
          if (kDebugMode) {
            print("⚠️ Schema updated.");
          }
        }
      },
      onCreate: (db, version) async {
        // No default table creation; we create tables dynamically
        if (kDebugMode) print("🎉 Database created successfully!");
      },
    );
  }

  // ✅ Create a table dynamically based on tableName, ensuring it has all necessary columns
  Future<void> createTableIfNotExists(String tableName) async {
    final db = await database;

    // Check if table exists by querying the database metadata
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");

    // If table doesn't exist, create it with the necessary columns
    if (result.isEmpty) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          student_id INTEGER PRIMARY KEY,
          name TEXT,
          dept TEXT,
          session TEXT,
          created_at TEXT
        )
      ''');
      if (kDebugMode) print("✅ Table '$tableName' created successfully.");
    } else {
      // If table exists, ensure it has the necessary columns (e.g., 'created_at' column)
      final columnsResult = await db.rawQuery("PRAGMA table_info($tableName)");
      List<String> existingColumns =
          columnsResult.map((col) => col["name"] as String).toList();

      // Add 'created_at' column if it doesn't exist
      if (!existingColumns.contains("created_at")) {
        await db.execute("ALTER TABLE $tableName ADD COLUMN created_at TEXT");
        if (kDebugMode) print("✅ 'created_at' column added to '$tableName'.");
      }
    }
  }

  // ✅ Insert multiple students into a specific table
  Future<void> insertStudents(
      List<Map<String, dynamic>> students, String tableName) async {
    final db = await database;
    await createTableIfNotExists(
        tableName); // Ensure the table exists before inserting

    for (var student in students) {
      await db.insert(
        tableName,
        student,
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Handle conflicts by replacing existing entries
      );
    }
    if (kDebugMode) print("✅ Students inserted into '$tableName'");
  }

  // ✅ Fetch all students from a specific table
  Future<List<Map<String, dynamic>>> fetchLocalStudents(
      String tableName) async {
    final db = await database;
    await createTableIfNotExists(
        tableName); // Ensure the table exists before querying
    final students = await db.query(tableName);
    if (kDebugMode) print("✅ Fetched students from '$tableName'");
    return students;
  }

  // ✅ Delete the database (For debugging only)
  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'students.db');
    await deleteDatabase(path);
    if (kDebugMode) print("⚠️ Database deleted!");
  }

  Future<List<Map<String, dynamic>>> fetchLocalData(String tableName) async {
    final dbHelper = DatabaseHelper();
    final students = await dbHelper.fetchLocalStudents(tableName);
    return students;
  }
  // Add new Column to take attendance for specific class
  Future<void> addNewDateColumn(String tableName, String date) async {
    final db = await database;
    await createTableIfNotExists(
        tableName); // Ensure the table exists before querying

    String columnName = '"$date"'; // Ensure column name is treated as string
    bool columnExists = await _checkIfColumnExists(db, tableName, date);

    if (!columnExists) {
      String query =
          'ALTER TABLE "$tableName" ADD COLUMN $columnName TEXT DEFAULT "❌"';
      await db.execute(query);
      if (kDebugMode) print("✅ New date column '$date' added to '$tableName'");
    } else {
      if (kDebugMode) print("⚠️ Column '$date' already exists in '$tableName'");
    }
  }

  Future<bool> _checkIfColumnExists(
      Database db, String tableName, String columnName) async {
    List<Map<String, dynamic>> columns =
        await db.rawQuery('PRAGMA table_info("$tableName")');
    for (var column in columns) {
      if (column['name'] == columnName) return true;
    }
    return false;
  }

  // Update Attendance status for a specific student on a specific date
  Future<void> updateAttendance(String tableName, String studentId,
      String date, String status) async {
    final db = await database;
    await createTableIfNotExists(tableName); // Ensure the table exists before querying

    // Jodi column na thake, tahole add kore nibe
    String columnName = '"$date"'; // Ensuring correct SQL syntax
    bool columnExists = await _checkIfColumnExists(db, tableName, date);

    if (!columnExists) {
      // Jodi column na thake, tahole add kore nibe
      await db.execute(
          'ALTER TABLE "$tableName" ADD COLUMN $columnName TEXT DEFAULT "❌"');
      if (kDebugMode) print("✅ New date column '$date' added to '$tableName'");
    }

    // Attendance Update Query
    int updatedRows = await db.rawUpdate(
        'UPDATE "$tableName" SET $columnName = ? WHERE student_id = ?',
        [status, studentId]);

    if (updatedRows > 0) {
      if (kDebugMode) {
        print("✅ Attendance updated for Student ID: $studentId on $date");
      }
    } else {
      if (kDebugMode) {
        print(
            "⚠️ No matching student found with ID: $studentId in '$tableName'");
      }
    }
  }
}
