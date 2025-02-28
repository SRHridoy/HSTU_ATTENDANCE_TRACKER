import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/screens/add_excel_screen.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart';

class PopupMenu {
  static Widget showPopup(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: CustomColors.primaryTextColor,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.upload_file, color: Colors.blueAccent),
              SizedBox(width: 12),
              Text(
                "Import Excel",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.green),
              SizedBox(width: 12),
              Text(
                "About Us",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
      offset: Offset(0, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 5,
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExcelFileScreen()),
          );
        } else if (value == 2) {
          _showAboutDialog(context);
        }
      },
    );
  }

  static void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "About Us",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.blueAccent,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            SizedBox(height: 10),
            Text(
              "This project, 'Teacher Assistant,' was developed as a 3rd-year academic project by:",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            _buildContributor("Md. Sohanur Rahman Hridoy", "ID-2102002"),
            _buildContributor("Md. Khaled Amin Shawon", "ID-2102003"),
            _buildContributor("G.M. Nazmul Hassan", "ID-2102055"),
            SizedBox(height: 10),
            Text(
              "Under the supervision of:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            Text(
              "Md. Arshad Ali\nProfessor, Dept. of C.S.E., HSTU, Dinajpur",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildContributor(String name, String id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          Text(
            id,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
