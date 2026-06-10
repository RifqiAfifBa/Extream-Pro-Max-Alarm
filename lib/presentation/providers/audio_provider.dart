import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final alarmAudioProvider = Provider<AlarmAudioService>((ref) {
  return AlarmAudioService();
});

class AlarmAudioService {
  AudioPlayer? _player;
  AudioPlayer? _previewPlayer;

  String soundIdToAsset(String soundId) {
    return 'audio/$soundId.wav';
  }

  Future<void> playAlarmSound(String soundId, {double volume = 1.0}) async {
    await stopAlarmSound();
    _player = AudioPlayer();
    _player!.setReleaseMode(ReleaseMode.loop);
    _player!.setVolume(volume);
    await _player!.play(AssetSource(soundIdToAsset(soundId)));
  }

  Future<void> stopAlarmSound() async {
    if (_player != null) {
      await _player!.stop();
      _player!.dispose();
      _player = null;
    }
  }

  Future<void> setAlarmVolume(double volume) async {
    if (_player != null) {
      await _player!.setVolume(volume);
    }
  }

  Future<void> previewSound(String soundId) async {
    await stopPreview();
    _previewPlayer = AudioPlayer();
    _previewPlayer!.setReleaseMode(ReleaseMode.stop);
    await _previewPlayer!.play(AssetSource(soundIdToAsset(soundId)));
  }

  Future<void> stopPreview() async {
    if (_previewPlayer != null) {
      await _previewPlayer!.stop();
      _previewPlayer!.dispose();
      _previewPlayer = null;
    }
  }

  void dispose() {
    stopAlarmSound();
    stopPreview();
  }
}
