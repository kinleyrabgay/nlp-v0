// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/language_toggle.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final String title;

  const AppbarWidget({Key? key, required this.text, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final englishState = Provider.of<EnglishState>(context);

    return PreferredSize(
      key: _scaffoldKey,
      preferredSize: Size.fromHeight(
        MediaQuery.of(context).size.height * 0.15,
      ),
      child: AppBar(
        // backgroundColor: const Color(0XFF0F1F41),
        backgroundColor: englishState.isEnglishSelected
            ? const Color(0xFF0F1F41)
            : Colors.orange,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              const LanguageToggle(),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 80, 79, 79).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 236, 236, 236),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                            // width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.mail_outline,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () async {
                                String email =
                                    Uri.encodeComponent("nlp.cst@rub.edu.bt");
                                Uri mail = Uri.parse("mailto:$email?");
                                if (await launchUrl(mail)) {
                                  //email app opened
                                } else {
                                  //email app is not opened
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 75);
}
