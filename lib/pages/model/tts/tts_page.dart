// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:math';

import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/pages/model/tts/audio_player.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../api/data.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Map> fetchAudioData(String text) async {
  // TODO: Change the url to deployed when webapp is deployed
  final url = Uri.parse('https://nlp.cst.edu.bt/tts/');
  final headers = {'Content-Type': 'application/json'};
  final body = {'inputText': text};

  final response =
      await http.post(url, headers: headers, body: jsonEncode(body));

  print('Respoinse from server: ================================');
  print(response);
  print(response.bodyBytes);
  print("${response.body}");

  // return response;
  if (response.statusCode == 200) {
    // Save the audio to the phone.
    var tempDir = await getTemporaryDirectory();
    var filePath = '${tempDir.path}/audio.wav';
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return {'success': true, "filepath": filePath};
  } else {
    return {'success': false};
  }
}

class TTSModel extends StatefulWidget {
  const TTSModel({super.key});

  @override
  _TTSModelState createState() => _TTSModelState();
}

class _TTSModelState extends State<TTSModel> {
  bool isLoading = false;
  var _predicted_text_controller = TextEditingController();
  var text_controller = TextEditingController();

  String text = '';
  bool isPlaying = false;
  bool audioReceived = false;
  bool audioReceivedToLocal = false;
  String audiofilepath = "";

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);

    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? "Discover and enjoy our model's capabilities"
          : 'སྤྱི་བསྟོད་ཀྱི་གཟུགས་ཆོག་འབྲུ་གཡུགས་དང་།';
    }

    Future<void> fetchAudioAndSave(String text) async {
      bool fasle_storage = false;
      setState(() {
        isLoading = true;
      });

      setState(() {
        audioReceivedToLocal = fasle_storage;
      });

      print('Fetch audio data called');
      print(text);
      Map audioGenerated = await fetchAudioData(text);
      bool audioIsReceivedStatus = audioGenerated['success'];
      if (audioIsReceivedStatus) {
        audiofilepath = audioGenerated['filepath'];
      }

      print('Audio is Received Status ===================================');
      print(audioIsReceivedStatus);
      // ignore: unrelated_type_equality_checks
      if (audioIsReceivedStatus == true) {
        setState(() {
          audioReceivedToLocal = true;

          print('Setting state =============================');
          print(audioReceivedToLocal);
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
        });
      }
      setState(() {
        isLoading = false;
      });
    }

    Future<void> playAudioFromTempDir() async {
      var tempDir = await getTemporaryDirectory();
      var filePath = '${tempDir.path}/audio.wav';
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha TTS"
              : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
          text: _getAppBarText(englishState)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 300.0,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: text_controller,
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      },
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Enter dzongkha text',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please enter text.'),
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
                              ? Color.fromARGB(255, 37, 58, 107)
                              : Color.fromARGB(255, 243, 181, 56),
                          minimumSize: const Size(150.0, 48.0),
                        ),
                        child: isLoading
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: const Color(0XFF0F1F41),
                                  size: 40.0,
                                ),
                              )
                            : Text(englishState.isEnglishSelected
                                ? 'Generate Audio'
                                : 'སྒྲ་བཟོ་ནི།'),
                      ),
                      ElevatedButton(
                        onPressed: text_controller.clear,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          textStyle: const TextStyle(fontSize: 14.0),
                          backgroundColor: englishState.isEnglishSelected
                              ? Color.fromARGB(255, 37, 58, 107)
                              : Color.fromARGB(255, 243, 181, 56),
                          minimumSize: const Size(150.0, 48.0),
                        ),
                        child: Text(
                            englishState.isEnglishSelected ? 'Clear' : 'གསལ།'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: [
                      if (audioReceivedToLocal == true)
                        AudioPlayer(
                          source: audiofilepath,
                        )
                      else
                        const Text(
                            'Audio player will appear here after being loaded'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
