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
  var model = ['Wav2Vac2XLR', 'Wav2Vac2XLR with LM'];
  var currentmodel = 'Wav2Vac2XLR with LM';

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  void transcribeAudio(file) {
    setState(() {
      isLoading = true; // start the spinner
    });
    DataServices.transcribeAudio(file, model.indexOf(currentmodel) + 1).then(
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
                })
              }
          }
      },
    );
  }

  bool isOutput = false;

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    String _getAppBarText(EnglishState englishState) {
      return englishState.isEnglishSelected
          ? "Discover and enjoy our model's capabilities"
          : 'སྤྱི་བསྟོད་ཀྱི་གཟུགས་ཆོག་འབྲུ་གཡུགས་དང་།';
    }

    void _showSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    void _copyTextToClipboard() {
      final String text = _predicted_text_controller.text;
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        _showSnackbar('Text copied successfully');
      });
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha ASR"
              : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
          text: _getAppBarText(englishState)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              onChanged: (String? newValue) {
                setState(() {
                  currentmodel = newValue!;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromARGB(255, 0, 36, 66),
              ),
              style: const TextStyle(
                color: Color.fromARGB(255, 32, 32, 32),
                fontSize: 13,
              ),
              dropdownColor: const Color.fromARGB(255, 255, 255, 255),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                filled: true,
                fillColor: const Color.fromARGB(255, 235, 235, 235),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.5, color: Color.fromARGB(255, 80, 80, 80)),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Select Model',
                hintStyle: const TextStyle(
                  fontSize: 13,
                ),
              ),
              // value: currentmodel,
              items: model.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              "Upload or Select Audio",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    fixedSize:
                        const Size(150, 50), // Set the desired width and height
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ModelTestRecorder(
                        onStop: (String path) {
                          setState(() {
                            _predicted_text_controller.text = "";
                            // isOutput = false;
                          });
                          ('Recorded file path: $path');
                          transcribeAudio(path);
                        },
                      ),
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
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.upload,
                        color: Colors.white,
                        size: 20,
                      ),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            "Upload Audio",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Visibility(
              visible: true,
              child: Expanded(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextField(
                      controller: _predicted_text_controller,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      maxLines: null,
                      enabled: false,
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
                      style: const TextStyle(fontSize: 18),
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
