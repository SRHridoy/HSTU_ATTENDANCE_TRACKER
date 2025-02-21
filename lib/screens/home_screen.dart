import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/utils/custom_dialog_for_class.dart';
import 'package:hstu_attendance_tracker/utils/popup_menu.dart';

import '../utils/custom_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
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
      body: ListView.builder(

        itemBuilder: (context, index) {

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomClassDialog(context);
        },
        backgroundColor: CustomColors.primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
