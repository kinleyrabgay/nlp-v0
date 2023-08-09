// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, deprecated_member_use, avoid_unnecessary_containers, unused_element

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

    String copyText = englishState.isEnglishSelected
        ? '© 2023 CST. All rights reserved.'
        : "© སྤྱི་ལོ་༢༠༢༣ CST. དབང་ཆ་ཧྲིལ་བུམ་ཡོད།";

    String devText = englishState.isEnglishSelected
        ? 'Our app is a collaboration between'
        : "རིམ་ལུགས་འདི་ སྲོལ་འཛིན་དང་རྫོང་ཁ་གོང་འཕེལ་ལས་ཁུངས་དང་མཉམ་འབྲེལ་ཐོག་ལས་བཟོ་བཟོཝ་ཨིན།";

    String welcomeText =
        englishState.isEnglishSelected ? 'Welcome to' : "བྱོན་པ་ལེགས་སོ།";

    String nlpText =
        englishState.isEnglishSelected ? 'NLP' : "སྐད་སྦྱོར་རིག་པ།";

    return Scaffold(
      appBar: AppbarWidget(
        title: englishState.isEnglishSelected
            ? "Dzongkha NLP"
            : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
        text: _getAppBarText(englishState),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  welcomeText,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nlpText,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: englishState.isEnglishSelected
                        ? Colors.orange
                        : const Color.fromARGB(255, 0, 71, 165),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily:
                          englishState.isEnglishSelected ? '' : 'Joyig'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    devText,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
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
                          image: AssetImage('assets/img/dd.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/cstlogo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Contact CST: https://nlp.cst.edu.bt/',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  copyText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
