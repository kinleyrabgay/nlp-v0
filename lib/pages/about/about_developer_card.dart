import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key,
      required this.name,
      required this.designation,
      required this.email,
      required this.facebookurl,
      required this.twitterurl,
      required this.linkedinurl,
      required this.githuburl,
      required this.avaterurl});
  final String name;
  final String designation;
  final String email;
  final String facebookurl;
  final String twitterurl;
  final String linkedinurl;
  final String githuburl;
  final String avaterurl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Details
            Column(
              children: [
                Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      designation,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        String facebookUrl = facebookurl;
                        launchUrl(Uri.parse(facebookUrl));
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.facebook,
                        size: 26,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        String twitterUrl = twitterurl;
                        launchUrl(Uri.parse(twitterUrl));
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.twitter,
                        size: 26,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        String linkedinUrl = linkedinurl;
                        launchUrl(Uri.parse(linkedinUrl));
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.linkedin,
                        size: 26,
                        color: Color.fromARGB(255, 6, 79, 139),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        String githubUrl = githuburl;
                        launchUrl(Uri.parse(githubUrl));
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.github,
                        size: 26,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
            // Image
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(avaterurl),
            )
          ],
        ),
      ),
    );
  }
}
