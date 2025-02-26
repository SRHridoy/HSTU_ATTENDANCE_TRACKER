import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hstu_attendance_tracker/screens/attendance_screen.dart';
import 'package:hstu_attendance_tracker/services/caching/supabase_to_sqflite.dart';
import 'package:hstu_attendance_tracker/services/db_services/course_db_helper.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart';

import '../utils/popup_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controllers
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseNameController = TextEditingController();

  /// List of courses
  List<Map<String, dynamic>> courses = [];
  CourseDBHelper dbRef = CourseDBHelper.getInstance;

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  /// Fetch all courses from database
  void getCourses() async {
    courses = await dbRef.getAllCourse();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: Text(
          'HSTU Attendance Tracker',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [PopupMenu.showPopup(context)],
      ),
      body: courses.isNotEmpty
          ? ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(
                      courses[index][CourseDBHelper.COLUMN_COURSE_SNO]),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showCourseDialog(course: courses[index]);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          bool check = await dbRef.deleteCourse(
                              sno: courses[index]
                                  [CourseDBHelper.COLUMN_COURSE_SNO]);
                          if (check) {
                            getCourses();
                          }
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Text(
                        '${courses[index][CourseDBHelper.COLUMN_COURSE_SNO]}'),
                    title: Text(
                      '📌 ${courses[index][CourseDBHelper.COLUMN_COUSE_CODE]} 🔸 ${courses[index][CourseDBHelper.COLUMN_COUSE_NAME]}',
                    ),
                    subtitle: Text(
                        '${courses[index][CourseDBHelper.COLUMN_BATCH_NAME]}  |  ${courses[index][CourseDBHelper.COLUMN_SESSION]}'),
                    onLongPress: () {
                      _showOptionsDialog(context, index);
                    },
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StudentListScreen(
                            tableName: courses[index]
                                [CourseDBHelper.COLUMN_COUSE_CODE]);
                      }));
                    },
                  ),
                );
              },
            )
          : Center(child: Text('No Courses Assigned yet!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCourseDialog();
        },
        backgroundColor: CustomColors.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Bottom Sheet for Update/Delete
  void _showOptionsDialog(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Update Course'),
                onTap: () {
                  Navigator.pop(context);
                  showCourseDialog(course: courses[index]);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Course'),
                onTap: () async {
                  Navigator.pop(context);
                  bool check = await dbRef.deleteCourse(
                      sno: courses[index][CourseDBHelper.COLUMN_COURSE_SNO]);
                  if (check) {
                    getCourses();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog to Add or Update Course
  void showCourseDialog({Map<String, dynamic>? course}) {
    String? selectedBatch = course?[CourseDBHelper.COLUMN_BATCH_NAME];
    String? selectedSession = course?[CourseDBHelper.COLUMN_SESSION];

    courseCodeController.text = course?[CourseDBHelper.COLUMN_COUSE_CODE] ?? '';
    courseNameController.text = course?[CourseDBHelper.COLUMN_COUSE_NAME] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(course == null ? "Assign New Course" : "Update Course"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: courseCodeController,
                  decoration: InputDecoration(labelText: "Course Code"),
                ),
                TextField(
                  controller: courseNameController,
                  decoration: InputDecoration(labelText: "Course Name"),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Department"),
                  value: selectedBatch,
                  items: [
                    'CSE',
                    'EEE',
                    'ECE',
                    'Math',
                    'English',
                    'Architecture',
                    'Physics',
                    'Chemistry',
                    'Statistics',
                    'Agriculture',
                    'DVM'
                  ]
                      .map((batch) => DropdownMenuItem(
                            value: batch,
                            child: Text(batch),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBatch = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Session"),
                  value: selectedSession,
                  items: ['2020', '2021', '2022', '2023', '2024']
                      .map((session) => DropdownMenuItem(
                            value: session,
                            child: Text(session),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSession = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (courseCodeController.text.isNotEmpty &&
                        courseNameController.text.isNotEmpty &&
                        selectedBatch != null &&
                        selectedSession != null) {
                      if (course == null) {
                        /// Insert new course
                        bool inserted = await dbRef.addCourse(
                          courseCode: courseCodeController.text,
                          courseName: courseNameController.text,
                          batchName: selectedBatch!,
                          session: selectedSession!,
                        );
                        // create new student table if not exists
                        final caching = Caching();
                        caching.saveStudentsToLocalDatabase(
                          courseCodeController.text,
                          selectedBatch!,
                          selectedSession!,
                        );
                        if (inserted) getCourses();
                      } else {
                        /// Update existing course
                        bool updated = await dbRef.updateCourse(
                          sno: course[CourseDBHelper.COLUMN_COURSE_SNO],
                          courseCode: courseCodeController.text,
                          courseName: courseNameController.text,
                          batchName: selectedBatch!,
                          session: selectedSession!,
                        );
                        if (updated) getCourses();
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(course == null ? "Assign" : "Update",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
