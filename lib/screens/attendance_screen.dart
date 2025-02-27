import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hstu_attendance_tracker/services/db_services/students_db_helper.dart';

class StudentListScreen extends StatefulWidget {
  final String tableName;
  const StudentListScreen({super.key, required this.tableName});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Map<String, dynamic>>> _studentsFuture;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Map<String, String> attendanceStatus = {};

  @override
  void initState() {
    super.initState();
     _studentsFuture = _loadStudents(); // Ensure it's initialized immediately
    _initializeData();
  }

  void _initializeData() {
    DatabaseHelper().addNewDateColumn(widget.tableName, selectedDate).then((_) {
      setState(() {
        _studentsFuture = _loadStudents();
      });
    });
  }

  Future<List<Map<String, dynamic>>> _loadStudents() async {
    final students = await DatabaseHelper().fetchLocalStudents(widget.tableName);
    attendanceStatus = {
      for (var student in students)
        student['student_id'].toString(): student[selectedDate] == "✅" ? "✅" : "❌"
    };
    return students;
  }

  Future<void> _updateAttendance(String studentId) async {
    String newStatus = attendanceStatus[studentId] == "✅" ? "❌" : "✅";
    setState(() {
      attendanceStatus[studentId] = newStatus;
    });

    await DatabaseHelper().updateAttendance(
        widget.tableName, studentId.toString(), selectedDate, newStatus);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        _studentsFuture = _loadStudents(); // Ensure UI updates immediately
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take Attendance $selectedDate", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No students found."));
          }

          final students = snapshot.data!;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: () => _updateAttendance(student['student_id'].toString()),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          student['name'][0],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      title: Text(
                        "${student['student_id'].toString()} - ${student['name']}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Dept: ${student['dept']} | Session: ${student['session']}"),
                      trailing: Text(
                        attendanceStatus[student['student_id'].toString()] ?? "❌",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
