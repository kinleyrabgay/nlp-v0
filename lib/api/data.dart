// ignore_for_file: avoid_print, unused_import, constant_identifier_names, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataServices {
  // URL
  static const TRANSCRIBE_AUDIO =
      'https://nlp.cst.edu.bt/asr/transcribe-audio/';
  static const GENERATE_AUDIO = 'https://nlp.cst.edu.bt/tts/';
  static const TRANSLATE_TEXT = 'https://nlp.cst.edu.bt/nmt/api/';

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
        print(response.statusCode);
        return {};
      }
    } catch (e, st) {
      print('error >>' + st.toString());
      return {};
    }
  }
  //ASR Service =================

  // TTS Services
  static Future<Map> generateAudio(text) async {
    try {
      final body = {'inputText': text};

      final response =
          await http.post(Uri.parse(GENERATE_AUDIO), body: jsonEncode(body));

      // return response;
      if (response.statusCode == 200) {
        return {'status': 'success', "data": response.bodyBytes};
      } else {
        print(response.statusCode);
        return {"status": 'failed', 'data': "server error"};
      }
    } catch (e, st) {
      print('error >>' + st.toString());
      return {"status": 'failed', 'data': "Unexpected error"};
    }
  }
  // TTS END =======================================================

  // NMT Services
  static Future<Map> translateText(text, src_lang, tgt_lang) async {
    try {
      final data = {
        'text': text,
        'src_lang': src_lang,
        'tgt_lang': tgt_lang,
      };

      final response =
          await http.post(Uri.parse(TRANSLATE_TEXT), body: json.encode(data));

      print("transcribeAudio >> Response:: ${response}\n");
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final translatedText = jsonData['text'] as String;
        return {"status": 'success', 'data': translatedText};
      } else {
        print(response.statusCode);
        return {"status": 'failed', 'data': "server error"};
      }
    } catch (e, st) {
      print('error >>' + st.toString());
      return {"status": 'failed', 'data': "Unexpected error"};
    }
  }
  // NMT END =======================================================
//services (End) _______________________________________________________________________________
}
