import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hstu_attendance_tracker/screens/home_screen.dart';
import 'package:hstu_attendance_tracker/utils/custom_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_logo_white2.png'),
            Gap(10),
            Text(
              'Less Paperwork, More Teaching!',
              style: TextStyle(
                color: CustomColors.primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal
              ),
            ),
            Gap(200),
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: CustomColors.secondaryColor, size: 40),
            )
          ],
        ),
      ),
    );
  }

  void navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    });
  }
}
