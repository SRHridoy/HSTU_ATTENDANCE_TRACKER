import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/services/caching/supabase_to_sqflite.dart';
import 'package:hstu_attendance_tracker/services/db_services/students_db_helper.dart';
import 'package:hstu_attendance_tracker/services/excel_services/excel_reader.dart';
import 'package:hstu_attendance_tracker/services/excel_services/excle_service.dart';
import 'package:hstu_attendance_tracker/services/supabase/supabase_services.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart';

class AddExcelFileScreen extends StatefulWidget {
  const AddExcelFileScreen({super.key});

  @override
  State<AddExcelFileScreen> createState() => _AddExcelFileScreenState();
}

class _AddExcelFileScreenState extends State<AddExcelFileScreen> {
  String statusMessage = "Select a file to upload"; // Initial status message
  List<Map<String, dynamic>> studentList = [];

  Future<void> handleFileUpload() async {
    String? filePath = await FilePickerService.pickExcelFile();

    if (filePath != null) {
      setState(() => statusMessage = "Reading file...");

      List<Map<String, dynamic>> excelData =
          await ExcelReaderService.readExcelData(filePath);

      setState(() => statusMessage = "Uploading data...");
      await SupabaseService.uploadDataToSupabase(excelData);

      setState(() => statusMessage = "Upload complete!");
      await fetchStudentData(); // ✅ Ensure it completes
    } else {
      setState(() => statusMessage = "No file selected.");
    }
  }

  Future<void> fetchStudentData() async {
    setState(() => statusMessage = "Refreshing student data...");

    Caching caching = Caching();
    await caching.saveStudentsToLocalDatabase(
        "CSE210", "CSE", "2021"); // ✅ Added `await`

    final dbHelper = DatabaseHelper();
    studentList = await dbHelper.fetchLocalStudents("CSE210");

    setState(() => statusMessage = "Student data refreshed!");

    for (var student in studentList) {
      if (kDebugMode) {
        print(student['student_id']);
        print(student['name']);
      }
    }
  }

  Future<void> createExcelFile(List<Map<String, dynamic>> studentList) async {
    // Implement the logic to create an Excel file from the studentList
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Excel File",style: TextStyle(
          color: Colors.white,
        ),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: handleFileUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text("Upload Excel File",style: TextStyle(
          color: Colors.white,
        ),),
              ),
              SizedBox(height: 20),
              Text(
                statusMessage,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
