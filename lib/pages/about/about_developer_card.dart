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
    required this.developer5,
    required this.developer6,
    required this.developer7,
    required this.developer8,
    required this.developer9,
    required this.projectname,
    required this.projectlogo,
    required this.projecturl,
  });

  final String developer1;
  final String developer2;
  final String developer3;
  final String developer4;
  final String developer5;
  final String developer6;
  final String developer7;
  final String developer8;
  final String developer9;
  final String projectname;
  final String projectlogo;
  final String projecturl;

  void _launchURL(String projecturl) async {
    if (await canLaunch(projecturl)) {
      await launch(projecturl);
    } else {
      throw 'Could not launch $projecturl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> developers = [
      {
        'name': developer1,
        'iconColor': const Color.fromARGB(255, 255, 119, 119),
      },
      {
        'name': developer2,
        'iconColor': const Color.fromARGB(255, 144, 124, 255),
      },
      {
        'name': developer3,
        'iconColor': const Color.fromARGB(255, 128, 209, 255),
      },
      {
        'name': developer4,
        'iconColor': const Color.fromARGB(255, 117, 255, 163),
      },
      if (developer5.isNotEmpty)
        {
          'name': developer5,
          'iconColor': const Color.fromARGB(255, 255, 161, 118),
        },
      if (developer6.isNotEmpty)
        {
          'name': developer6,
          'iconColor': const Color.fromARGB(255, 192, 64, 234),
        },
      if (developer7.isNotEmpty)
        {
          'name': developer7,
          'iconColor': const Color.fromARGB(255, 112, 186, 255),
        },
      if (developer8.isNotEmpty)
        {
          'name': developer8,
          'iconColor': const Color.fromARGB(255, 255, 199, 109),
        },
      if (developer9.isNotEmpty)
        {
          'name': developer9,
          'iconColor': const Color.fromARGB(255, 128, 222, 234),
        },
    ];

    final englishState = Provider.of<EnglishState>(context);
    final colorText =
        englishState.isEnglishSelected ? Colors.white : Colors.black;
    return InkWell(
      onTap: () => _launchURL(projecturl),
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
                    radius: 40,
                    backgroundImage: AssetImage(projectlogo),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: englishState.isEnglishSelected
                      ? const Color.fromARGB(255, 37, 58, 107)
                      : Colors.orange,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var developer in developers) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: developer['iconColor'],
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            developer['name'],
                            style: TextStyle(fontSize: 16, color: colorText),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
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
