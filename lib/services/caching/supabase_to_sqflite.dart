// ✅ Fixed parameter order (name -> tableName, name -> dept, name -> batch)
import 'package:flutter/foundation.dart';
import 'package:hstu_attendance_tracker/services/db_services/students_db_helper.dart';
import 'package:hstu_attendance_tracker/services/supabase/supabase_services.dart';

class Caching {
  //... other methods
  Future<void> saveStudentsToLocalDatabase(
      String tableName, String dept, String batch) async {
    // ✅ Fetch students from Supabase
    final students =
        await SupabaseService.fetchStudentsbyBatchAndDept(dept, batch);
    print("Fetched ${students.length} students from Supabase.");
    for (var student in students) {
      print(
          student); // ✅ Fixed parameter order (name -> id, name -> name, name -> dept, name -> batch, name -> age, name -> contact, name -> email, name
    }

    // ✅ Check if students list is not null and not empty
    if (students.isNotEmpty) {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertStudents(
          students, tableName); // ✅ Fixed parameter order
      if (kDebugMode) {
        print(
            "✅ Successfully saved ${students.length} students to local database.");
      }
    } else {
      if (kDebugMode) {
        print("⚠ No students found for dept: $dept, batch: $batch.");
      }
    }
  }
}
