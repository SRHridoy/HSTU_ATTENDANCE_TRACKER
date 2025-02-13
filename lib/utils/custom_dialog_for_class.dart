import 'package:flutter/material.dart';

void showCustomClassDialog(BuildContext context) {
  String? selectedBatch;
  TextEditingController departmentController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Create New Class"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown for Batch Selection
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select Batch"),
              value: selectedBatch,
              items: ['CSE-20', 'CSE-21', 'CSE-22', 'CSE-23', 'CSE-24']
                  .map((batch) => DropdownMenuItem(
                value: batch,
                child: Text(batch),
              ))
                  .toList(),
              onChanged: (value) {
                selectedBatch = value;
              },
            ),
            SizedBox(height: 10),

            // Department Input Field
            TextField(
              controller: departmentController,
              decoration: InputDecoration(labelText: "Course Name"),
            ),
            SizedBox(height: 10),

            // Course Input Field
            TextField(
              controller: courseController,
              decoration: InputDecoration(labelText: "Course"),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel",style: TextStyle(color: Colors.white),),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                ),
                onPressed: () {
                  // Handle save action
                  String batch = selectedBatch ?? "N/A";
                  String department = departmentController.text.trim();
                  String course = courseController.text.trim();

                  if (department.isNotEmpty && course.isNotEmpty) {
                    // Process data (you can save to database or state)
                    print("Batch: $batch, Department: $department, Course: $course");

                    Navigator.pop(context);
                  }
                },
                child: Text("Save",style: TextStyle(color: Colors.white),),
              ),
            ],
          )
        ],
      );
    },
  );
}
