// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/state.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.developer1,
    required this.developer2,
    required this.developer3,
    required this.developer4,
    required this.projectname,
    required this.projectlogo,
    required this.projecturl,
  });

  final String developer1;
  final String developer2;
  final String developer3;
  final String developer4;
  final String projectname;
  final String projectlogo;
  final String projecturl;

  void _launchURL(String url) async {
    // const url = 'https://nlp.cst.edu.bt/'; // Replace with your desired URL

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    return InkWell(
      onTap: () => _launchURL("https://nlp.cst.edu.bt/"),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      projectname,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: englishState.isEnglishSelected
                            ? const Color.fromARGB(255, 37, 58, 107)
                            : const Color.fromARGB(255, 0, 0, 0),
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(projectlogo),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: englishState.isEnglishSelected
                        ? const Color.fromARGB(255, 37, 58, 107)
                        : const Color.fromARGB(255, 243, 181, 56),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 255, 119, 119),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer1,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 144, 124, 255),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer2,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 128, 209, 255),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer3,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 117, 255, 163),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer4,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
