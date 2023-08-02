// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print, depend_on_referenced_packages, library_private_types_in_public_api
import 'dart:async';
import 'package:dzongkha_nlp_mobile/api/data.dart';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/pages/model/tts/audio_player.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TtsModel extends StatefulWidget {
  const TtsModel({super.key});

  @override
  _TtsModelState createState() => _TtsModelState();
}

class _TtsModelState extends State<TtsModel> {
  bool isLoading = false;
  var _predicted_text_controller = TextEditingController();
  var text_controller = TextEditingController();

  String text = '';
  bool isPlaying = false;
  bool audioReceived = false;
  bool audioReceivedToLocal = false;
  String audiofilepath = "";

  bool isGeneratingOutput = false;

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    String hint = englishState.isEnglishSelected
        ? 'Enter dzongkha text'
        : "རྫོང་ཁིའི་ཚིག་ཡིག་བཙུགས།";

    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? "Discover and enjoy our model's capabilities"
          : "ང་བཅས་ཀྱི་དཔེ་གཞིའི་ནུས་ཤུགས་ཚུ་འཚོལ་ཏེ་སྤྲོ་བ་བཏོན།";
    }

    Future<void> fetchAudioAndSave(String text) async {
      bool fasle_storage = false;
      setState(() {
        isLoading = true;
        isGeneratingOutput = true;
      });

      setState(() {
        audioReceivedToLocal = fasle_storage;
      });

      try {
        print('Fetch audio data called');
        print(text);
        Map audioGenerated = await DataServices.generateAudio(text);
        bool audioIsReceivedStatus = audioGenerated['success'];

        if (audioIsReceivedStatus) {
          audiofilepath = audioGenerated['filepath'];
        }

        print('Audio is Received Status ===================================');
        print(audioIsReceivedStatus);

        if (audioIsReceivedStatus) {
          setState(() {
            audioReceivedToLocal = true;
            print('Setting state =============================');
            print(audioReceivedToLocal);
            isGeneratingOutput = false;
          });
          print('Audio synthesized and saved');
          print('Now enable the play button and play it.');
        } else {
          print(
              'Failed to get audio from server and save on temporary directory');
          setState(() {
            audioReceivedToLocal = false;
            print('Setting state =============================');
            print(audioReceivedToLocal);
            isGeneratingOutput = false;
          });
        }
      } catch (e) {
        print('Error fetching or saving audio: $e');
        setState(() {
          audioReceivedToLocal = false;
          isGeneratingOutput = false;
        });
      }

      setState(() {
        isLoading = false;
        isGeneratingOutput = false;
      });
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha TTS"
              : 'རྫོང་ཁའི་ཚིག་ཡིག་ལས་ངག་ཚིག།',
          text: _getAppBarText(englishState)),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: text_controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 37, 58, 107),
                          width: 1,
                        ),
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 14),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return englishState.isEnglishSelected
                            ? 'This field cannot be empty!'
                            : 'འདི་ས་གོ་སྟོངམ་མ་བཞག།';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          englishState.isEnglishSelected
                                              ? 'Please enter text.'
                                              : 'ཚིག་ཡིག་བཙུགས་གནང་།'),
                                    ),
                                  );
                                } else {
                                  fetchAudioAndSave(text);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            textStyle: const TextStyle(fontSize: 14.0),
                            backgroundColor: englishState.isEnglishSelected
                                ? const Color.fromARGB(255, 37, 58, 107)
                                : Colors.orange,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.35, 50)),
                        child: Text(
                          isGeneratingOutput
                              ? (englishState.isEnglishSelected
                                  ? 'Generating...'
                                  : 'ཐོས་སྒྲ་བཟོ།')
                              : (englishState.isEnglishSelected
                                  ? 'Generate'
                                  : 'ཐོས་སྒྲ་བཟོ།'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "DDC_Uchen",
                          ),
                        ),
                      ),
                      if (isLoading)
                        const SpinKitFadingCircle(
                            color: Color.fromARGB(255, 37, 58, 107), size: 40),
                      ElevatedButton(
                        onPressed: text_controller.clear,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            textStyle: const TextStyle(fontSize: 14.0),
                            backgroundColor:
                                const Color.fromARGB(255, 235, 44, 76),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.35, 50)),
                        child: Text(
                          englishState.isEnglishSelected ? 'Clear' : 'བསལ།',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "DDC_Uchen",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      if (audioReceivedToLocal == true)
                        AudioPlayer(
                          source: audiofilepath,
                        )
                      else
                        const Text(''),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
