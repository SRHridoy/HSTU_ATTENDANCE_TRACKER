import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hstu_attendance_tracker/screens/home_screen.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart'; // Assuming you have custom colors

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container( // Changed Scaffold's body to Container for gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient( // Added a subtle gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColors.secondaryColor,
              CustomColors.secondaryColor.withOpacity(0.8), // Slightly darker shade
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Increased padding for better spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(screenHeight * 0.05),
                AspectRatio(
                  aspectRatio: 1.6, // Slightly adjusted aspect ratio
                  child: Image.asset(
                    'assets/images/app_login.png',
                    // Added subtle shadow to the image (optional, can be removed if not desired)
                    // colorBlendMode: BlendMode.multiply,
                    // color: Colors.black.withOpacity(0.05),
                  ),
                ),
                Gap(screenHeight * 0.03),
                Text(
                  'Unlock with Fingerprint', // More concise and user-friendly text
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.w700, // Made text bolder
                    fontSize: screenWidth * 0.06, // Slightly larger font size
                    letterSpacing: 0.5, // Added letter spacing for better readability
                  ),
                ),
                Gap(screenHeight * 0.02), // Reduced gap slightly
                Text(
                  'Place your finger on the sensor to log in quickly.', // Added hint text
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.primaryColor.withOpacity(0.7), // Slightly faded hint text
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(screenHeight * 0.04),
                Icon(
                  Icons.fingerprint,
                  color: CustomColors.primaryColor,
                  size: screenWidth * 0.22, // Slightly larger icon
                  shadows: [ // Added subtle icon shadow
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.08),
                SizedBox(
                  width: screenWidth * 0.45, // Slightly wider button
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5, // Added button elevation for a raised effect
                      shadowColor: Colors.black.withOpacity(0.3), // Button shadow color
                      side: BorderSide(color: CustomColors.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14), // Increased button padding
                    ),
                    onPressed: () async {
                      bool isAuthenticated = await authService.authenticateWithBiometrics();
                      if (isAuthenticated) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green.shade600, // Slightly darker green
                          content: Text(
                            'Login Successful!', // More informative success message
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Bolder success text
                          ),
                          duration: Duration(seconds: 2), // SnackBar duration
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Fingerprint Authentication Failed.', // More informative failure message
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red.shade700, // Slightly darker red
                          duration: Duration(seconds: 2), // SnackBar duration
                        ));
                      }
                    },
                    child: Text(
                      'LOGIN', // Uppercased button text for emphasis
                      style: TextStyle(
                        color: Color(0xff252424),
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045, // Slightly larger button text
                        letterSpacing: 1.2, // Added letter spacing to button text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}