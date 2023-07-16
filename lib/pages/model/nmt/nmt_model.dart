// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print, camel_case_types, unused_element
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../api/data.dart';

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
  bool isButtonEnable = false;
  String text = '';
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

  void translate() {
    setState(() {
      isLoading = true;
    });

    String inputValue = languageController.text;
    String src_lang = getLanguageCode(originLanguage);
    String tgt_lang = getLanguageCode(destinationLanguage);

    DataServices.translateText(inputValue, src_lang, tgt_lang).then(
      (value) => {
        print(value),
        if (value['status'] == "success")
          {
            setState(() {
              _output_controller.text = value['data'];
              isLoading = false;
              isOutput = true;
            })
          }
        else if (value['status' == 'failed'])
          {
            setState(() {
              _output_controller.text = value['data'];
              isLoading = false;
              isOutput = true;
            })
          }
        else
          {
            setState(() {
              _output_controller.text =
                  "We apologize for the inconvenience caused. An unexpected error has occurred. Please try again at a later time. Thank you for your understanding and patience.";
              isLoading = false;
              isOutput = true;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);

    if (originLanguage == 'From' && destinationLanguage == 'To') {
      if (englishState.isEnglishSelected) {
        originLanguage = 'English';
        destinationLanguage = 'Dzongkha';
      } else {
        originLanguage = 'Dzongkha';
        destinationLanguage = 'English';
      }
    }

    String hint =
        englishState.isEnglishSelected ? 'Enter text' : "ཚིག་ཡིག་བཙུགས།";

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
      final String text = _output_controller.text;
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        _showSnackbar('Text copied successfully');
      });
    }

    return Scaffold(
      appBar: AppbarWidget(
          title: englishState.isEnglishSelected
              ? "Dzongkha Translation"
              : 'རྫོང་ཁ་སྐད་སྒྱུར།',
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
                const Column(
                  children: [
                    Row(
                      children: [
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
                      children: [
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
                autofocus: false,
                maxLines: null,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 37, 58, 107),
                      width: 1,
                    ),
                  ),

                  errorStyle: const TextStyle(color: Colors.red, fontSize: 15),
                  contentPadding:
                      const EdgeInsets.all(10), // Padding for the entered text
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
                            translate();
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
                    englishState.isEnglishSelected ? "Clear" : "བསལ།",
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
                      style: const TextStyle(color: Colors.black54),
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
