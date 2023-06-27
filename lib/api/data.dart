// ignore_for_file: avoid_print, unused_import, constant_identifier_names, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataServices {
  static const TRANSCRIBE_AUDIO =
      'https://nlp.cst.edu.bt/asr/transcribe-audio/';
  // static const TRANSCRIBE_AUDIO =
  //     'http://10.2.4.138:8000/asr/transcribe-audio/';

  //ASR Service
  static Future<Map> transcribeAudio(file, modelid) async {
    print("transcribeAudio Called");
    print(modelid);
    try {
      File audioFile = File(file);
      print(audioFile.path);

      var request = http.MultipartRequest('POST', Uri.parse(TRANSCRIBE_AUDIO));
      request.files
          .add(await http.MultipartFile.fromPath('audio', audioFile.path));

      request.fields['modelid'] = modelid.toString();

      print("request fields added ");

      var response = await request.send();

      print("transcribeAudio >> Response:: ${response}\n");
      if (response.statusCode == 200) {
        var responseString = await response.stream
            .bytesToString()
            .then((value) => value.toString());
        Map jsonList = jsonDecode(responseString);
        return jsonList;
      } else {
        return {};
      }
    } catch (e, st) {
      print('error >>' + st.toString());
      return {};
    }
  }
  //ASR Service =================

  // TTS Services

  // TTS END =======================================================

  // NMT Services

  // NMT END =======================================================

//services (End) _______________________________________________________________________________
}
