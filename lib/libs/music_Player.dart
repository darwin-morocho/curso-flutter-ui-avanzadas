import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:meta/meta.dart';

enum MusicPlayerStatus {
  loading,
  error,
  playing,
  paused,
}

class MusicPlayer {
  MusicPlayer({
    @required this.onNext,
    @required this.onPrev,
  }) {
    _init();
  }

  final VoidCallback onNext, onPrev;

  Completer<FlutterSoundPlayer> _player = Completer();
  ValueNotifier<MusicPlayerStatus> status =
      ValueNotifier(MusicPlayerStatus.loading);

  ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);

  Duration _duration;
  Duration get duration => _duration;
  ValueNotifier<Duration> get position => _position;

  bool get loading {
    return status.value == MusicPlayerStatus.loading;
  }

  bool get playing {
    return status.value == MusicPlayerStatus.playing;
  }

  bool get paused {
    return status.value == MusicPlayerStatus.paused;
  }

  bool get error {
    return status.value == MusicPlayerStatus.error;
  }

  Future<void> play(Track track) async {
    try {
      _duration = null;
      _position.value = Duration.zero;
      status.value = MusicPlayerStatus.loading;
      final player = await _player.future;
      if (player.isPaused || player.isPlaying) {
        await seekTo(Duration.zero);
      }

      //await player.startPlayer(fromURI: track.trackPath);
      await player.startPlayerFromTrack(
        track,
        onPaused: (_) {
          if (_) {
            pause();
          } else {
            resume();
          }
        },
        onSkipForward: () {
          onNext();
        },
        onSkipBackward: () {
          onPrev();
        },
        whenFinished: () {
          onNext();
        },
      );
      //final duration = await flutterSoundHelper.duration(track.trackPath);

    } on PlatformException catch (e) {
      print("error code ${e.code}");
      print("error message ${e.message}");
      print("error details ${e.details}");
      status.value = MusicPlayerStatus.error;
    }
  }

  Future<void> seekTo(Duration position) async {
    _position.value = position;
    await (await _player.future).seekToPlayer(position);
  }

  Future<void> pause() async {
    await (await _player.future).pausePlayer();
    status.value = MusicPlayerStatus.paused;
  }

  Future<void> resume() async {
    await (await _player.future).resumePlayer();
    status.value = MusicPlayerStatus.playing;
  }

  Future<void> dispose() async {
    await (await _player.future).closeAudioSession();
  }

  Future<void> _init() async {
    final player = await FlutterSoundPlayer().openAudioSessionWithUI(
      focus: AudioFocus.requestFocusTransient,
      category: SessionCategory.playback,
      mode: SessionMode.modeDefault,
      audioFlags: outputToSpeaker,
    );
    player.setSubscriptionDuration(Duration(milliseconds: 100));
    _player.complete(player);
    player.onProgress.listen((event) {
      _position.value = _duration == null ? Duration.zero : event.position;
      if (_duration == null || _duration.compareTo(event.duration) != 0) {
        _duration = event.duration;
        status.value = MusicPlayerStatus.playing;
      }
    });
  }
}
