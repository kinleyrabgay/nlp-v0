import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ModelTestRecorder extends StatefulWidget {
  const ModelTestRecorder(
      {super.key, required this.onStop, this.amplitudeStream});
  final void Function(String path) onStop;
  final Stream<double>? amplitudeStream;

  @override
  State<ModelTestRecorder> createState() => _ModelTestRecorderState();
}

class _ModelTestRecorderState extends State<ModelTestRecorder> {
  final List<double> _amplitudeValues = [];

  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  String audioFile = "";
  bool _recordState = false;

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await _audioRecorder.openRecorder();
  }

  Future<void> _start() async {
    try {
      setState(() {
        _recordState = true;
      });

      await _audioRecorder.startRecorder(
        // codec: Codec.pcm16WAV,
        toFile: 'audio.wav',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    setState(() {
      _recordState = false;
    });

    final path = await _audioRecorder.stopRecorder();
    print("Recorded audio path askdfjaksjdf: $path");

    if (path != null) {
      audioFile = File(path!).toString();
      print("Recorded audio: $audioFile");
      widget.onStop(audioFile);
    }
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 20);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 20);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return InkWell(
      onTap: () {
        (_recordState) ? _stop() : _start();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          FittedBox(
            child: Text(
              (_recordState) ? "Recording" : "Record",
              style: (_recordState)
                  ? TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 255, 0, 0))
                  : TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildRecordStopControl(),
    );
  }
}
