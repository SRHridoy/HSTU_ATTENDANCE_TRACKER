import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/utils/custom_dialog_for_class.dart';

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
        backgroundColor: Colors.deepOrange,
        title: Text(
          'HSTU ATTENDANCE TRACKER',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomClassDialog(context);
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
