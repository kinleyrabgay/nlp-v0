// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print, depend_on_referenced_packages, library_private_types_in_public_api
import 'dart:convert';
import 'dart:async';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/pages/model/tts/audio_player.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Map> fetchAudioData(String text) async {
  final url = Uri.parse('https://nlp.cst.edu.bt/tts/');
  final headers = {'Content-Type': 'application/json'};
  final body = {'inputText': text};

  final response =
      await http.post(url, headers: headers, body: jsonEncode(body));

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

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha TTS"
              : 'རྫོང་ཁའི་ཚིག་ཡིག་ལས་ངག་ཚིག།',
          text: _getAppBarText(englishState)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)), // Set border radius to 10
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 37, 58, 107),
                      width: 1,
                    ),
                  ),
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 15),
                  contentPadding: const EdgeInsets.all(10), // Pad
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                style: const TextStyle(fontSize: 15.0),
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
                                const SnackBar(
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
                          ? const Color.fromARGB(255, 37, 58, 107)
                          : Colors.orange,
                      // minimumSize: const Size(150.0, 48.0),
                      fixedSize: const Size(150, 50),
                    ),
                    child: Text(englishState.isEnglishSelected
                        ? 'Generate Audio'
                        : 'ཐོས་སྒྲ་བཟོ།'),
                  ),
                  if (isLoading)
                    const SpinKitFadingCircle(
                        color: Color.fromARGB(255, 37, 58, 107), size: 40),
                  ElevatedButton(
                    onPressed: text_controller.clear,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 14.0),
                      backgroundColor: const Color.fromARGB(255, 235, 44, 76),
                      fixedSize: const Size(150, 50),
                    ),
                    child:
                        Text(englishState.isEnglishSelected ? 'Clear' : 'བསལ།'),
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
    );
  }
}
