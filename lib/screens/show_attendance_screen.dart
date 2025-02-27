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
    _fetchData();
  }

  Future<void> _fetchData() async {
    final List<Map<String, dynamic>> data =
        await DatabaseHelper().fetchLocalStudents(widget.tableName);

    if (data.isNotEmpty) {
      setState(() {
        _attendanceData = data;
        _dates = data.first.keys
            .where((key) => key != 'id' && key != 'name')
            .toList(); // Extract Date Columns
      });
    }
  }
  void _navigateToStudentListScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StudentListScreen(tableName: widget.tableName,);
    }));
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
            onPressed:_navigateToStudentListScreen,
          ),
        ],
      ),
      body: _attendanceData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  ..._dates.map((date) => DataColumn(label: Text(date))),
                ],
                rows: _attendanceData.map((student) {
                  return DataRow(cells: [
                    DataCell(Text(student['id'].toString())),
                    DataCell(Text(student['name'])),
                    ..._dates
                        .map((date) => DataCell(Text(student[date] ?? ''))),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
