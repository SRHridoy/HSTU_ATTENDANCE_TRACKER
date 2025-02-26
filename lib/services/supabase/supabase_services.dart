import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Uploads student data to Supabase, removing invalid records.
  static Future<void> uploadDataToSupabase(
      List<Map<String, dynamic>> data) async {
    try {
      // Remove records with null values
      List<Map<String, dynamic>> validData = data
          .where((row) =>
              row["student_id"] != null &&
              row["name"] != null &&
              row["dept"] != null &&
              row["session"] != null)
          .toList();

      if (validData.isEmpty) {
        if (kDebugMode) print("No valid data to upload.");
        return;
      }

      // Insert or update existing records
      await _client.from('students').upsert(
            validData,
            onConflict:
                'student_id', // Prevents duplicate entries based on 'id'
          );

      if (kDebugMode) print("Data uploaded successfully!");
    } catch (e) {
      if (kDebugMode) print("Error uploading data: $e");
    }
  }

  /// Fetches student records from Supabase, filtering out null values.
  static Future<List<Map<String, dynamic>>> fetchStudents() async {
    try {
      final response = await _client
          .from('students')
          .select('*')
          .not('student_id', 'is', null)
          .not('name', 'is', null)
          .not('dept', 'is', null)
          .not('session', 'is', null); // Filtering nulls in the query itself

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print("Error fetching students: $e");
      return [];
    }
  }

  // fetch students records from Supabase by batch and department
  static Future<List<Map<String, dynamic>>> fetchStudentsbyBatchAndDept(
      String dept, String session) async {
    try {
      final response = await _client
          .from('students')
          .select('*')
          .eq('dept', dept)
          .eq('session', session)
          .not('student_id', 'is', null)
          .not('name', 'is', null)
          .not('dept', 'is', null)
          .not('session', 'is', null); // Batch size can be adjusted based on your requirement

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print("Error fetching students by batch and dept: $e");
      return [];
    }
  }
}
