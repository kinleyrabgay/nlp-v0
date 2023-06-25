import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
  static const double _controlSize = 56;

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

  // update the progress value in the SharedPreferences
  void incrementProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int progressValue = ((prefs.getInt('progress') ?? 0) + 1);
    await prefs.setInt('progress', progressValue);
  }

  @override
  Widget build(BuildContext context) {
    final englishState = Provider.of<EnglishState>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 200,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildSlider(constraints.maxWidth),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _buildControl(),
                          _buildDownload(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
    icon = Icon(Icons.download_rounded, color: Colors.white, size: 24);
    // color = theme.primaryColor.withOpacity(0.1);
    color = englishState.isEnglishSelected
        ? Color.fromARGB(255, 37, 58, 107)
        : Color.fromARGB(255, 243, 181, 56);

    // Color color;
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            //download audio
          },
        ),
      ),
    );
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
              ? Color.fromARGB(255, 37, 58, 107)
              : Color.fromARGB(255, 243, 181, 56),
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

  Widget _buildSlider(double widgetWidth) {
    final englishState = Provider.of<EnglishState>(context);
    final duration = _duration;
    final position = _position;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(255, 238, 236, 236),
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 2.0,
                  trackShape: RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  activeColor: englishState.isEnglishSelected
                      ? Color.fromARGB(255, 37, 58, 107)
                      : Color.fromARGB(255, 243, 181, 56),
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
                    // Pause the player when dragging starts
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                      _audioPlayer.pause();
                    }
                  },
                  onChangeEnd: (double value) async {
                    // Restore previous player state after dragging ends
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
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> play() {
    return _audioPlayer.play(
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source),
    );
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}
