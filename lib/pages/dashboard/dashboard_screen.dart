// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:dzongkha_nlp_mobile/pages/about/about_us.dart';
import 'package:dzongkha_nlp_mobile/pages/about/developer.dart';
import 'package:dzongkha_nlp_mobile/pages/components/dashboardcard.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/app_bar.dart';
import '../limitations/limitation.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String state = "dashboard";

  @override
  void initState() {
    super.initState();
  }

  void _showLimitationDialog(String state, BuildContext context) {
    List<Map<String, String>> limitations = [
      {
        "header": "Small Training Dataset",
        "description":
            "The model was trained on a limited dataset, which may impact its understanding of complex patterns and accuracy.",
      },
      {
        "header": "Low-Spec Training",
        "description":
            "Due to processing constraints during training, the model's performance may not match larger, more sophisticated AI models."
      },
      {
        "header": "Potential Inaccuracies",
        "description":
            "The AI model could make mistakes and provide incorrect inferences, making it important to exercise caution in critical decision-making."
      },
      {
        "header": "Limited Generalization",
        "description":
            "he model might not effectively adapt to new, unseen data, leading to suboptimal predictions in novel scenarios.",
      },
      {
        "header": "Continuous Improvements",
        "description":
            "The development team is committed to improving the AI model within mobile constraints and welcomes user feedback for enhancement."
      }
    ];
    LimitationDialog.show(context, limitations, state);
  }

  @override
  Widget build(BuildContext context) {
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
              ? "Please send us your valuable feedbacks"
              : 'ཁྱོད་རའི་ཕན་ཐོགས་ཅན་གྱི་བསམ་ལན་ ང་བཅས་ལུ་གཏང་་གནང་།',
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
                          : "རྫོང་ཁའི་སྐད་སྒྱུར།",
                      subtitle: englishState.isEnglishSelected
                          ? "Translate Dzongkha Text"
                          : "རྫོང་ཁིའི་ཚིག་ཡིག་སྐད་སྒྱུར་འབད།",
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
                          : "རྫོང་ཁའི་རང་བཞིན་བློ་འཛིན།",
                      subtitle: englishState.isEnglishSelected
                          ? "Transcribe Dzongkha Speech into Text"
                          : "རྫོང་ཁའི་ངག་ཚིག་ ཚིག་ཡིག་ནང་ཕབ།",
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
                          : "རྫོང་ཁའི་ཚིག་ཡིག་ ངག་ཚིག་ནང་ཕབ།",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLimitationDialog(state, context);
        },
        backgroundColor: englishState.isEnglishSelected
            ? const Color.fromARGB(255, 37, 58, 107)
            : Colors.orange,
        child: const Icon(Icons.info),
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
                            : 'བཟོ་མི།',
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
