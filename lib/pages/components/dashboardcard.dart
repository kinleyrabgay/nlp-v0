import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/state.dart';

class DashboardCard extends StatefulWidget {
  const DashboardCard(
      {super.key,
      required this.heading,
      required this.subtitle,
      required this.imagepath,
      required this.cardcolor,
      required this.onCardClick});
  final String heading;
  final String subtitle;
  final String imagepath;
  final Color cardcolor;
  final Function onCardClick;
  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    TextStyle headStyle = englishState.isEnglishSelected
        ? const TextStyle(
            color: Color.fromARGB(222, 20, 20, 20),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          )
        : const TextStyle(
            color: Color.fromARGB(222, 20, 20, 20),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          );
    TextStyle bodyStyle = englishState.isEnglishSelected
        ? const TextStyle(
            color: Color.fromARGB(222, 20, 20, 20),
            fontSize: 14,
          )
        : const TextStyle(
            color: Color.fromARGB(222, 20, 20, 20),
            fontSize: 16,
          );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: widget.cardcolor,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset(widget.imagepath),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.heading, style: headStyle),
                        const SizedBox(height: 10),
                        Text(
                          widget.subtitle,
                          style: bodyStyle,
                        ),
                        const SizedBox(height: 25),
                        englishState.isEnglishSelected
                            ? TextButton(
                                onPressed: () {
                                  widget.onCardClick();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F1F41),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Get Started',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 255, 136, 0),
                                      ),
                                      padding: const EdgeInsets.all(1),
                                      child: const Icon(Icons.chevron_right,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    )
                                  ],
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  widget.onCardClick();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 136, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'གོ་བཙུགས།',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF0F1F41),
                                      ),
                                      padding: const EdgeInsets.all(1),
                                      child: const Icon(Icons.chevron_right,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    )
                                  ],
                                ),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
