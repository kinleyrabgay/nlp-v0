// ignore_for_file: unused_field, unused_local_variable, unused_element, avoid_unnecessary_containers

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

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

  late final RecorderController recorderController;
  static const double _controlSize = 56;

  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();

  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen(
      (recordState) {
        setState(() => _recordState = recordState);
      },
    );
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen(
          (amp) => setState(() => _amplitude = amp),
        );
    super.initState();
    if (widget.amplitudeStream != null) {
      widget.amplitudeStream!.listen((double amplitude) {
        setState(() {
          _amplitudeValues.add(amplitude);
        });
      });
    }
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

        _startTimer();
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
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 20);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 20);
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
          Text(
            (_recordState != RecordState.stop) ? "Recording" : "Record",
            style: (_recordState != RecordState.stop)
                ? TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 0, 0))
                : TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }
    return Container();
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        setState(() => _recordDuration++);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildRecordStopControl(),
    );
  }
}
