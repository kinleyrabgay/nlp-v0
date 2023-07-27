// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable
import 'package:dzongkha_nlp_mobile/pages/about/about_developer_card.dart';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Developer extends StatelessWidget {
  const Developer({super.key});

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? 'Contact and meet app developers instantly'
          : 'འབྲེལ་བ་འཐབ་སྟེ་ རིམ་ལུགས་བཟོ་མི་དང་འཕྱད།';
    }

    String asrDev = englishState.isEnglishSelected
        ? 'Dzongkha ASR Developer'
        : 'རྫོང་ཁའི་རང་བཞིན་བློ་འཛིན་བཟོ་མི།';

    return Scaffold(
      appBar: AppbarWidget(
        title: englishState.isEnglishSelected
            ? "Dzongkha NLP"
            : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
        text: _getAppBarText(englishState),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                englishState.isEnglishSelected
                    ? const ProfileCard(
                        developer1: "Pema Geley",
                        developer2: "Ngawang Samten Pelzang",
                        developer3: "Kinley Rabgay",
                        developer4: "Khentshe Dorji",
                        developer5: "",
                        developer6: "",
                        developer7: "",
                        developer8: "",
                        developer9: "",
                        projectname: "Dzongkha ASR Developer",
                        projectlogo: 'assets/img/splash.png',
                        projecturl: "https://nlp.cst.edu.bt/",
                      )
                    : const ProfileCard(
                        developer1: "པད་མ་དགེ་ལེགས།",
                        developer2: "ངག་དབང་བསམ་གཏན་དཔལ་བཟང།",
                        developer3: "ཀུན་ལེགས་རབ་རྒྱས།",
                        developer4: "མཁྱེན་བརྩེ་རྡོ་རྗེ།",
                        developer5: "",
                        developer6: "",
                        developer7: "",
                        developer8: "",
                        developer9: "",
                        projectname: "རྫོང་ཁའི་རང་བཞིན་བློ་འཛིན་བཟོ་མི།",
                        projectlogo: 'assets/img/splash.png',
                        projecturl: "https://nlp.cst.edu.bt/",
                      ),
                const SizedBox(height: 10),
                englishState.isEnglishSelected
                    ? const ProfileCard(
                        developer1: "Karma Wangchuk",
                        developer2: "Dodrup Wangchuk Sherpa",
                        developer3: "Thinley Norbu",
                        developer4: "Sonam Yangchen",
                        developer5: "",
                        developer6: "",
                        developer7: "",
                        developer8: "",
                        developer9: "",
                        projectname: "Dzongkha NMT Developer",
                        projectlogo: 'assets/img/nmt_logo.png',
                        projecturl: "https://nlp.cst.edu.bt/",
                      )
                    : const ProfileCard(
                        developer1: "ཀརྨ་དབང་ཕྱུག།",
                        developer2: "རྡོ་གྲུབ་དབང་ཕྱུག་ཤེར་པཱ།",
                        developer3: "འཕྲིན་ལས་ནོར་བུ།",
                        developer4: "བསོད་ནམས་དབྱངས་ཅན།",
                        developer5: "",
                        developer6: "",
                        developer7: "",
                        developer8: "",
                        developer9: "",
                        projectname: "རྫོང་ཁའི་སྐད་སྒྱུར་བཟོ་མི།",
                        projectlogo: 'assets/img/nmt_logo.png',
                        projecturl: "https://nlp.cst.edu.bt/",
                      ),
                const SizedBox(height: 10),
                englishState.isEnglishSelected
                    ? const ProfileCard(
                        developer1: "Yeshi Jamtsho",
                        developer2: "Kamal Archarya",
                        developer3: "Sangay Tenzin",
                        developer4: "Sonam Rabgay",
                        developer5: "",
                        developer6: "",
                        developer7: "",
                        developer8: "",
                        developer9: "",
                        projectname: "Dzongkha TTS Developer",
                        projectlogo: 'assets/img/tts-logo.png',
                        projecturl: "https://nlp.cst.edu.bt/",
                      )
                    : const ProfileCard(
                        developer1: "ཡེ་ཤེས་རྒྱ་མཚོ།",
                        developer2: "ཀཱ་མཱལ་ཨར་ཅ་ཡཱ།",
                        developer3: "བསོད་ནམས་རབ་རྒྱས།",
                        developer4: "སངས་རྒྱས་བསྟན་འཛིན།",
                        developer5: "",
                        developer6: "",
                        developer7: "",
                        developer8: "",
                        developer9: "",
                        projectname: "རྫོང་ཁའི་ཚིག་ཡིག་ལས་ངག་ཚིག་བཟོ་མི།",
                        projectlogo: 'assets/img/tts-logo.png',
                        projecturl: "https://nlp.cst.edu.bt/",
                      ),
                const SizedBox(height: 10),
                englishState.isEnglishSelected
                    ? const ProfileCard(
                        developer1: "Namgay Thinley",
                        developer2: "Ugyen Tenzin",
                        developer3: "Tenzin Namgyel",
                        developer4: "Rinzin Pelden",
                        developer5: "Tsheten Dorji",
                        developer6: "Pema Gyalpo",
                        developer7: "Pema Wangdi",
                        developer8: "Tshewang Norbu",
                        developer9: "Singye Dorji",
                        projectname: "DCDD Team",
                        projectlogo: 'assets/img/dd.png',
                        projecturl: "https://www.dzongkha.gov.bt/",
                      )
                    : const ProfileCard(
                        developer1: "རྣམ་རྒྱལ་ཕྲིན་ལས།",
                        developer2: "ཨོ་རྒྱན་བསྟན་འཛིན།",
                        developer3: "བསྟན་འཛིན་རྣམ་རྒྱལ།",
                        developer4: "རིག་འཛིན་དཔལ་སྒྲོན།",
                        developer5: "ཚེ་བརྟན་རྡོ་རྗེ།",
                        developer6: "པད་མ་རྒྱལ་པོ།",
                        developer7: "པད་མ་དབང་འདུས།",
                        developer8: "ཚེ་དབང་ནོར་བུ།",
                        developer9: "སེང་གེ་རྡོ་རྗེ།",
                        projectname: "ལམ་སྲོལ་དང་རྫོང་ཁ་གོང་འཕེལ་ལས་ཁུངས།",
                        projectlogo: 'assets/img/dd.png',
                        projecturl: "https://www.dzongkha.gov.bt/",
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
