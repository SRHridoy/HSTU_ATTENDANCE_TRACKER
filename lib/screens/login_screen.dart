import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:gap/gap.dart';
import 'package:hstu_attendance_tracker/screens/home_screen.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart';
import '../services/auth_service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final AuthService authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.primaryColor, Colors.deepPurpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(screenHeight * 0.05),

                // App Logo
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset('assets/images/app_logo_white.png'),
                ),
                Gap(screenHeight * 0.03),

                // Title
                Text(
                  'Unlock with Fingerprint',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                    letterSpacing: 0.5,
                  ),
                ),
                Gap(screenHeight * 0.015),

                // Subtitle
                Text(
                  'Place your finger on the sensor to log in quickly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(screenHeight * 0.05),

                // Animated Fingerprint Icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.fingerprint,
                    color: Colors.white,
                    size: screenWidth * 0.22,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),

                Gap(screenHeight * 0.08),

                // Login Button
                SizedBox(
                  width: screenWidth * 0.5,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.3),
                      side: BorderSide(color: CustomColors.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      bool isAuthenticated = await authService.authenticateWithBiometrics();
                      if (isAuthenticated) {
                        HapticFeedback.lightImpact(); // ✅ Haptic feedback
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green.shade600,
                          content: Text(
                            '🎉 Login Successful!',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(seconds: 2),
                        ));
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HomeScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            transitionDuration: Duration(milliseconds: 800),
                          ),
                        );
                      } else {
                        HapticFeedback.vibrate(); // ❌ Haptic feedback on failure
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            '❌ Fingerprint Authentication Failed.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red.shade700,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Color(0xff252424),
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                        letterSpacing: 1.2,
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
