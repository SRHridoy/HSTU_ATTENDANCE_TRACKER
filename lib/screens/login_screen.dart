import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hstu_attendance_tracker/screens/home_screen.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart';

import '../services/auth_service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.secondaryColor,
      body: Column(
        children: [
          Gap(55),
          Image.asset('assets/images/app_login.png'),
          Gap(30),
          Text(
            'Enter your Fingerprint to login',
            style: TextStyle(
              color: CustomColors.primaryColor,
              backgroundColor: Color(0xfff8e1e5),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Gap(40),
          Icon(
            Icons.fingerprint,
            color: CustomColors.primaryColor,
            size: 80,
          ),
          Gap(80),
          SizedBox(
            width: 100, // Set your desired width
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: CustomColors.primaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: () async {
                bool isAuthenticated = await authService.authenticateWithBiometrics();
                if (isAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'Successful',
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Failed!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: Color(0xff252424), fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
