// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print, unnecessary_null_comparison
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../api/data.dart';
import 'model_testing.dart';

class TryModel extends StatefulWidget {
  const TryModel({super.key});

  @override
  State<TryModel> createState() => _TryModelState();
}

class _TryModelState extends State<TryModel> {
  bool isLoading = false;
  var _predicted_text_controller = TextEditingController();
  bool isGeneratingOutput = false;
  bool isOutput = false;

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  void transcribeAudio(file) {
    setState(() {
      isLoading = true; // start the spinner
      isGeneratingOutput = true;
      isOutput = false;
    });
    DataServices.transcribeAudio(file, 2).then(
      (value) => {
        print(value),
        if (value != null)
          {
            if (value["transcription"].length > 0)
              {
                setState(() {
                  _predicted_text_controller.text = value["transcription"];
                  isLoading = false; // stop the spinner
                  isOutput = true; // display the output
                  isGeneratingOutput = false; // enable the button again
                })
              }
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? "Discover and enjoy our model's capabilities"
          : "ང་བཅས་ཀྱི་དཔེ་གཞིའི་ནུས་ཤུགས་ཚུ་འཚོལ་ཏེ་སྤྲོ་བ་བཏོན།";
    }

    void _showSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    void _copyTextToClipboard() {
      final String text = _predicted_text_controller.text;
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        _showSnackbar(englishState.isEnglishSelected
            ? 'Text copied successfully'
            : 'ཚིག་ཡིག་འདྲ་བཤུས་ལེགས་ཤོམ་སྦེ་རྐྱབ་ཅི།');
      });
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha ASR"
              : 'རྫོང་ཁའི་རང་བཞིན་བློ་འཛིན།',
          text: _getAppBarText(englishState)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            englishState.isEnglishSelected
                ? const Text(
                    "Record or Upload Audio",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  )
                : const Text(
                    "ཐོས་སྒྲ་བཙུགས་ ཡངན་ གདམ་ཁ་རྐྱབ།",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGeneratingOutput
                        ? Colors.grey // Set the color to indicate it's disabled
                        : const Color.fromARGB(255, 255, 255, 255),
                    fixedSize:
                        const Size(150, 50), // Set the desired width and height
                  ),
                  onPressed: () {
                    isOutput = false;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isGeneratingOutput
                          ? const Text(
                              'Generating...',
                              style: TextStyle(color: Colors.white),
                            )
                          : ModelTestRecorder(
                              onStop: (String path) {
                                setState(() {
                                  _predicted_text_controller.text = "";
                                });
                                ('Recorded file path: $path');
                                transcribeAudio(path);
                              },
                            )
                    ],
                  ),
                ),
                if (isLoading)
                  const Center(
                    child: SpinKitFadingCircle(
                        color: Color.fromARGB(255, 37, 58, 107), size: 40),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: englishState.isEnglishSelected
                        ? const Color.fromARGB(255, 37, 58, 107)
                        : Colors.orange,
                    fixedSize:
                        const Size(150, 50), // Set the desired width and height
                  ),
                  onPressed: () async {
                    try {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.audio,
                        allowMultiple: false,
                      );
                      if (result != null) {
                        PlatformFile file = result.files.first;
                        print(file.name);
                        print(file.bytes);
                        print(file.size);
                        print(file.extension);
                        print(file.path);
                        transcribeAudio(file.path);
                      } else {
                        // File selection canceled by the user
                        print('File selection canceled');
                      }
                    } catch (e) {
                      print("Permission denied $e");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upload,
                        color: Colors.white,
                        size: 20,
                      ),
                      englishState.isEnglishSelected
                          ? const Flexible(
                              child: FittedBox(
                                child: Text(
                                  "Upload",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                          : const Flexible(
                              child: FittedBox(
                                child: Text(
                                  "ཐོས་སྒྲ་བཙུགས།",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: isOutput,
              child: Expanded(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextFormField(
                      controller: _predicted_text_controller,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      maxLines: null,
                      enabled: false,
                      style: const TextStyle(color: Colors.black54),
                      decoration: const InputDecoration(
                        labelText: '',
                        labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Set border radius to 10
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 37, 58, 107),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        _copyTextToClipboard();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
