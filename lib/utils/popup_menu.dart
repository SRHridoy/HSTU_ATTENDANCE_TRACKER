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
              Icon(
                Icons.upload_file,
                color: CustomColors.primaryTextColor,
              ),
              SizedBox(width: 10),
              Text(
                "Import excel",
                style: TextStyle(
                    color: CustomColors.primaryTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: CustomColors.primaryTextColor,
              ),
              SizedBox(width: 10),
              Text(
                "About us",
                style: TextStyle(
                    color: CustomColors.primaryTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
      offset: Offset(0, 60),
      color: Color(0xffe17d5a),
      elevation: 2,
      // Handling item selection
      onSelected: (value) {
        if (value == 1) {
          /// Corrected by Dev-Hridoy...
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddExcelFileScreen()));// Call a method for Import CSV
        } else if (value == 2) {
          _showAboutDialog(context); // Call a method for About
        }
      },
    );
  }

  static void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.bold)),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(text: "Acknowledgement goes to "),
              TextSpan(
                text: "Md. Sohanur Rahman Hridoy",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ", Student ID-2102002, "),
              TextSpan(
                text: "Md. Khaled Amin Shawon",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ", Student ID-2102003, "),
              TextSpan(
                text: "G.M. Nazmul Hassan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ", Student ID-2102055, "),
              TextSpan(
                  text:
                      ", B.Sc. (Engineering) in C.S.E. Session-21, have developed this "),
              TextSpan(
                text: "Teacher Assistant",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      " as their 3rd year academic project under the supervision of "),
              TextSpan(
                text: "Md. Arshad Ali",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ", Professor, Dept. of C.S.E., HSTU, Dinajpur."),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close",
                  style: TextStyle(
                    color: Colors.black,
                  ))),
        ],
      ),
    );
  }
}
