// ignore_for_file: avoid_print, unused_import, constant_identifier_names, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataServices {
  static const GET_TRANSCRIPTION =
      'http://10.2.5.154:8000/next_transcription/2/';
  static const UPLOAD_AUDIO = 'http://10.2.5.154:8000/upload/';
  static const TRANSCRIBE_AUDIO = 'http://10.2.5.154:8000/transcribe-audio/';

  static Future<Map> getTranscription() async {
    try {
      print("get data called");
      final response = await http.get(Uri.parse(GET_TRANSCRIPTION));
      print("getTranscription >> Response: ${response.body}\n");
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map jsonList = jsonDecode(response.body);
        return jsonList;
      } else {
        return {};
      }
    } catch (e, st) {
      print('error >>' + st.toString());
      return {};
    }
  }

  static Future<String> uploadAudio(file, id, user) async {
    print('$file, $id, $user');
    print("Upload Data Called");
    try {
      File audioFile = File(file);
      print(audioFile.path);

      var request = http.MultipartRequest('POST', Uri.parse(UPLOAD_AUDIO));
      request.fields['transcription_id'] = id; // Add the id to the request body
      request.fields['user_id'] = user; // Add the username to the request body
      request.files
          .add(await http.MultipartFile.fromPath('audio', audioFile.path));
      var response = await request.send();

      print("uploadAudio >> Response:: ${response}\n");
      if (response.statusCode == 200) {
        var responseString = await response.stream
            .bytesToString()
            .then((value) => value.toString());
        String jsonList = responseString;
        return jsonList;
      } else {
        return response.statusCode.toString();
      }
    } catch (e, st) {
      print('error >>' + st.toString());
      return "";
    }
  }

  static Future<Map> transcribeAudio(file) async {
    print("transcribeAudio Called");
    try {
      File audioFile = File(file);
      print(audioFile.path);

      var request = http.MultipartRequest('POST', Uri.parse(TRANSCRIBE_AUDIO));
      request.files
          .add(await http.MultipartFile.fromPath('audio', audioFile.path));
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

//services (End) _______________________________________________________________________________
}
