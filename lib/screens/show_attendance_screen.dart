import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/screens/attendance_screen.dart';
import 'package:hstu_attendance_tracker/services/db_services/students_db_helper.dart';

class AttendanceScreen extends StatefulWidget {
  final String tableName;
  const AttendanceScreen({super.key, required this.tableName});
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> _attendanceData = [];
  List<String> _dates = [];

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    setState(() {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final List<Map<String, dynamic>> data =
        await DatabaseHelper().fetchLocalStudents(widget.tableName);

    if (data.isNotEmpty) {
      setState(() {
        _attendanceData = data;
        _dates = data.first.keys
            .where((key) =>
                key != 'student_id' &&
                key != 'name' &&
                key != 'created_at' &&
                key != 'session' &&
                key != 'dept')
            .toList(); // Extract Date Columns
      });
    }
  }

  void _navigateToStudentListScreen() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentListScreen(tableName: widget.tableName),
        ));

    if (result == true) {
      // If update happened, refresh the page
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Report'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _navigateToStudentListScreen,
          ),
        ],
      ),
      body: _attendanceData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Enables vertical scrolling0
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    ..._dates.map((date) => DataColumn(label: Text(date))),
                  ],
                  rows: _attendanceData.map((student) {
                    return DataRow(cells: [
                      DataCell(Text(student['student_id'].toString())),
                      DataCell(Text(student['name'])),
                      ..._dates.map(
                          (date) => DataCell(Text(student[date].toString()))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
