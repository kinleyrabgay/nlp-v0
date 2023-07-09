// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:dzongkha_nlp_mobile/pages/about/about_us.dart';
import 'package:dzongkha_nlp_mobile/pages/about/developer.dart';
import 'package:dzongkha_nlp_mobile/pages/components/dashboardcard.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/app_bar.dart';
import '../model/asr/asr_model.dart';
import '../model/nmt/nmt_model.dart';
import '../model/tts/tts_page.dart';

class DashboardScreen extends StatefulWidget implements PreferredSizeWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 75);
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final englishState = Provider.of<EnglishState>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: widget.preferredSize,
        child: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha NLP"
              : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
          text: englishState.isEnglishSelected
              ? "Send us your valuable feedback"
              : 'ཁྱོད་ཀྱིས་རིན་གོང་ཆེ་བའི་བརྡ་སྟོན་ཚུ་ ང་བཅས་ལུ་གཏང་གནང་།',
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    DashboardCard(
                      heading: englishState.isEnglishSelected
                          ? "Dzongkha NMT"
                          : "རྫོང་ཁའི་སྐད་སྒྱུར།།",
                      subtitle: englishState.isEnglishSelected
                          ? "Translate Dzongkha Text"
                          : "རྗོང་ཁ་ཡི་གུ་སྐད་སྒྱུར་འབད།",
                      imagepath: "assets/img/nmt_logo.png",
                      cardcolor: Colors.white,
                      onCardClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Nmt_model(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    DashboardCard(
                      heading: englishState.isEnglishSelected
                          ? "Dzongkha ASR"
                          : "རྫོང་ཁ་སྒྲ་ལས་ཡི་གུ།།",
                      subtitle: englishState.isEnglishSelected
                          ? "Transcribe Dzongkha Speech into Text"
                          : "ཕྲེང་ཁ་གི་གསུང་བཤད་འདི་ཡི་གུ་ནང་བྲི་བཅུག།",
                      imagepath: "assets/img/splash_1.png",
                      cardcolor: Colors.white,
                      onCardClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TryModel(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    DashboardCard(
                      heading: englishState.isEnglishSelected
                          ? "Dzongkha TTS"
                          : "རྫོང་ཁ་ཡི་གུ་ལས་སྒྲ།",
                      subtitle: englishState.isEnglishSelected
                          ? "Transcribe Dzongkha Text into Speech"
                          : "ཕྲིན་ལས་ཀྱི་ཡིག་ཆ་འདི་ཁ་སློང་ནང་ལུ་བྲི་བཅུག།",
                      imagepath: "assets/img/tts-logo.png",
                      cardcolor: Colors.white,
                      onCardClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TTSModel(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: englishState.isEnglishSelected
              ? const Color.fromARGB(255, 37, 58, 107)
              : Colors.orange,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom:
                              BorderSide(width: 0, color: Colors.transparent),
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/img/flag.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.edit_document, color: Colors.white),
                      title: Text(
                        englishState.isEnglishSelected ? 'About' : 'སྐོར་ལས།',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const AboutPage(),
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.black12,
                      indent: 20,
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_2_rounded,
                          color: Colors.white),
                      title: Text(
                        englishState.isEnglishSelected
                            ? 'Developer'
                            : 'གོང་འཕེལ་གྱི་ལས་འགན།',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Developer(),
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
