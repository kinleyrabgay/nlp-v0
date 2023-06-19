// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Developer extends StatelessWidget {
  const Developer ({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage('assets/img/pg.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 55),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            englishState.isEnglishSelected
                                ? 'Pema Galley'
                                : 'པེད་མ་ག་ལེག།',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String email = Uri.encodeComponent(
                                      "khentsedorji05@gmail.com");
                                  Uri mail = Uri.parse("mailto:$email?");
                                  if (await launchUrl(mail)) {
                                    //email app opened
                                  } else {
                                    //email app is not opened
                                  }
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://github.com/Khenteb";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.github,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://www.linkedin.com/in/khentse-dorjie-1a1532221/";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage('assets/img/kd.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 55),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            englishState.isEnglishSelected
                                ? 'Khentse Dorji'
                                : 'ཁེན་ཚེ་རྡོ་ཇེ།',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String email = Uri.encodeComponent(
                                      "khentsedorji05@gmail.com");
                                  Uri mail = Uri.parse("mailto:$email?");
                                  if (await launchUrl(mail)) {
                                    //email app opened
                                  } else {
                                    //email app is not opened
                                  }
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://github.com/Khenteb";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.github,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://www.linkedin.com/in/khentse-dorjie-1a1532221/";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage('assets/img/ng.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Ngwang Samten Pelzang",
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String email = Uri.encodeComponent(
                                      "nspunk767@gmail.com");
                                  Uri mail = Uri.parse("mailto:$email?");
                                  if (await launchUrl(mail)) {
                                    //email app opened
                                  } else {
                                    //email app is not opened
                                  }
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://github.com/ngawang88";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.github,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://www.linkedin.com/in/ngawang767/";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage('assets/img/record_card.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 55),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Kinley Rabgay",
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String email = Uri.encodeComponent(
                                      "fsd.rabgay@gmail.com");
                                  Uri mail = Uri.parse("mailto:$email?");
                                  if (await launchUrl(mail)) {
                                    //email app opened
                                  } else {
                                    //email app is not opened
                                  }
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://github.com/snixie";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.github,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  const String url =
                                      "https://www.linkedin.com/in/kinley-rabgay-9352ab26b/";
                                  launchUrl(Uri.parse(url));
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
