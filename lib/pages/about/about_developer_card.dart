import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    Size size = MediaQuery.of(context).size;
    final englishState = Provider.of<EnglishState>(context);
    return InkWell(
      onTap: () => _launchURL("https://nlp.cst.edu.bt/"),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
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
                            ? Color.fromARGB(255, 37, 58, 107)
                            : Color.fromARGB(255, 0, 0, 0),
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
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: englishState.isEnglishSelected
                        ? Color.fromARGB(255, 37, 58, 107)
                        : Color.fromARGB(255, 243, 181, 56),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 255, 119, 119),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 144, 124, 255),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer2,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 128, 209, 255),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer3,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 117, 255, 163),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          developer4,
                          style: TextStyle(
                            fontSize: 20,
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
