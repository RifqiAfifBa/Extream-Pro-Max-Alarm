import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alarm_model.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/audio_provider.dart';

class AlarmRingingScreen extends ConsumerStatefulWidget {
  const AlarmRingingScreen({super.key});

  @override
  ConsumerState<AlarmRingingScreen> createState() =>
      _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends ConsumerState<AlarmRingingScreen>
    with TickerProviderStateMixin {
  late AnimationController _bellShake;
  late AnimationController _shakeError;
  late final AlarmAudioService _audioService;
  AlarmModel? _alarm;
  int _snoozeCount = 0;
  static const int _maxSnooze = 3;
  bool _showError = false;
  final _answerController = TextEditingController();

  int _mathA = 0;
  int _mathB = 0;
  int _mathAnswer = 0;
  final List<String> _wordScramble = [];
  String _riddleAnswer = '';

  @override
  void initState() {
    super.initState();
    _audioService = ref.read(alarmAudioProvider);
    _bellShake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
    _shakeError = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alarm = GoRouterState.of(context).extra as AlarmModel?;
      if (mounted) setState(() {});
      _startAlarm();
      _initChallenge();
    });
  }

  void _initChallenge() {
    if (_alarm == null) return;
    switch (_alarm!.challengeType) {
      case ChallengeType.math:
        _mathA = 3 + DateTime.now().millisecondsSinceEpoch % 8;
        _mathB = 2 + DateTime.now().millisecondsSinceEpoch % 7;
        _mathAnswer = _mathA + _mathB;
        break;
      case ChallengeType.wordArrange:
        _wordScramble
          ..clear()
          ..addAll(['Alarm', 'Mobil', 'Rumah']..shuffle());
        break;
      case ChallengeType.riddle:
        _riddleAnswer = 'piano';
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _bellShake.dispose();
    _shakeError.dispose();
    _audioService.stopAlarmSound();
    super.dispose();
  }

  void _startAlarm() {
    final prefs = ref.read(preferencesProvider);

    _audioService.playAlarmSound(
      prefs.alarmSoundId,
      volume: prefs.gradualVolumeEnabled ? 0.1 : 1.0,
    );

    if (prefs.gradualVolumeEnabled) {
      _rampUpVolume();
    }

    if (prefs.vibrationEnabled) {
      _startVibration();
    }
  }

  void _rampUpVolume() {
    const steps = 10;
    const interval = Duration(milliseconds: 300);
    for (var i = 1; i <= steps; i++) {
      Future.delayed(interval * i, () {
        if (mounted) {
          final vol = 0.1 + (0.9 * i / steps);
          _audioService.setAlarmVolume(vol);
        }
      });
    }
  }

  void _startVibration() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) HapticFeedback.heavyImpact();
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) HapticFeedback.mediumImpact();
    });
  }

  void _snooze() {
    if (_snoozeCount >= _maxSnooze) {
      _dismissAlarm();
      return;
    }
    setState(() => _snoozeCount++);
    if (_snoozeCount >= _maxSnooze) {
      _dismissAlarm();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.snooze_rounded, color: AppColors.orange, size: 18),
            SizedBox(width: 8),
            Text('Snooze 5 menit'),
          ],
        ),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) context.go('/alarm');
    });
  }

  void _dismissAlarm() {
    _audioService.stopAlarmSound();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.alarm_off_rounded, color: AppColors.green, size: 18),
            SizedBox(width: 8),
            Text('Alarm dimatikan'),
          ],
        ),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) context.go('/alarm');
    });
  }

  void _simulateScanWrong() {
    setState(() => _showError = true);
    _shakeError.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showError = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final alarm = _alarm;
    final timeText = alarm != null
        ? '${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Red glow background pulse
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bellShake,
                builder: (_, __) => Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.3),
                      radius: 1.0,
                      colors: [
                        AppColors.red.withOpacity(0.18 + 0.08 * _bellShake.value),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                const SizedBox(height: 20),

                // ── ALARM BERBUNYI header ─────────────────────────────
                AnimatedBuilder(
                  animation: _bellShake,
                  builder: (_, __) {
                    final wobble = math.sin(_bellShake.value * math.pi * 2) * 0.05;
                    return Transform.rotate(
                      angle: wobble,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.red.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'ALARM BERBUNYI',
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Time + label
                Text(
                  timeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 58,
                    fontWeight: FontWeight.w700,
                    fontFeatures: [FontFeature.tabularFigures()],
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alarm?.label ?? 'Alarm',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Snooze counter ────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Snooze $_snoozeCount/$_maxSnooze',
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Challenge content ─────────────────────────────────
                _buildChallenge(),

                const Spacer(),

                // ── Action buttons ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    children: [
                      // Snooze 5 mnt
                      Expanded(
                        child: GestureDetector(
                          onTap: _snoozeCount >= _maxSnooze ? null : _snooze,
                          child: Opacity(
                            opacity: _snoozeCount >= _maxSnooze ? 0.4 : 1.0,
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppColors.orange.withOpacity(0.4)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.snooze_rounded,
                                      color: AppColors.orange, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Snooze 5 mnt',
                                    style: TextStyle(
                                      color: AppColors.orange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Solve / Scan button
                      Expanded(
                        child: _buildActionButton(),
                      ),
                    ],
                  ),
                ),
                // Debug wrong answer button
                if (alarm != null && alarm.challengeType != ChallengeType.none)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextButton.icon(
                      onPressed: _simulateScanWrong,
                      icon: const Icon(Icons.close, color: AppColors.red, size: 14),
                      label: const Text(
                        'Jawaban Salah',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Challenge content ──────────────────────────────────────────
  Widget _buildChallenge() {
    final alarm = _alarm;
    if (alarm == null) return const SizedBox.shrink();

    switch (alarm.challengeType) {
      case ChallengeType.qrScan:
        return _buildQRChallenge();
      case ChallengeType.math:
        return _buildMathChallenge();
      case ChallengeType.wordArrange:
        return _buildWordChallenge();
      case ChallengeType.riddle:
        return _buildRiddleChallenge();
      case ChallengeType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildQRChallenge() {
    if (kIsWeb) {
      return _buildWebQRFallback();
    }
    return _buildMobileQRScanner();
  }

  Widget _buildMobileQRScanner() {
    final secret = _alarm?.qrSecret ?? '';
    return Column(
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _showError ? AppColors.red : AppColors.primary,
              width: 2,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: MobileScanner(
            onDetect: (capture) {
              final code = capture.barcodes.firstOrNull?.rawValue ?? '';
              if (code.isEmpty || secret.isEmpty) return;
              if (code == secret) {
                _dismissAlarm();
              } else {
                _simulateScanWrong();
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _showError
              ? 'QR Code salah, coba lagi'
              : 'Arahkan kamera ke QR Code di laptopmu',
          style: TextStyle(
            color: _showError ? AppColors.red : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWebQRFallback() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _shakeError,
          builder: (_, child) {
            final shake = _showError
                ? math.sin(_shakeError.value * math.pi * 6) * 8
                : 0.0;
            return Transform.translate(
              offset: Offset(shake, 0),
              child: child,
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _showError ? AppColors.red : AppColors.border,
                width: _showError ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                ..._buildCorners(),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: _showError ? AppColors.red : AppColors.primary,
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'QR Scanner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hanya di perangkat mobile',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 200,
          child: TextField(
            controller: _answerController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Masukkan kode rahasia',
              hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        if (_showError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Kode salah, coba lagi',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMathChallenge() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _showError ? AppColors.red : AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.calculate_outlined,
                color: AppColors.orange, size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'Math Challenge',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$_mathA + $_mathB = ?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _answerController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Jawaban',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordChallenge() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _showError ? AppColors.red : AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF30D5C8).withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.text_fields_rounded,
                color: Color(0xFF30D5C8), size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'Word Arrange',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._wordScramble.map((w) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                w.split('').join(' - ').toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          )),
          const SizedBox(height: 14),
          TextField(
            controller: _answerController,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Kata yang benar',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiddleChallenge() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _showError ? AppColors.red : AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF9B59B6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.extension_outlined,
                color: Color(0xFF9B59B6), size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'Riddle',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Aku punya tuts tapi bukan piano,\n'
              'bisa dibuka tapi bukan pintu.\n'
              'Apakah aku?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _answerController,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Jawaban',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Action button ──────────────────────────────────────────────
  Widget _buildActionButton() {
    final alarm = _alarm;
    if (alarm == null || alarm.challengeType == ChallengeType.none) {
      // No challenge → just dismiss
      return GestureDetector(
        onTap: _dismissAlarm,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.alarm_off_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'Matikan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final (icon, label) = switch (alarm.challengeType) {
      ChallengeType.qrScan => kIsWeb
          ? (Icons.check_rounded, 'Cek Kode')
          : (Icons.qr_code_scanner_rounded, 'Scan QR'),
      ChallengeType.math => (Icons.check_rounded, 'Jawab'),
      ChallengeType.wordArrange => (Icons.check_rounded, 'Cek'),
      ChallengeType.riddle => (Icons.check_rounded, 'Jawab'),
      _ => (Icons.alarm_off_rounded, 'Matikan'),
    };

    return GestureDetector(
      onTap: _solveChallenge,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _solveChallenge() {
    final alarm = _alarm;
    if (alarm == null) return;

    switch (alarm.challengeType) {
      case ChallengeType.qrScan:
        if (kIsWeb) {
          final answer = _answerController.text.trim();
          if (answer == alarm.qrSecret) {
            _dismissAlarm();
          } else {
            _simulateScanWrong();
          }
        }
        return;
      case ChallengeType.math:
        final answer = int.tryParse(_answerController.text.trim());
        if (answer == _mathAnswer) {
          _dismissAlarm();
        } else {
          _simulateScanWrong();
        }
        break;
      case ChallengeType.wordArrange:
        final answer = _answerController.text.trim().toLowerCase();
        if (_wordScramble.any((w) => w.toLowerCase() == answer)) {
          _dismissAlarm();
        } else {
          _simulateScanWrong();
        }
        break;
      case ChallengeType.riddle:
        final answer = _answerController.text.trim().toLowerCase();
        if (answer == _riddleAnswer) {
          _dismissAlarm();
        } else {
          _simulateScanWrong();
        }
        break;
      case ChallengeType.none:
        _dismissAlarm();
        break;
    }
  }

  // Build the 4 corner brackets of the QR viewfinder
  List<Widget> _buildCorners() {
    const corner = 20.0;
    final color = _showError ? AppColors.red : AppColors.primary;
    Widget bracket({
      required bool top,
      required bool left,
    }) {
      return Positioned(
        top: top ? 12 : null,
        bottom: top ? null : 12,
        left: left ? 12 : null,
        right: left ? null : 12,
        child: SizedBox(
          width: corner,
          height: corner,
          child: CustomPaint(
            painter: _CornerBracketPainter(
              color: color,
              top: top,
              left: left,
            ),
          ),
        ),
      );
    }

    return [
      bracket(top: true, left: true),
      bracket(top: true, left: false),
      bracket(top: false, left: true),
      bracket(top: false, left: false),
    ];
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final bool top;
  final bool left;
  _CornerBracketPainter({
    required this.color,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Draw two lines forming an L bracket
    if (top && left) {
      canvas.drawLine(const Offset(0, 0), Offset(w, 0), paint);
      canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
    } else if (top && !left) {
      canvas.drawLine(const Offset(0, 0), Offset(w, 0), paint);
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
    } else if (!top && left) {
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
      canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
    } else {
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
    }
  }

  @override
  bool shouldRepaint(_CornerBracketPainter old) => old.color != color;
}
