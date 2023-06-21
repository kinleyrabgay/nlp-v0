// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../api/data.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<bool> fetchAudioData(String text) async {
  // TODO: Change the url to deployed when webapp is deployed
  final url = Uri.parse('http://10.2.5.122:7000/tts/');
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

    return true;
  } else {
    return false;
  }
}

class TTSModel extends StatefulWidget {
  const TTSModel({super.key});

  @override
  State<TTSModel> createState() => _TTSModelState();
}

class _TTSModelState extends State<TTSModel> {
  bool isLoading = false;
  var _predicted_text_controller = TextEditingController();

  String text = '';
  bool isPlaying = false;
  bool audioReceived = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Dispose the audio player when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? "Discover and enjoy our model's capabilities"
          : 'སྤྱི་བསྟོད་ཀྱི་གཟུགས་ཆོག་འབྲུ་གཡུགས་དང་།';
    }

    fetchAudioAndSave(String text) {
      print('Fetch audio data called');
      print(text);
      Future<bool> audioIsReceivedStatus = fetchAudioData(text);
      // ignore: unrelated_type_equality_checks
      if (audioIsReceivedStatus == true) {
        
        print('Audio synthesized and saved');
        print('Now enable the play button and play it.');
      } else {
        print(
            'Failed to get audio from server and save on temporary directory');
      }
    }

    Future<void> playAudioFromTempDir() async {
      var tempDir = await getTemporaryDirectory();
      var filePath = '${tempDir.path}/audio.wav';

      // Play the audio file.
      AudioPlayer player = AudioPlayer();
      await player.play(DeviceFileSource(filePath));
    }

    return Scaffold(
      appBar: AppbarWidget(text: _getAppBarText(englishState)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 600.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 300.0, // Adjust the desired height
                      width: 300.0, // Adjust the desired width
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
                    SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: () => fetchAudioAndSave(text),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: const TextStyle(fontSize: 14.0),
                        minimumSize: const Size(
                          200.0,
                          48.0,
                        ),
                      ),
                      child: const Text('Generate Audio'),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: playAudioFromTempDir,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: const TextStyle(fontSize: 14.0),
                        minimumSize: const Size(
                          100.0,
                          40.0,
                        ),
                      ),
                      child: const Text('Play'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
