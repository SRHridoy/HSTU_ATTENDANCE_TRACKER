import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hstu_attendance_tracker/screens/splash_screen.dart';
import 'package:hstu_attendance_tracker/utils/supabase_const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: uRL,
    anonKey: anomKEY,
  );
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
