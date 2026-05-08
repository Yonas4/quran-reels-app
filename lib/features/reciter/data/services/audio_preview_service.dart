import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:quran_reels/core/constants/app_exceptions.dart';

class AudioPreviewService {
  AudioPlayer? _player;
  String? _currentUrl;

  Future<void> playPreview(String audioUrl) async {
    try {
      if (_player != null && _currentUrl == audioUrl) {
        await _player!.play();
        return;
      }

      await stopPreview();
      _player = AudioPlayer();
      _currentUrl = audioUrl;

      await _player!.setUrl(audioUrl);
      await _player!.play();
    } catch (e) {
      throw NetworkException('Failed to play audio preview: $e');
    }
  }

  Future<void> pausePreview() async {
    await _player?.pause();
  }

  Future<void> stopPreview() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
    _currentUrl = null;
  }

  Stream<Duration> get positionStream {
    _player ??= AudioPlayer();
    return _player!.positionStream;
  }

  Future<Duration?> get duration async {
    _player ??= AudioPlayer();
    return _player!.duration;
  }

  Stream<PlayerState> get playerStateStream {
    _player ??= AudioPlayer();
    return _player!.playerStateStream;
  }

  void dispose() {
    _player?.dispose();
    _player = null;
    _currentUrl = null;
  }
}