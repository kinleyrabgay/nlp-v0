// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print, camel_case_types, unused_element
import 'dart:convert';
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
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
  bool isLoading = false;
  bool isOutput = false;
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
    setState(() {
      isLoading = true;
    });
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
        isLoading = false;
        isOutput = true;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  bool isButtonEnable = false;
  String text = '';

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    // Set the initial dropdown values based on the default language
    if (originLanguage == 'From' && destinationLanguage == 'To') {
      if (englishState.isEnglishSelected) {
        originLanguage = 'English';
        destinationLanguage = 'Dzongkha';
      } else {
        originLanguage = 'Dzongkha';
        destinationLanguage = 'English';
      }
    }
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
      final String text = _output_controller.text;
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        _showSnackbar('Text copied successfully');
      });
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha Translation"
              : 'རྗོང་ཁ་ ཨེན་ཨེལ་པི།',
          text: _getAppBarText(englishState)),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  focusColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  hint: Text(originLanguage,
                      style: const TextStyle(color: Colors.black)),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: languages.map((String dropDownStringItem) {
                    return DropdownMenuItem(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      originLanguage = value!;
                      if (originLanguage == destinationLanguage) {
                        destinationLanguage = (originLanguage == 'English')
                            ? 'Dzongkha'
                            : 'English';
                      }
                    });
                  },
                ),
                Column(
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          width: 1,
                          child: Icon(
                            CupertinoIcons.arrow_left,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          child: Icon(CupertinoIcons.arrow_right, size: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                DropdownButton(
                  focusColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  iconEnabledColor: Colors.black,
                  hint: Text(
                    destinationLanguage,
                    style: const TextStyle(color: Colors.black),
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: languages.map((String dropDownStringItem) {
                    return DropdownMenuItem(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      destinationLanguage = value!;
                      if (destinationLanguage == originLanguage) {
                        originLanguage = (destinationLanguage == 'English')
                            ? 'Dzongkha'
                            : 'English';
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                cursorColor: Colors.black,
                autofocus: false,
                maxLines: null,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Enter your text',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  // border: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)), // Set border radius to 10
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 37, 58, 107),
                      width: 1,
                    ),
                  ),

                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  contentPadding:
                      EdgeInsets.all(10), // Padding for the entered text
                ),
                controller: languageController,
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
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: englishState.isEnglishSelected
                        ? const Color.fromARGB(255, 37, 58, 107)
                        : Colors.orange,
                    fixedSize: const Size(150, 50),
                  ),
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
                            fetchDataFromAPI();
                          }
                        }, // Set onPressed to null when the button is disabled
                  child: Text(
                    englishState.isEnglishSelected
                        ? 'Translate'
                        : 'སྐད་སྒྱུར་འབད།',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                if (isLoading)
                  const SpinKitFadingCircle(
                      color: Color.fromARGB(255, 37, 58, 107), size: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 235, 44, 76), //255, 42, 188, 108
                    fixedSize:
                        const Size(150, 50), // Set the desired width and height
                  ),
                  onPressed: () {
                    setState(() {
                      languageController.clear();
                      _output_controller.clear();
                      isOutput = false; // Update the isOutput variable
                      text = "";
                    });
                  },
                  child: Text(
                    englishState.isEnglishSelected ? "Clear" : "གསལ།",
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // if(isOutput) {}
            Visibility(
              visible: isOutput,
              child: Expanded(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextFormField(
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 37, 58, 107),
                            width: 1,
                          ),
                        ),
                        errorStyle: TextStyle(color: Colors.red, fontSize: 15),
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
