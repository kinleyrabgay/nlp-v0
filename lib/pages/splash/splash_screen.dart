// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:dzongkha_nlp_mobile/pages/onboarding/onboarding_screen.dart';
import 'package:dzongkha_nlp_mobile/pages/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward().then((value) {
      checkFirstTimeUser();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // First time user, navigate to onboarding screen
      prefs.setBool('isFirstTime',
          false); // Set isFirstTime to false in shared preferences
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    } else {
      // Not the first time, navigate to dashboard directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 58, 107),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            SlideTransition(
              position: _animation,
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset("assets/logo/app_logo_trans.png"),
              ),
            ),
            const SpinKitWave(
              color: Color.fromARGB(255, 228, 225, 67),
              size: 60,
              duration: Duration(milliseconds: 1000),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: const Text(
                "powered by CST",
                style: TextStyle(color: Color.fromARGB(255, 224, 201, 55)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
