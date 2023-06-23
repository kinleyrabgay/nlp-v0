// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:dzongkha_nlp_mobile/pages/about/about_developer_card.dart';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Developer extends StatelessWidget {
  const Developer({super.key});

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
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileCard(
                    developer1: "Pema Geley",
                    developer2: "Ngawang Samten Pelzang",
                    developer3: "Kinley Rabgay",
                    developer4: "Khentshe Dorji",
                    projectname: "Dzongkha ASR Developer",
                    projectlogo: 'assets/img/splash.png',
                    projecturl: "http://127.0.0.1:8000/asr/",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProfileCard(
                    developer1: "Karma Wangchuk",
                    developer2: "Thinley Norbu",
                    developer3: "Dodrup Wangchuk Sherpa",
                    developer4: "Sonam Yangchen",
                    projectname: "Dzongkha Translation Developer",
                    projectlogo: 'assets/img/nmt_logo.png',
                    projecturl: "http://127.0.0.1:8000/nmt/",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProfileCard(
                    developer1: "Yeshi Jamtsho",
                    developer2: "Kamal Archarya",
                    developer3: "Sangay Tenzin",
                    developer4: "Sonam Rabgay",
                    projectname: "Dzongkha TTS Developer",
                    projectlogo: 'assets/img/tts-logo.png',
                    projecturl: "http://127.0.0.1:8000/tts/",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
