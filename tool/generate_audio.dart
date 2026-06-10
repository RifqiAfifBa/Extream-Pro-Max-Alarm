import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final dir = Directory('assets/audio');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final sr = 22050;
  final dur = 6;
  final n = sr * dur;

  final sounds = <String, List<double> Function(int, int)>{
    'default_bell': _bell,
    'morning_wake': _morning,
    'sunrise': _sunrise,
    'gentle_wave': _wave,
    'energetic_beat': _beat,
    'classic_alarm': _classic,
  };

  for (final e in sounds.entries) {
    final samples = e.value(n, sr);
    _writeWav('assets/audio/${e.key}.wav', samples, sr);
    print('Generated ${e.key}.wav');
  }
  print('All audio files generated!');
}

List<double> _bell(int n, int sr) {
  final r = Random(42);
  return List.generate(n, (i) {
    final t = i / sr;
    final env = t < 0.05
        ? t / 0.05
        : exp(-(t - 0.05) * 0.8);
    final s = sin(2 * pi * 880 * t) +
        0.5 * sin(2 * pi * 1320 * t) +
        0.25 * sin(2 * pi * 1760 * t) +
        0.05 * (r.nextDouble() - 0.5);
    return 0.35 * env * s;
  });
}

List<double> _morning(int n, int sr) {
  final r = Random(42);
  return List.generate(n, (i) {
    final t = i / sr;
    final chirp = sin(2 * pi * (2000 + 2000 * sin(2 * pi * 4 * t)) * t);
    final bird1 = sin(2 * pi * 1200 * t) * max(0, sin(2 * pi * 2.5 * t));
    final bird2 = sin(2 * pi * 1800 * t) * max(0, sin(2 * pi * 3.7 * t));
    final noise = 0.03 * (r.nextDouble() - 0.5);
    return 0.3 * (0.5 * chirp + 0.3 * bird1 + 0.2 * bird2 + noise);
  });
}

List<double> _sunrise(int n, int sr) {
  final r = Random(42);
  return List.generate(n, (i) {
    final t = i / sr;
    final pad = sin(2 * pi * 220 * t) * 0.6 +
        sin(2 * pi * 330 * t) * 0.4 +
        sin(2 * pi * 440 * t) * 0.2;
    final mod = 0.5 + 0.5 * sin(2 * pi * 0.15 * t);
    final noise = 0.02 * (r.nextDouble() - 0.5);
    final fadeIn = min(1.0, t / 2.0);
    return 0.35 * fadeIn * mod * pad + noise;
  });
}

List<double> _wave(int n, int sr) {
  final r = Random(42);
  return List.generate(n, (i) {
    final t = i / sr;
    final wave = sin(2 * pi * 180 * t) * 0.5 +
        sin(2 * pi * 270 * t) * 0.3 +
        sin(2 * pi * 360 * t) * 0.2;
    final swell = 0.5 + 0.5 * sin(2 * pi * 0.1 * t);
    final whoosh = 0.1 * sin(2 * pi * 600 * t) *
        (0.5 + 0.5 * sin(2 * pi * 0.3 * t));
    final noise = 0.04 * (r.nextDouble() - 0.5);
    return 0.35 * swell * wave + whoosh + noise;
  });
}

List<double> _beat(int n, int sr) {
  final r = Random(42);
  return List.generate(n, (i) {
    final t = i / sr;
    final bpm = 140.0;
    final beatPhase = (t * bpm / 60.0) % 1.0;
    final kick = beatPhase < 0.1
        ? sin(pi * beatPhase / 0.1) * 0.8
        : 0.0;
    final snareEnv = beatPhase > 0.5 && beatPhase < 0.55
        ? sin(pi * (beatPhase - 0.5) / 0.05)
        : 0.0;
    final snare = snareEnv * 0.3 * (r.nextDouble() - 0.5);
    final bass = sin(2 * pi * 100 * t) * 0.15;
    final lead = sin(2 * pi * 440 * t) *
        (0.5 + 0.5 * sin(2 * pi * 8 * t)) * 0.1;
    return kick + snare + bass + lead;
  });
}

List<double> _classic(int n, int sr) {
  final r = Random(42);
  return List.generate(n, (i) {
    final t = i / sr;
    final pulse = (sin(2 * pi * 3 * t) > 0) ? 1.0 : 0.0;
    final freq = pulse > 0 ? 800.0 : 1000.0;
    final tone = sin(2 * pi * freq * t);
    final tick = 0.04 * (r.nextDouble() - 0.5);
    return 0.4 * tone + tick;
  });
}

void _writeWav(String path, List<double> samples, int sr) {
  final numSamples = samples.length;
  final dataSize = numSamples * 2;
  final fileSize = 36 + dataSize;
  final buf = ByteData(44 + dataSize);

  void _w(String s, int off) {
    for (var j = 0; j < 4; j++) buf.setUint8(off + j, s.codeUnitAt(j));
  }

  _w('RIFF', 0);
  buf.setUint32(4, fileSize, Endian.little);
  _w('WAVE', 8);
  _w('fmt ', 12);
  buf.setUint32(16, 16, Endian.little);
  buf.setUint16(20, 1, Endian.little);
  buf.setUint16(22, 1, Endian.little);
  buf.setUint32(24, sr, Endian.little);
  buf.setUint32(28, sr * 2, Endian.little);
  buf.setUint16(32, 2, Endian.little);
  buf.setUint16(34, 16, Endian.little);
  _w('data', 36);
  buf.setUint32(40, dataSize, Endian.little);

  for (var i = 0; i < numSamples; i++) {
    final clamped = samples[i].clamp(-1.0, 1.0);
    final val = (clamped * 32767).round();
    buf.setInt16(44 + i * 2, val, Endian.little);
  }

  File(path).writeAsBytesSync(buf.buffer.asUint8List());
}
