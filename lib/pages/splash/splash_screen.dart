import 'dart:async';

import 'package:dzongkha_nlp_mobile/pages/dashboard/dashboard_screen.dart';
import 'package:dzongkha_nlp_mobile/pages/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });
    ;

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 37, 58, 107),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            SlideTransition(
              position: _animation,
              child: Container(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/logo/app_logo_trans.png")),
            ),
            SpinKitWaveSpinner(
              color: Color.fromARGB(255, 228, 225, 67),
              trackColor: Color.fromARGB(255, 222, 100, 13),
              waveColor: Color.fromARGB(255, 224, 201, 55),
              size: 60,
              duration: Duration(milliseconds: 1000),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
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
