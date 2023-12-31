import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "dart:async";

import "../limitations/limitation.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  late Timer _timer;
  String state = "onboarding";

  // Inside your SplashScreen or any other screen where you want to show the dialog
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
            "The model might not effectively adapt to new, unseen data, leading to suboptimal predictions in novel scenarios.",
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
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageIndex < data.length - 1) {
        _pageIndex++;
      } else {
        _pageIndex = 0;
      }
      _pageController.animateToPage(
        _pageIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardingContent(
                    image: data[index].image,
                    title: data[index].title,
                    description: data[index].description,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        data.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: DotIndicator(isActive: index == _pageIndex),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  ElevatedButton(
                    onPressed: () {
                      _showLimitationDialog(state, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 15, 31, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            "Get Started",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/svg/arrow-right-alt.svg",
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, this.isActive = false});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 18 : 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 15, 31, 65)
            : const Color.fromARGB(255, 15, 31, 65).withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> data = [
  Onboard(
      image: "assets/img/onboarding_1.png",
      title: "Dzongkha Speech Recognition",
      description:
          "Empower Your Voice: Experience Seamless Speech Recognition Automation."),
  Onboard(
      image: "assets/img/onboarding_2.png",
      title: "Dzongkha Text to Speech",
      description:
          "Give Voice to Your Words: Unleash the Power of Text-to-Speech Automation."),
  Onboard(
      image: "assets/img/onboarding_3.png",
      title: "Dzongkha Neural Translation",
      description:
          "Transcend Boundaries: Unleash the Power of Neural Machine Translation Technology.")
];

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: MediaQuery.of(context).size.height * 0.45,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer()
      ],
    );
  }
}
