import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode;
  double width;

  AudioPlayerWidget({
    Key key,
    @required this.url,
    this.mode = PlayerMode.MEDIA_PLAYER,
    this.width,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, mode,);
  }
}

class _PlayerWidgetState extends State<AudioPlayerWidget> with TickerProviderStateMixin{

   Animation<double> _animation;
   AnimationController _controller;

  String url;
  PlayerMode mode;
  double width;

  AudioPlayer _audioPlayer;
  PlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.STOPPED;
  PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  bool get _isPlaying => _playerState == PlayerState.PLAYING;
  bool get _isPaused => _playerState == PlayerState.PAUSED;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.')?.first ?? '';

  bool get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRoute.EARPIECE;

  var format = NumberFormat('00');

  _PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();

    width = widget.width ?? Get.width * .8;

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(30)
        ),
        width: width,
        height: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (_duration != null && _position != null)
                Container(
                  color: Colors.white,
                  // ignore: null_aware_before_operator
                  width: (width * (_position.inMilliseconds / _duration.inMilliseconds)) < 0 ? 0 : (width * (_position.inMilliseconds / _duration.inMilliseconds)),
                  height: 30,

                ),
              if(_position != null && _duration != null)
                Positioned(child:
                // ignore: null_aware_before_operator
                Text("${format.format(_position.inSeconds ~/ 60)}:${format.format(_position.inSeconds % 60)} / ${format.format(_duration.inSeconds ~/ 60)}:${format.format(_duration.inSeconds % 60)}"),
                  right: 20,
                )
              else Positioned(child: Text("-:-"), right: 20,),
              Positioned(
                left: 12,
                child: Row( children: [
                  GestureDetector(
                    child: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: _animation),
                    onTap: (){
                      _isPlaying ? null : _play();
                      _isPlaying ? _pause() : null;
                      // if(_isPlaying)
                      //   _pause();
                      // if(_isPaused)
                      //   _play();
                    },
                  ),
                ]),
              ),


              //   Slider(
              //       value: position?.inMilliseconds?.toDouble() ?? 0.0,
              //       onChanged: (double value) {
              //         return audioPlayer.seek((value / 1000).roundToDouble());
              //       },
              //       min: 0.0,
              //       max: duration.inMilliseconds.toDouble()),
              // if (position != null) _buildMuteButtons(),
              // if (position != null) _buildProgressView()
            ],
          ),
        ),
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // optional: listen for notification updates in the background
        _audioPlayer.notificationService.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.notificationService.setNotification(
          title: 'App Name',
          artist: 'Artist or blank',
          albumTitle: 'Name or blank',
          imageUrl: 'Image URL or blank',
          forwardSkipInterval: const Duration(seconds: 30), // default is 30s
          backwardSkipInterval: const Duration(seconds: 30), // default is 30s
          duration: duration,
          enableNextTrackButton: true,
          enablePreviousTrackButton: true,
        );
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
          _onComplete();
          setState(() {
            _position = _duration;
          });
        });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.STOPPED;
        _duration = const Duration();
        _position = const Duration();
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.notificationService.onPlayerCommand.listen((command) {
          print('command: $command');
        });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _audioPlayerState = state);
      }
    });

    _playingRouteState = PlayingRoute.SPEAKERS;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
        _duration != null &&
        _position.inMilliseconds > 0 &&
        _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(Uri.encodeFull(url), position: playPosition);
    _controller.forward();
    print("____play ${Uri.encodeFull(url)} => $playPosition");
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(1);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    _controller.reverse();
    print("____pause");
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      setState(() => _playingRouteState = _playingRouteState.toggle());
    }
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.STOPPED);
  }
}