import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../api/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayer extends StatefulWidget {
  final String source;
  final VoidCallback onDelete;
  final VoidCallback onSuccess;
  final String currentId;

  const AudioPlayer({
    Key? key,
    required this.source,
    required this.onDelete,
    required this.onSuccess,
    required this.currentId,
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

  void uploadAudio(file, id, user) {
    // ignore: avoid_print
    DataServices.uploadAudio(file, id, user).then((value) => {print(value)});
  }

  // update the progress value in the SharedPreferences
  void incrementProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int progressValue = ((prefs.getInt('progress') ?? 0) + 1);
    await prefs.setInt('progress', progressValue);
  }

  @override
  Widget build(BuildContext context) {
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
                  // color: Colors.blue,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildSlider(constraints.maxWidth),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildControl(),
                          _buildDelete(),
                          _buildSuccess(),
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

  Widget _buildDelete() {
    Icon icon;
    Color color;
    final theme = Theme.of(context);
    icon = Icon(Icons.delete, color: theme.primaryColor, size: 24);
    color = theme.primaryColor.withOpacity(0.1);

    // Color color;
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
            child: SizedBox(
                width: _controlSize, height: _controlSize, child: icon),
            onTap: () {
              stop().then((value) => widget.onDelete());
            }),
      ),
    );
  }

  Widget _buildSuccess() {
    Icon icon;
    Color color;

    final theme = Theme.of(context);
    icon = Icon(Icons.check, color: theme.primaryColor, size: 24);
    // color = theme.primaryColor.withOpacity(0.1);
    color = const Color(0xFF5ACFC9);

    // Color color;
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmation'),
                  content:
                      const Text('Are you sure you want to upload the audio?'),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFC6D2D2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                // Upload the audio
                                uploadAudio(
                                    widget.source, widget.currentId, "1");
                                incrementProgress();
                                stop().then((value) => widget.onSuccess());
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF5ACFC9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'Okay',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
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
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

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
              // width: width,
              width: MediaQuery.of(context).size.width * 0.7,
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 2.0,
                  trackShape: RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  activeColor: const Color(0xFF5ACFC9),
                  inactiveColor: const Color.fromARGB(255, 92, 90, 90),
                  value:
                      canSetValue ? _position!.inMilliseconds.toDouble() : 0.0,
                  min: 0.0,
                  max: duration?.inMilliseconds.toDouble() ?? 0.0,
                  onChanged: (double value) {
                    if (canSetValue) {
                      _audioPlayer.seek(Duration(milliseconds: value.round()));
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '${_position?.inMinutes ?? 0}:${(_position?.inSeconds ?? 0) % 60}',
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
