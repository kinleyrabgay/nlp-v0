// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print
import 'dart:convert';

import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../api/data.dart';

import 'package:http/http.dart' as http;

class Nmt_model extends StatefulWidget {
  const Nmt_model({super.key});

  @override
  State<Nmt_model> createState() => _Nmt_modelState();
}

class _Nmt_modelState extends State<Nmt_model> {
  var languages = ['Dzongkha', 'English'];
  var originLanguage = 'From';
  var destinationLanguage = "To";
  var output = "";
  TextEditingController languageController = TextEditingController();
  TextEditingController _output_controller = TextEditingController();

  String getLanguageCode(String language) {
    if (language == "English") {
      return "eng_Latn";
    } else if (language == "Dzongkha") {
      return "dzo_Tibt";
    }
    return "--";
  }

  Future<dynamic> fetchDataFromAPI() async {
    final url = Uri.parse('https://nlp.cst.edu.bt/nmt/api/');

    var inputValue = languageController.text;

    final payload = {
      'text': inputValue,
      'src_lang': getLanguageCode(originLanguage),
      'tgt_lang': getLanguageCode(destinationLanguage),
    };

    final response = await http.post(url, body: json.encode(payload));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final translatedText = jsonData['text'] as String;
      setState(() {
        _output_controller.text = translatedText;
        // output = translatedText;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      body: Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  focusColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  hint: Text(
                    originLanguage,
                    style: const TextStyle(color: Colors.black),
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: languages.map((String dropDownStringItem) {
                    return DropdownMenuItem(
                      child: Text(dropDownStringItem),
                      value: dropDownStringItem,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      originLanguage = value!;
                    });
                  },
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 1,
                          child: Icon(
                            CupertinoIcons.arrow_left,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                            child: Icon(CupertinoIcons.arrow_right, size: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 40,
                ),
                DropdownButton(
                  focusColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  hint: Text(
                    destinationLanguage,
                    style: TextStyle(color: Colors.black),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: languages.map((String dropDownStringItem) {
                    return DropdownMenuItem(
                      child: Text(dropDownStringItem),
                      value: dropDownStringItem,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      destinationLanguage = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              // constraints: BoxConstraints(maxHeight: 100),
              child: TextFormField(
                cursorColor: Colors.black,
                autofocus: false,
                expands: true,
                maxLines: null,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Enter your text',
                  labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 37, 58, 107), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 37, 58, 107), width: 1),
                  ),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                ),
                controller: languageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter text to translate';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 44, 154, 243),
                    fixedSize:
                        Size(150, 50), // Set the desired width and height
                  ),
                  onPressed: () {
                    fetchDataFromAPI();
                  },
                  child: const Text(
                    "Translate",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 235, 44, 76), //255, 42, 188, 108
                    fixedSize:
                        Size(150, 50), // Set the desired width and height
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Clear",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              // constraints: BoxConstraints(maxHeight: 100),
              child: TextFormField(
                controller: _output_controller,
                cursorColor: Colors.black,
                autofocus: false,
                expands: true,
                maxLines: null,
                enabled: false,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: '',
                  labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 37, 58, 107), width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 37, 58, 107), width: 1),
                  ),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),
            ),
            // SingleChildScrollView(
            //   child: ConstrainedBox(
            //     constraints: BoxConstraints(
            //       minHeight: MediaQuery.of(context).size.height * 0.3,
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(15.0),
            //       child: Container(
            //         width: MediaQuery.of(context).size.width,
            //         decoration: BoxDecoration(
            //           color: const Color.fromARGB(255, 247, 239, 239),
            //           border: Border.all(
            //               color: Color.fromARGB(255, 37, 58, 107), width: 2),
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         child: SelectableText(
            //           "\n$output",
            //           style: const TextStyle(color: Colors.black, fontSize: 20),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ])),
    );
  }
}
