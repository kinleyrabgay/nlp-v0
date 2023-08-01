// ignore_for_file: depend_on_referenced_packages, unused_local_variable, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../provider/state.dart';

class AudioPlayer extends StatefulWidget {
  final String source;

  const AudioPlayer({
    Key? key,
    required this.source,
  }) : super(key: key);

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 50;
  final _audioPlayer = ap.AudioPlayer();

  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
      setState(() {});
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSlider(),
                Row(
                  children: [
                    _buildControl(),
                    const SizedBox(width: 10),
                    _buildDownload(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownload() {
    final englishState = Provider.of<EnglishState>(context);
    Icon icon;
    Color color;

    final theme = Theme.of(context);
    icon = const Icon(Icons.download_rounded, color: Colors.white, size: 24);
    color = englishState.isEnglishSelected
        ? const Color.fromARGB(255, 37, 58, 107)
        : Colors.orange;

    // Color color;
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            downloadAudio();
          },
        ),
      ),
    );
  }

  Future<void> downloadAudio() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      try {
        var time = DateTime.now().millisecondsSinceEpoch;
        var downloadPath = "/storage/emulated/0/Download/audio-$time.wav";
        final file = File(downloadPath);

        await file.writeAsBytes(await File(widget.source).readAsBytes());

        print('Audio downloaded successfully: $downloadPath');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio downloaded successfully'),
          ),
        );
      } catch (e) {
        print('Failed to download audio: $e');
      }
    }
  }

  Widget _buildControl() {
    final englishState = Provider.of<EnglishState>(context);
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow,
          color: englishState.isEnglishSelected
              ? const Color.fromARGB(255, 37, 58, 107)
              : Colors.orange,
          size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider() {
    final englishState = Provider.of<EnglishState>(context);
    final duration = _duration;
    final position = _position;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(255, 238, 236, 236),
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 0.7,
                  trackShape: RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  activeColor: englishState.isEnglishSelected
                      ? const Color.fromARGB(255, 37, 58, 107)
                      : const Color.fromARGB(255, 243, 181, 56),
                  inactiveColor: const Color.fromARGB(255, 92, 90, 90),
                  value: position?.inMilliseconds.toDouble() ?? 0.0,
                  min: 0.0,
                  max: duration?.inMilliseconds.toDouble() ?? 0.0,
                  onChanged: (double value) async {
                    await _audioPlayer
                        .seek(Duration(milliseconds: value.round()));
                    setState(() {
                      _position = Duration(milliseconds: value.round());
                    });
                  },
                  onChangeStart: (double value) {
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                      _audioPlayer.pause();
                    }
                  },
                  onChangeEnd: (double value) async {
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                      await _audioPlayer.resume();
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '${position?.inMinutes ?? 0}:${(position?.inSeconds ?? 0) % 60}',
                style: TextStyle(
                  color: englishState.isEnglishSelected
                      ? const Color.fromARGB(255, 37, 58, 107)
                      : Colors.orange,
                  fontSize: 14.0,
                  fontFamily: englishState.isEnglishSelected ? '' : 'Joyig',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> play() async {
    await _audioPlayer.play(
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source),
    );
    setState(() {});
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    setState(() {});
  }

  Future<void> stop() => _audioPlayer.stop();
}
