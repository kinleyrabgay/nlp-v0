// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, deprecated_member_use, avoid_unnecessary_containers

import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? 'Contact and meet app developers instantly'
          : 'འབྲེལ་བ་འཐབ་སྟེ་ རིམ་ལུགས་བཟོ་མི་དང་འཕྱད།';
    }

    return Scaffold(
      appBar: AppbarWidget(
        title: englishState.isEnglishSelected
            ? "Dzongkha NLP"
            : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
        text: _getAppBarText(englishState),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NLP',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: englishState.isEnglishSelected
                      ? Colors.orange
                      : const Color.fromARGB(
                          255, 0, 71, 165), // Replace with your desired color
                  fontFamily:
                      'Montserrat', // Replace with your desired font family
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Our app is a collaboration between',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/img/dd.png'), // Replace with your DDC logo asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/img/cstlogo.png'), // Replace with your CST logo asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  _launchURL(
                      'https://www.facebook.com'); // Replace the URL with your app's Facebook sharing link
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                label: const Text(
                  'Share App',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 37, 58,
                      107), // Replace with your desired button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _launchURL(
                      'https://www.example.com'); // Replace the URL with your app's rating link
                },
                icon: const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                label: const Text(
                  'Rate Us',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  // backgroundColor:
                  //     Colors.transparent, // Remove the background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact CST: https://nlp.cst.edu.bt/',
                style: TextStyle(
                  fontSize: 14,
                  // color: englishState.isEnglishSelected
                  //     ? const Color.fromARGB(255, 255, 255, 255)
                  //     : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2023 CST. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  // color: englishState.isEnglishSelected
                  //     ? const Color.fromARGB(255, 255, 255, 255)
                  //     : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
