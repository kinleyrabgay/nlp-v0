// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          : 'འབྲེལ་མཐུད་དང་གློག་རིག་བཟོ་སྐྲུན་པ་ཚུ་འཕྲལ་ར་འཕྱད།';
    }

    return Scaffold(
      appBar: AppbarWidget(
        text: _getAppBarText(englishState),
      ),
      body: Container(
        color: englishState.isEnglishSelected
            ? Color.fromARGB(255, 37, 58, 107)
            : Color.fromARGB(255, 243, 181, 56),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'NLP',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(
                      255, 255, 255, 255), // Replace with your desired color
                  fontFamily:
                      'Montserrat', // Replace with your desired font family
                ),
              ),
              SizedBox(height: 8),
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Our App is a collaboration with',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/img/dd.png'), // Replace with your DDC logo asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/img/cstlogo.png'), // Replace with your CST logo asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  _launchURL(
                      'https://www.facebook.com'); // Replace the URL with your app's Facebook sharing link
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                label: Text(
                  'Share App',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 37, 58,
                      107), // Replace with your desired button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _launchURL(
                      'https://www.example.com'); // Replace the URL with your app's rating link
                },
                icon: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                label: Text(
                  'Rate Us',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, // Remove the background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Contact DDC: example@ddc.com',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '© 2023 DDC. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
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
