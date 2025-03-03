import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/screens/student_list_screen.dart';
import 'package:hstu_attendance_tracker/services/db_services/students_db_helper.dart';
import 'package:hstu_attendance_tracker/services/excel_services/sqflite_table_to_excle.dart';

class AttendanceScreen extends StatefulWidget {
  final String tableName;
  final int credit;
  const AttendanceScreen({super.key, required this.tableName, required this.credit});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> _attendanceData = [];
  List<String> _dates = [];
  bool _isLoading = true;
  late int credit ;

  @override
  void initState() {
    super.initState();
    _fetchData();
    credit = widget.credit;
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final List<Map<String, dynamic>> data =
        await DatabaseHelper().fetchLocalStudents(widget.tableName);

    debugPrint("Fetched Data: $data"); // ✅ Debugging

    setState(() {
      _attendanceData = data;
      _isLoading = false;

      if (data.isNotEmpty) {
        _dates = data.first.keys
            .where((key) =>
                key != 'student_id' &&
                key != 'name' &&
                key != 'created_at' &&
                key != 'session' &&
                key != 'dept' &&
                key !=
                    'Obtained_mark') // ✅ Make sure Obtained_mark is not skipped
            .toList();
        _dates.sort((a, b) => a.compareTo(b));
      }
    });
  }

  void _takeAttendance() async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListScreen(tableName: widget.tableName,
        credit: credit),
      ),
    );

    if (result == true) {
      _fetchData();
    }
  }

  String getMark(int attendanceCount) {
    int totalDate = _dates.length;
    double totalMark = attendanceCount / totalDate * 5 * credit;
    return totalMark
        .toStringAsFixed(2); // Convert mark to string with 2 decimal places
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Report', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchData, // Refresh attendance data
          ),
          IconButton(
              icon: Icon(Icons.list, color: Colors.white),
              onPressed: () {
                exportToExcel(widget.tableName);
              } // Export to Excel
              ),
        ],
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
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _attendanceData.isEmpty
                  ? Center(
                      child: Text('No data available',
                          style: TextStyle(fontSize: 18)))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                  Colors.blueAccent.shade100),
                              dataRowColor:
                                  MaterialStateProperty.all(Colors.white),
                              border: TableBorder.all(color: Colors.blueAccent),
                              columns: [
                                DataColumn(
                                    label: Text('ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Optained Mark',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                ..._dates.map((date) => DataColumn(
                                    label: Text(date,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                              ],
                              rows: _attendanceData.map((student) {
                                return DataRow(cells: [
                                  DataCell(
                                      Text(student['student_id'].toString())),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(student['name'],
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  DataCell(Text(
                                    getMark(student['Obtained_mark']),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  ..._dates.map((date) {
                                    final attendance =
                                        student[date]?.toString() ?? 'N/A';
                                    return DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 4),
                                        child: Text(attendance),
                                      ),
                                    );
                                  }).toList(),
                                ]);
                              }).toList(),
                            ),
                            SizedBox(height: 100), // Adds space below the table
                          ],
                        ),
                      ),
                    ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _takeAttendance,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueAccent,
                elevation: 5,
              ),
              child: Text(
                'Take Attendance',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
