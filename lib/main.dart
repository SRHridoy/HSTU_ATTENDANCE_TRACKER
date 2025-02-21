import 'package:flutter/material.dart';
import 'package:hstu_attendance_tracker/screens/home_screen.dart';
import 'package:hstu_attendance_tracker/screens/splash_screen.dart';

void main(){
  runApp(HstuAttendanceTracker());
}

class HstuAttendanceTracker extends StatelessWidget {
  const HstuAttendanceTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
