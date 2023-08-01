// ignore_for_file: unused_field, unused_local_variable, unused_element, avoid_unnecessary_containers

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';

import '../../../provider/state.dart';

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

  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();

  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen(
      (recordState) {
        setState(() => _recordState = recordState);
      },
    );

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.vorbisOgg,
        );
        if (kDebugMode) {
          print('${AudioEncoder.vorbisOgg.name} supported: $isSupported');
        }

        await _audioRecorder.start(
            encoder: AudioEncoder.wav, samplingRate: 16000);
        _recordDuration = 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl(EnglishState englishState) {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 16);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 16);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return InkWell(
      onTap: () {
        (_recordState != RecordState.stop) ? _stop() : _start();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          englishState.isEnglishSelected
              ? FittedBox(
                  child: Text(
                    (_recordState != RecordState.stop) ? "Recording" : "Record",
                    style: (_recordState != RecordState.stop)
                        ? const TextStyle(
                            fontSize: 16, color: Color.fromARGB(255, 255, 0, 0))
                        : const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              : FittedBox(
                  child: Text(
                    (_recordState != RecordState.stop)
                        ? "སྒྲ་ཟུངས་དོ།"
                        : "སྒྲ་ཟུངས།",
                    style: (_recordState != RecordState.stop)
                        ? const TextStyle(
                            fontSize: 14, color: Color.fromARGB(255, 255, 0, 0))
                        : const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);

    String hint =
        englishState.isEnglishSelected ? 'Record' : "རྫོང་ཁིའི་ཚིག་ཡིག་བཙུགས།";

    return Container(
      child: _buildRecordStopControl(englishState),
    );
  }
}
