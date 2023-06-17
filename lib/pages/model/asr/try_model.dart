// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _predicted_text_controller.text = "";
  }

  void transcribeAudio(file) {
    setState(() {
      isLoading = true; // start the spinner
    });
    DataServices.transcribeAudio(file).then(
      (value) => {
        if (value["transcription"].length > 0)
          {
            setState(() {
              _predicted_text_controller.text = value["transcription"];
              isLoading = false; // stop the spinner
            })
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
          : 'སྤྱི་བསྟོད་ཀྱི་གཟུགས་ཆོག་འབྲུ་གཡུགས་དང་།';
    }

    return Scaffold(
      appBar: AppbarWidget(text: _getAppBarText(englishState)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: _predicted_text_controller,
                    textAlign: TextAlign.left,
                    expands: true,
                    maxLines: null,
                    enabled: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    style: const TextStyle(fontSize: 18, height: 2),
                  ),
                  if (isLoading) // conditionally render the spinner
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: const Color(0XFF0F1F41),
                        size: 70.0,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.copy,
                    color: Colors.black,
                    size: 20,
                  ),
                  ModelTestRecorder(
                    onStop: (String path) {
                      if (kDebugMode) {
                        ('Recorded file path: $path');
                        transcribeAudio(path);
                      }
                    },
                  ),
                  IconButton(
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
                    icon: const Icon(Icons.upload),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
