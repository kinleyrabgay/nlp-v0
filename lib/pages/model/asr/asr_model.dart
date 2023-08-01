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

class AsrModel extends StatefulWidget {
  const AsrModel({super.key});

  @override
  State<AsrModel> createState() => _AsrModelState();
}

class _AsrModelState extends State<AsrModel> {
  bool isLoading = false;
  var _predicted_text_controller = TextEditingController();
  bool isGeneratingOutput = false;
  bool isOutput = false;
  bool isUploadGenerating = false;

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  void transcribeAudio(file, record) {
    setState(() {
      isLoading = true;
      isOutput = false;
      record ? isGeneratingOutput = true : isUploadGenerating = true;
    });
    DataServices.transcribeAudio(file, 2).then(
      (value) => {
        print(value),
        if (value != null)
          {
            if (value["transcription"].length > 0)
              {
                setState(() {
                  _predicted_text_controller.text =
                      value["transcription"].replaceAll(' ', '');
                  isLoading = false;
                  isOutput = true;
                  isGeneratingOutput = false;
                  isUploadGenerating = false;
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

    String getUploadButtonText(
        EnglishState englishState, bool isUploadGenerating) {
      if (isUploadGenerating) {
        return englishState.isEnglishSelected
            ? "Uploading..."
            : "ཐོས་སྒྲ་བཙུགས།";
      } else {
        return englishState.isEnglishSelected ? "Upload" : "ཐོས་སྒྲ་བཙུགས།";
      }
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
                    style: TextStyle(fontSize: 14, color: Colors.black87),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ModelTestRecorder(
                      onStop: (String path) {
                        setState(() {
                          _predicted_text_controller.text = "";
                        });
                        ('Recorded file path: $path');
                        transcribeAudio(path, true);
                      },
                      isGeneratingOutput: isGeneratingOutput,
                    )
                  ],
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
                        transcribeAudio(file.path, false);
                      } else {
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
                        size: 16,
                      ),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            getUploadButtonText(
                              englishState,
                              isUploadGenerating,
                            ),
                            style: const TextStyle(fontSize: 14),
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
