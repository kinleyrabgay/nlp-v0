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
                children: [
                  ProfileCard(
                    name: "Ngawang Samten Pelzang",
                    designation: "Student",
                    email: "nspunk767@gmail.com",
                    facebookurl: "",
                    twitterurl: "",
                    linkedinurl: "",
                    githuburl: "",
                    avaterurl: "assets/img/nsp_trans.png",
                  ),
                  ProfileCard(
                    name: "Ngawang Samten Pelzang",
                    designation: "Student",
                    email: "nspunk767@gmail.com",
                    facebookurl: "",
                    twitterurl: "",
                    linkedinurl: "",
                    githuburl: "",
                    avaterurl: "assets/img/nsp_trans.png",
                  ),
                  ProfileCard(
                    name: "Ngawang Samten Pelzang",
                    designation: "Student",
                    email: "nspunk767@gmail.com",
                    facebookurl: "",
                    twitterurl: "",
                    linkedinurl: "",
                    githuburl: "",
                    avaterurl: "assets/img/nsp_trans.png",
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
