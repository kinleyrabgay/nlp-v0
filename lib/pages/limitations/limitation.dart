import 'package:dzongkha_nlp_mobile/pages/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/state.dart';

class LimitationDialog extends StatelessWidget {
  final List<Map<String, String>> limitations;
  final String state;

  const LimitationDialog(
      {Key? key, required this.limitations, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Text(
          'Model Limitations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var limitation in limitations)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      limitation['header'] ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      limitation['description'] ?? '',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: englishState.isEnglishSelected
                    ? const Color.fromARGB(255, 37, 58, 107)
                    : Colors.orange,
              ),
              onPressed: () {
                state == "onboarding"
                    ? Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const DashboardScreen(),
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(
                              CurveTween(curve: curve),
                            );
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      )
                    : Navigator.of(context).pop();
              },
              child: const Text("Okay"),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, List<Map<String, String>> limitations,
      String state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LimitationDialog(
          limitations: limitations,
          state: state,
        );
      },
    );
  }
}
