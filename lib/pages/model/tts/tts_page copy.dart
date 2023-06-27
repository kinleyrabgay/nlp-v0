// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:math';
import 'package:audio_slider/audio_slider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  _TTSModelState createState() => _TTSModelState();
}

class _TTSModelState extends State<TTSModel> {
  // Duration duration = Duration.zero;
  // Duration position = Duration.zero;
  // Timer? timer;
  // List<double> valueData = <double>[];

  // String formatTime(int seconds) {
  //   return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  // }

  bool isLoading = false;
  var _predicted_text_controller = TextEditingController();
  var text_controller = TextEditingController();

  String text = '';
  bool isPlaying = false;
  bool audioReceived = false;
  bool audioReceivedToLocal = false;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
    // timer = Timer.periodic(const Duration(milliseconds: 0), (timer) {
    //   valueData.add(20 + Random().nextInt(5).toDouble());
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Dispose the audio player when the widget is disposed
    super.dispose();
    // timer?.cancel();
  }

  void stopAudio() {
    audioPlayer.stop();
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
      bool audioIsReceivedStatus = await fetchAudioData(text);

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

      // Play the audio file.
      AudioPlayer player = AudioPlayer();
      await player.play(DeviceFileSource(filePath));
    }

    Future<void> pause() async {
      audioPlayer.pause();
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha NLP"
              : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
          text: _getAppBarText(englishState)),
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
                      height: 400.0,
                      width: 300.0,
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
                            backgroundColor: Color.fromARGB(255, 37, 58, 107),
                            minimumSize: const Size(150.0, 48.0),
                          ),
                          child: isLoading
                              ? Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: const Color(0XFF0F1F41),
                                    size: 40.0,
                                  ),
                                )
                              : const Text('Generate Audio'),
                        ),
                        ElevatedButton(
                          onPressed: text_controller.clear,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            textStyle: const TextStyle(fontSize: 14.0),
                            backgroundColor: Color.fromARGB(255, 37, 58, 107),
                            minimumSize: const Size(150.0, 48.0),
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      children: [
                        if (audioReceivedToLocal == true)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 37, 58, 107),
                                    radius: 20,
                                    child: IconButton(
                                      color: Color.fromARGB(255, 242, 243, 247),
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPlaying = !isPlaying;
                                          if (isPlaying) {
                                            playAudioFromTempDir();
                                          } else {
                                            audioPlayer.pause();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 37, 58, 107),
                                    radius: 20,
                                    child: IconButton(
                                      onPressed: stopAudio,
                                      icon: Icon(Icons.stop),
                                      iconSize: 20,
                                      color: Color.fromARGB(255, 242, 243, 247),
                                    ),
                                  ),
                                  Slider(
                                    onChanged: (value) {},
                                    value: 0.0,
                                    min: 0.0,
                                    max: 1.0,
                                    activeColor:
                                        Color.fromARGB(255, 37, 58, 107),
                                    inactiveColor:
                                        Color.fromARGB(255, 37, 58, 107)
                                            .withOpacity(0.3),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '00:00',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      Text(
                                        '00:00',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                            ],
                          )
                        else
                          const Text(
                              'Audio player will appear here after being loaded'),
                      ],
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
