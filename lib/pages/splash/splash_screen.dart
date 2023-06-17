import 'dart:async';
import 'package:dzongkha_nlp_mobile/pages/dashboard/dashboard_screen.dart';
import 'package:dzongkha_nlp_mobile/pages/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0F1F41),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              // Spacer(),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 100),
              //   child: SpinKitWave(
              //     color: Colors.white,
              //     itemCount: 30,
              //     size: 40,
              //     type: SpinKitWaveType.center,
              //   ),
              // ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Powered By DDC',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: ' Montserrat',
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
