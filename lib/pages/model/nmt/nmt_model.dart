// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_final_fields, avoid_print, camel_case_types, unused_element
import 'package:dzongkha_nlp_mobile/pages/components/app_bar.dart';
import 'package:dzongkha_nlp_mobile/provider/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../api/data.dart';

class NmtModel extends StatefulWidget {
  const NmtModel({super.key});

  @override
  State<NmtModel> createState() => _Nmt_modelState();
}

class _Nmt_modelState extends State<NmtModel> {
  var languages = ['Dzongkha', 'English'];
  var originLanguage = 'From';
  var destinationLanguage = "To";
  var output = "";
  bool isLoading = false;
  bool isOutput = false;
  bool isButtonEnable = false;
  String text = '';
  bool isGeneratingOutput = false;

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
      isOutput = false;
      isGeneratingOutput = true;
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
              isGeneratingOutput = false;
            })
          }
        else if (value['status' == 'failed'])
          {
            setState(() {
              _output_controller.text = value['data'];
              isLoading = false;
              isOutput = true;
              isGeneratingOutput = false;
            })
          }
        else
          {
            setState(
              () {
                _output_controller.text =
                    "We apologize for the inconvenience caused. An unexpected error has occurred. Please try again at a later time. Thank you for your understanding and patience.";
                isLoading = false;
                isOutput = true;
              },
            )
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
      Clipboard.setData(ClipboardData(text: text)).then(
        (_) {
          _showSnackbar(englishState.isEnglishSelected
              ? 'Text copied successfully'
              : 'ཚིག་ཡིག་འདྲ་བཤུས་ལེགས་ཤོམ་སྦེ་རྐྱབ་ཅི།');
        },
      );
    }

    return Scaffold(
      appBar: AppbarWidget(
        title: englishState.isEnglishSelected
            ? "Dzongkha NMT"
            : 'རྫོང་ཁ་སྐད་སྒྱུར།',
        text: _getAppBarText(englishState),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                    hint: Text(
                      originLanguage,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
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
                      setState(
                        () {
                          originLanguage = value!;
                          if (originLanguage == destinationLanguage) {
                            destinationLanguage = (originLanguage == 'English')
                                ? 'Dzongkha'
                                : 'English';
                          }
                        },
                      );
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
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
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
                      setState(
                        () {
                          destinationLanguage = value!;
                          if (destinationLanguage == originLanguage) {
                            originLanguage = (destinationLanguage == 'English')
                                ? 'Dzongkha'
                                : 'English';
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.25),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      autofocus: false,
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 37, 58, 107),
                            width: 1,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      controller: languageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return englishState.isEnglishSelected
                              ? 'This field cannot be empty!'
                              : 'འདི་ས་གོ་སྟོངམ་མ་བཞག།';
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
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.35, 50)),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(englishState.isEnglishSelected
                                      ? 'Please enter text.'
                                      : 'ཚིག་ཡིག་བཙུགས་གནང་།'),
                                ),
                              );
                            } else {
                              translate();
                            }
                          },
                    child: isGeneratingOutput
                        ? Text(
                            englishState.isEnglishSelected
                                ? 'Translating...'
                                : 'སྐད་སྒྱུར་འབད།',
                            style: const TextStyle(fontSize: 14),
                          )
                        : Text(
                            englishState.isEnglishSelected
                                ? 'Translate'
                                : 'སྐད་སྒྱུར་འབད།',
                            style: const TextStyle(fontSize: 14),
                          ),
                  ),
                  if (isLoading)
                    const SpinKitFadingCircle(
                        color: Color.fromARGB(255, 37, 58, 107), size: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 235, 44, 76),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.35, 50)),
                    onPressed: () {
                      setState(() {
                        languageController.clear();
                        _output_controller.clear();
                        isOutput = false;
                        text = "";
                      });
                    },
                    child: Text(
                      englishState.isEnglishSelected ? "Clear" : "བསལ།",
                      style: const TextStyle(fontSize: 14),
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
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 37, 58, 107),
                              width: 1,
                            ),
                          ),
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15),
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
      ),
    );
  }
}
