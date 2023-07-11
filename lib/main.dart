// ignore_for_file: unused_local_variable
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EnglishState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DASR",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 15, 31, 65),
        fontFamily: "Joyig",
      ),
      home: const SplashScreen(),
    );
  }
}
