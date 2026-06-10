import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_theme.dart';

import '../../widgets/loading_indicators.dart';
// =============================================================================
// TIMER SCREEN — Figma-matching design
// Contains two views (Timer & Stopwatch) switched via a tab at the top.
// Figma doesn't show navigation between them; tab is a pragmatic choice.
// =============================================================================
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Menyiapkan timer...',
          child: Column(
          children: [
            // ── Title ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  final isTimer = _tabController.index == 0;
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTimer ? 'Timer' : 'Stopwatch',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontSize: 24),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isTimer ? 'Set countdown' : 'Track elapsed time',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isTimer
                              ? Icons.hourglass_top_rounded
                              : Icons.timer_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ── Tab bar (segmented control) ───────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(height: 36, text: 'Timer'),
                    Tab(height: 36, text: 'Stopwatch'),
                  ],
                ),
              ),
            ),

            // ── Body ──────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: const [
                  _TimerView(),
                  _StopwatchView(),
                ],
              ),
            ),
          ],
        ),
      
        ),
      ),
    );
  }
}

// =============================================================================
// TIMER VIEW — big gradient circle, presets, pickers, controls
// =============================================================================
class _TimerView extends StatefulWidget {
  const _TimerView();

  @override
  State<_TimerView> createState() => _TimerViewState();
}

enum _TimerStatus { idle, running, paused }

class _TimerViewState extends State<_TimerView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // Picker values
  int _pickedHours = 0;
  int _pickedMinutes = 25; // default to 25 min like Figma
  int _pickedSeconds = 0;

  int _totalSeconds = 0;
  int _remainingMs = 0;
  Timer? _ticker;
  _TimerStatus _status = _TimerStatus.idle;

  // Animation controller for the spinning glow when running
  late AnimationController _glowCtrl;

  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minCtrl;
  late FixedExtentScrollController _secCtrl;

  // Quick presets (in minutes)
  static const List<int> _presets = [5, 10, 25, 60];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _hourCtrl = FixedExtentScrollController(initialItem: _pickedHours);
    _minCtrl = FixedExtentScrollController(initialItem: _pickedMinutes);
    _secCtrl = FixedExtentScrollController(initialItem: _pickedSeconds);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _hourCtrl.dispose();
    _minCtrl.dispose();
    _secCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(int minutes) {
    setState(() {
      _pickedHours = minutes ~/ 60;
      _pickedMinutes = minutes % 60;
      _pickedSeconds = 0;
    });
    _hourCtrl.animateToItem(_pickedHours,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    _minCtrl.animateToItem(_pickedMinutes,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    _secCtrl.animateToItem(_pickedSeconds,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  void _start() {
    final total = _pickedHours * 3600 + _pickedMinutes * 60 + _pickedSeconds;
    if (total <= 0) return;
    setState(() {
      _totalSeconds = total;
      _remainingMs = total * 1000;
      _status = _TimerStatus.running;
    });
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_remainingMs <= 50) {
        _ticker?.cancel();
        setState(() {
          _remainingMs = 0;
          _status = _TimerStatus.idle;
        });
        _onFinish();
      } else {
        setState(() => _remainingMs -= 50);
      }
    });
  }

  void _pause() {
    _ticker?.cancel();
    setState(() => _status = _TimerStatus.paused);
  }

  void _resume() {
    setState(() => _status = _TimerStatus.running);
    _startTicker();
  }

  void _reset() {
    _ticker?.cancel();
    setState(() {
      _status = _TimerStatus.idle;
      _remainingMs = 0;
      _totalSeconds = 0;
    });
  }

  void _addOneMinute() {
    if (_status == _TimerStatus.idle) return;
    setState(() {
      _remainingMs += 60 * 1000;
      _totalSeconds += 60;
    });
  }

  void _onFinish() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: AppColors.green, size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              "Time's Up!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Your timer has finished.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // --- Formatting helpers ----------------------------------------------------
  String _formatBig() {
    if (_status == _TimerStatus.idle) {
      final h = _pickedHours;
      final m = _pickedMinutes;
      final s = _pickedSeconds;
      if (h > 0) return '${_pad(h)}:${_pad(m)}:${_pad(s)}';
      return '${_pad(m)}:${_pad(s)}';
    }
    final secs = (_remainingMs / 1000).ceil();
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    final s = secs % 60;
    if (h > 0) return '${_pad(h)}:${_pad(m)}:${_pad(s)}';
    return '${_pad(m)}:${_pad(s)}';
  }

  String _pad(int v) => v.toString().padLeft(2, '0');

  double get _progress {
    if (_status == _TimerStatus.idle || _totalSeconds == 0) return 0;
    return _remainingMs / (_totalSeconds * 1000);
  }

  String get _statusLabel {
    switch (_status) {
      case _TimerStatus.idle:
        return 'SIAP';
      case _TimerStatus.running:
        return 'ACTIVE';
      case _TimerStatus.paused:
        return 'DIJEDA';
    }
  }

  Color get _statusColor {
    switch (_status) {
      case _TimerStatus.idle:
        return AppColors.textSecondary;
      case _TimerStatus.running:
        return AppColors.green;
      case _TimerStatus.paused:
        return AppColors.orange;
    }
  }

  // --- Build -----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isIdle = _status == _TimerStatus.idle;
    final isRunning = _status == _TimerStatus.running;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          // ── Big gradient circular progress with time inside ──────────
          SizedBox(
            width: 260,
            height: 260,
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (context, child) {
                return CustomPaint(
                  painter: _TimerCirclePainter(
                    progress: isIdle ? 1.0 : _progress,
                    rotation: isRunning ? _glowCtrl.value * 2 * math.pi : 0,
                    dimmed: isIdle,
                  ),
                  child: child,
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatBig(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        fontFeatures: [FontFeature.tabularFigures()],
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isIdle ? 'set time below' : 'remaining',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: _statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _statusLabel,
                            style: TextStyle(
                              color: _statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Quick presets (only visible when idle) ────────────────────
          if (isIdle)
            SizedBox(
              height: 36,
              child: Row(
                children: _presets.map((m) {
                  final isSelected =
                      (_pickedHours * 60 + _pickedMinutes) == m &&
                          _pickedSeconds == 0;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => _applyPreset(m),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected ? AppColors.primaryGradient : null,
                            color: isSelected ? null : AppColors.card,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppColors.border,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$m min',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          if (isIdle) const SizedBox(height: 18),

          // ── Small pickers (only visible when idle) ────────────────────
          if (isIdle)
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _picker(
                    controller: _hourCtrl,
                    value: _pickedHours,
                    label: 'HRS',
                    length: 24,
                    onChanged: (v) => setState(() => _pickedHours = v),
                  ),
                  _separator(),
                  _picker(
                    controller: _minCtrl,
                    value: _pickedMinutes,
                    label: 'MIN',
                    length: 60,
                    onChanged: (v) => setState(() => _pickedMinutes = v),
                  ),
                  _separator(),
                  _picker(
                    controller: _secCtrl,
                    value: _pickedSeconds,
                    label: 'SEC',
                    length: 60,
                    onChanged: (v) => setState(() => _pickedSeconds = v),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // ── Controls: Reset | Play/Pause | +1 min ─────────────────────
          _buildControls(),

          const SizedBox(height: 28),

          // ── Active Timers section (multi-timer concurrent) ────────────
          const _ActiveTimersSection(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _picker({
    required FixedExtentScrollController controller,
    required int value,
    required String label,
    required int length,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          height: 90,
          child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 30,
            magnification: 1.2,
            squeeze: 1.1,
            useMagnifier: true,
            backgroundColor: Colors.transparent,
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
              background: Color(0x1A5B5FEF),
            ),
            onSelectedItemChanged: onChanged,
            children: List.generate(
              length,
              (i) => Center(
                child: Text(
                  i.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color:
                        i == value ? Colors.white : AppColors.textSecondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _separator() {
    return const Padding(
      padding: EdgeInsets.only(top: 14, left: 2, right: 2),
      child: Text(
        ':',
        style: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildControls() {
    final isIdle = _status == _TimerStatus.idle;
    final isRunning = _status == _TimerStatus.running;
    final canStart = _pickedHours + _pickedMinutes + _pickedSeconds > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reset (small)
        _SideButton(
          icon: Icons.refresh_rounded,
          label: 'Reset',
          enabled: !isIdle,
          onTap: _reset,
        ),

        // Center play/pause (big)
        GestureDetector(
          onTap: isIdle
              ? (canStart ? _start : null)
              : (isRunning ? _pause : _resume),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              gradient: (isIdle && !canStart)
                  ? null
                  : (isRunning
                      ? const LinearGradient(
                          colors: [AppColors.orange, Color(0xFFE07B00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : AppColors.primaryGradient),
              color: (isIdle && !canStart) ? AppColors.surface : null,
              shape: BoxShape.circle,
              boxShadow: (isIdle && !canStart)
                  ? null
                  : [
                      BoxShadow(
                        color:
                            (isRunning ? AppColors.orange : AppColors.primary)
                                .withOpacity(0.4),
                        blurRadius: 22,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Icon(
              isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: (isIdle && !canStart)
                  ? AppColors.textTertiary
                  : Colors.white,
              size: 36,
            ),
          ),
        ),

        // +1 min (small)
        _SideButton(
          icon: Icons.add_rounded,
          label: '+1 min',
          enabled: !isIdle,
          onTap: _addOneMinute,
        ),
      ],
    );
  }
}

class _SideButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _SideButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CIRCLE PAINTER — TIMER
// =============================================================================
class _TimerCirclePainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final double rotation; // spinning gradient when running
  final bool dimmed;

  _TimerCirclePainter({
    required this.progress,
    this.rotation = 0,
    this.dimmed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 10.0;
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress <= 0) return;

    // Sweep gradient progress arc — primary -> purple -> pink -> primary
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * math.pi,
      transform: GradientRotation(-math.pi / 2 + rotation),
      colors: dimmed
          ? [
              AppColors.surface,
              AppColors.surface.withOpacity(0.5),
              AppColors.surface,
            ]
          : const [
              Color(0xFF5B5FEF),
              Color(0xFF9B59B6),
              Color(0xFFEC4899),
              Color(0xFF5B5FEF),
            ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );

    // White dot at the arc tip — "live" indicator
    if (!dimmed && progress < 1.0) {
      final endAngle = -math.pi / 2 + 2 * math.pi * progress;
      final endX = center.dx + radius * math.cos(endAngle);
      final endY = center.dy + radius * math.sin(endAngle);
      canvas.drawCircle(
        Offset(endX, endY),
        strokeWidth / 1.5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_TimerCirclePainter old) =>
      old.progress != progress ||
      old.rotation != rotation ||
      old.dimmed != dimmed;
}

// =============================================================================
// STOPWATCH VIEW — big circle + overlapping play/pause + lap bars
// =============================================================================
class _StopwatchView extends StatefulWidget {
  const _StopwatchView();

  @override
  State<_StopwatchView> createState() => _StopwatchViewState();
}

class _Lap {
  final int number;
  final Duration lapTime;
  final Duration totalTime;
  const _Lap(this.number, this.lapTime, this.totalTime);
}

class _StopwatchViewState extends State<_StopwatchView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final Stopwatch _sw = Stopwatch();
  Timer? _ticker;
  final List<_Lap> _laps = [];
  Duration _lastLapAt = Duration.zero;

  late AnimationController _glowCtrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_sw.isRunning) {
      _sw.stop();
      _ticker?.cancel();
      setState(() {});
    } else {
      _sw.start();
      _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  void _reset() {
    _ticker?.cancel();
    _sw.stop();
    _sw.reset();
    setState(() {
      _laps.clear();
      _lastLapAt = Duration.zero;
    });
  }

  void _lap() {
    final now = _sw.elapsed;
    final lap = now - _lastLapAt;
    setState(() {
      _laps.insert(0, _Lap(_laps.length + 1, lap, now));
      _lastLapAt = now;
    });
  }

  // --- Formatters ------------------------------------------------------------
  String _formatMain(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$m:$s';
    return '00:$m:$s';
  }

  String _formatCentis(Duration d) {
    final cs = (d.inMilliseconds.remainder(1000) / 10).floor();
    return '.${cs.toString().padLeft(2, '0')}';
  }

  String _formatLap(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$m:$s';
    return '00:$m:$s';
  }

  // --- Build -----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final running = _sw.isRunning;
    final elapsed = _sw.elapsed;
    final isZero = elapsed == Duration.zero;

    Duration? maxLap;
    if (_laps.isNotEmpty) {
      maxLap = _laps.map((l) => l.lapTime).reduce((a, b) => a > b ? a : b);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          // ── Big circular display with center play/pause overlap ──────
          SizedBox(
            width: 260,
            height: 280, // extra 20 to fit the overlapping button
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                // Ring painter
                SizedBox(
                  width: 260,
                  height: 260,
                  child: AnimatedBuilder(
                    animation: _glowCtrl,
                    builder: (_, __) => CustomPaint(
                      painter: _StopwatchCirclePainter(
                        rotation: running ? _glowCtrl.value * 2 * math.pi : 0,
                        active: running,
                      ),
                    ),
                  ),
                ),
                // Time + status, vertically centered in the 260x260 ring
                Positioned(
                  top: 0,
                  width: 260,
                  height: 260,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _formatMain(elapsed),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: _formatCentis(elapsed),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (running
                                    ? AppColors.green
                                    : (isZero
                                        ? AppColors.textSecondary
                                        : AppColors.orange))
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: running
                                      ? AppColors.green
                                      : (isZero
                                          ? AppColors.textSecondary
                                          : AppColors.orange),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                running
                                    ? 'BERJALAN'
                                    : (isZero ? 'SIAP' : 'DIJEDA'),
                                style: TextStyle(
                                  color: running
                                      ? AppColors.green
                                      : (isZero
                                          ? AppColors.textSecondary
                                          : AppColors.orange),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Big play/pause button — overlaps bottom of circle
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: _toggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: running
                            ? const LinearGradient(
                                colors: [AppColors.red, Color(0xFFD12B22)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (running ? AppColors.red : AppColors.primary)
                                    .withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        running
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── Lap / Reset row ──────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _bottomBtn(
                  label: 'Lap',
                  icon: Icons.flag_outlined,
                  enabled: running,
                  onTap: _lap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _bottomBtn(
                  label: 'Reset',
                  icon: Icons.refresh_rounded,
                  enabled: !isZero,
                  onTap: _reset,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Lap Times header ─────────────────────────────────────────
          Row(
            children: [
              const Text(
                'Lap Times',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${_laps.length} lap${_laps.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Lap list with horizontal bars ────────────────────────────
          if (_laps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const Icon(Icons.flag_outlined,
                      color: AppColors.textTertiary, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'No laps yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap "Lap" while running to record splits',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          else
            ..._laps.map((lap) {
              final ratio = maxLap == null || maxLap.inMilliseconds == 0
                  ? 0.0
                  : lap.lapTime.inMilliseconds / maxLap.inMilliseconds;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LapRow(
                  lap: lap,
                  ratio: ratio,
                  lapTimeLabel: _formatLap(lap.lapTime),
                  totalTimeLabel: _formatLap(lap.totalTime),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _bottomBtn({
    required String label,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LapRow extends StatelessWidget {
  final _Lap lap;
  final double ratio; // 0.0 - 1.0
  final String lapTimeLabel;
  final String totalTimeLabel;
  const _LapRow({
    required this.lap,
    required this.ratio,
    required this.lapTimeLabel,
    required this.totalTimeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Lap ${lap.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '+$lapTimeLabel',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const Spacer(),
              Text(
                totalTimeLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Horizontal bar showing lap length relative to longest lap
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  color: AppColors.surfaceLight,
                ),
                FractionallySizedBox(
                  widthFactor: ratio.clamp(0.05, 1.0),
                  child: Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CIRCLE PAINTER — STOPWATCH
// =============================================================================
class _StopwatchCirclePainter extends CustomPainter {
  final double rotation;
  final bool active;
  _StopwatchCirclePainter({required this.rotation, required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Active spinning gradient or static dim
    final gradient = SweepGradient(
      transform: GradientRotation(-math.pi / 2 + rotation),
      colors: active
          ? const [
              Color(0xFF5B5FEF),
              Color(0xFF9B59B6),
              Color(0xFFEC4899),
              Color(0xFF5B5FEF),
            ]
          : [
              AppColors.surface,
              AppColors.surfaceLight,
              AppColors.surface,
              AppColors.surface,
            ],
    );

    final ringPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(_StopwatchCirclePainter old) =>
      old.rotation != rotation || old.active != active;
}

// =============================================================================
// ACTIVE TIMERS SECTION — multi-timer concurrent
// Each timer runs in its own ticker. Add/pause/resume/delete independently.
// =============================================================================
class _ActiveTimer {
  final String id;
  String name;
  IconData icon;
  Color color;
  Duration total;
  Duration remaining;
  bool isRunning = false;
  Timer? ticker;
  _ActiveTimer({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.total,
    required this.remaining,
  });

  double get progress =>
      total.inSeconds == 0 ? 0 : 1 - (remaining.inSeconds / total.inSeconds);
  Duration get elapsed => total - remaining;
  bool get isDone => remaining.inSeconds <= 0;
}

class _ActiveTimersSection extends StatefulWidget {
  const _ActiveTimersSection();
  @override
  State<_ActiveTimersSection> createState() => _ActiveTimersSectionState();
}

class _ActiveTimersSectionState extends State<_ActiveTimersSection> {
  final List<_ActiveTimer> _timers = [];

  // Available icon/color presets when creating new timers
  static const _iconPresets = <Map<String, dynamic>>[
    {'icon': Icons.menu_book_rounded, 'color': AppColors.primary},
    {'icon': Icons.coffee_rounded, 'color': AppColors.orange},
    {'icon': Icons.fitness_center_rounded, 'color': AppColors.green},
    {'icon': Icons.self_improvement_rounded, 'color': AppColors.purple},
    {'icon': Icons.restaurant_rounded, 'color': AppColors.red},
    {'icon': Icons.code_rounded, 'color': AppColors.teal},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate with 2 example timers like Figma
    _seed('Study Session', Icons.menu_book_rounded, AppColors.primary,
        const Duration(minutes: 25), elapsedSec: 28, running: true);
    _seed('Break Time', Icons.coffee_rounded, AppColors.orange,
        const Duration(minutes: 10), elapsedSec: 302, running: true);
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.ticker?.cancel();
    }
    super.dispose();
  }

  void _seed(String name, IconData icon, Color color, Duration total,
      {int elapsedSec = 0, bool running = false}) {
    final id = '${DateTime.now().microsecondsSinceEpoch}_$name';
    final remaining = total - Duration(seconds: elapsedSec);
    final t = _ActiveTimer(
      id: id,
      name: name,
      icon: icon,
      color: color,
      total: total,
      remaining: remaining,
    );
    _timers.add(t);
    if (running) _resume(t);
  }

  void _pause(_ActiveTimer t) {
    t.ticker?.cancel();
    t.ticker = null;
    setState(() => t.isRunning = false);
  }

  void _resume(_ActiveTimer t) {
    t.ticker?.cancel();
    t.isRunning = true;
    t.ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (t.remaining.inSeconds <= 1) {
        t.ticker?.cancel();
        t.ticker = null;
        setState(() {
          t.remaining = Duration.zero;
          t.isRunning = false;
        });
      } else {
        setState(() => t.remaining = t.remaining - const Duration(seconds: 1));
      }
    });
    if (mounted) setState(() {});
  }

  void _delete(_ActiveTimer t) {
    t.ticker?.cancel();
    setState(() => _timers.remove(t));
  }

  Future<void> _showAddDialog() async {
    final result = await showModalBottomSheet<_NewTimerData>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const _AddTimerSheet(),
    );
    if (result == null) return;
    final preset = _iconPresets[result.iconIndex];
    final id = '${DateTime.now().microsecondsSinceEpoch}_${result.name}';
    final t = _ActiveTimer(
      id: id,
      name: result.name,
      icon: preset['icon'] as IconData,
      color: preset['color'] as Color,
      total: result.duration,
      remaining: result.duration,
    );
    setState(() => _timers.add(t));
    _resume(t); // auto-start when added
  }

  @override
  Widget build(BuildContext context) {
    final running = _timers.where((t) => t.isRunning).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header row ────────────────────────────────────────────────
        Row(
          children: [
            const Text(
              'Timer Aktif',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            if (_timers.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$running running',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            // Add new timer button
            GestureDetector(
              onTap: _showAddDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Pomodoro card (PINNED — cannot be deleted) ───────────────
        const _PomodoroCard(),
        const SizedBox(height: 10),

        // ── Regular timers list ───────────────────────────────────────
        if (_timers.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.hourglass_empty_rounded,
                      color: AppColors.textTertiary, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada timer tambahan',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap "+ Add" buat bikin timer baru',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else
          ..._timers.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ActiveTimerCard(
                  timer: t,
                  onToggle: () =>
                      t.isRunning ? _pause(t) : (t.isDone ? null : _resume(t)),
                  onDelete: () => _delete(t),
                ),
              )),
      ],
    );
  }
}

// ── Single timer card ─────────────────────────────────────────────────
class _ActiveTimerCard extends StatelessWidget {
  final _ActiveTimer timer;
  final VoidCallback? onToggle;
  final VoidCallback onDelete;
  const _ActiveTimerCard({
    required this.timer,
    required this.onToggle,
    required this.onDelete,
  });

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$m:$s';
    return '$m:$s';
  }

  String _elapsedLabel(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')} elapsed';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon badge
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: timer.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(timer.icon, color: timer.color, size: 18),
              ),
              const SizedBox(width: 10),
              // Name + total
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timer.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${timer.total.inMinutes} min total',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Big remaining time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _format(timer.remaining),
                    style: TextStyle(
                      color: timer.isDone
                          ? AppColors.green
                          : (timer.isRunning
                              ? Colors.white
                              : AppColors.textSecondary),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timer.isDone ? 'Selesai' : _elapsedLabel(timer.elapsed),
                    style: TextStyle(
                      color: timer.isDone
                          ? AppColors.green
                          : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(
                  height: 5,
                  width: double.infinity,
                  color: AppColors.surfaceLight,
                ),
                FractionallySizedBox(
                  widthFactor: timer.progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: timer.isDone ? AppColors.green : timer.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Inline controls
          Row(
            children: [
              Text(
                '${(timer.progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: timer.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // Toggle play/pause
              GestureDetector(
                onTap: onToggle,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: timer.isDone
                        ? AppColors.surface
                        : (timer.isRunning
                            ? AppColors.orange.withOpacity(0.15)
                            : AppColors.primary.withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        timer.isDone
                            ? Icons.check_rounded
                            : (timer.isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded),
                        color: timer.isDone
                            ? AppColors.green
                            : (timer.isRunning
                                ? AppColors.orange
                                : AppColors.primary),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timer.isDone
                            ? 'Done'
                            : (timer.isRunning ? 'Pause' : 'Resume'),
                        style: TextStyle(
                          color: timer.isDone
                              ? AppColors.green
                              : (timer.isRunning
                                  ? AppColors.orange
                                  : AppColors.primary),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Add timer modal bottom sheet ─────────────────────────────────────
class _NewTimerData {
  final String name;
  final Duration duration;
  final int iconIndex;
  _NewTimerData(this.name, this.duration, this.iconIndex);
}

class _AddTimerSheet extends StatefulWidget {
  const _AddTimerSheet();
  @override
  State<_AddTimerSheet> createState() => _AddTimerSheetState();
}

class _AddTimerSheetState extends State<_AddTimerSheet> {
  final _nameCtrl = TextEditingController(text: 'Timer baru');
  int _minutes = 15;
  int _iconIndex = 0;

  static const _icons = [
    {'icon': Icons.menu_book_rounded, 'color': AppColors.primary},
    {'icon': Icons.coffee_rounded, 'color': AppColors.orange},
    {'icon': Icons.fitness_center_rounded, 'color': AppColors.green},
    {'icon': Icons.self_improvement_rounded, 'color': AppColors.purple},
    {'icon': Icons.restaurant_rounded, 'color': AppColors.red},
    {'icon': Icons.code_rounded, 'color': AppColors.teal},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_minutes <= 0) return;
    Navigator.of(context).pop(_NewTimerData(
      _nameCtrl.text.trim().isEmpty ? 'Timer baru' : _nameCtrl.text.trim(),
      Duration(minutes: _minutes),
      _iconIndex,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Tambah Timer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Timer baru akan langsung berjalan',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 18),

          // Name field
          const Text(
            'NAMA',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Misal: Belajar Matematika',
                hintStyle:
                    TextStyle(color: AppColors.textTertiary, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Duration
          const Text(
            'DURASI (MENIT)',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _DurChip(label: '5', selected: _minutes == 5, onTap: () => setState(() => _minutes = 5)),
              _DurChip(label: '10', selected: _minutes == 10, onTap: () => setState(() => _minutes = 10)),
              _DurChip(label: '15', selected: _minutes == 15, onTap: () => setState(() => _minutes = 15)),
              _DurChip(label: '25', selected: _minutes == 25, onTap: () => setState(() => _minutes = 25)),
              _DurChip(label: '45', selected: _minutes == 45, onTap: () => setState(() => _minutes = 45)),
              _DurChip(label: '60', selected: _minutes == 60, onTap: () => setState(() => _minutes = 60)),
            ],
          ),

          const SizedBox(height: 16),

          // Icon picker
          const Text(
            'IKON',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(_icons.length, (i) {
              final selected = i == _iconIndex;
              final color = _icons[i]['color'] as Color;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => setState(() => _iconIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      decoration: BoxDecoration(
                        color: selected ? color.withOpacity(0.2) : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected ? color : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _icons[i]['icon'] as IconData,
                        color: selected ? color : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 22),

          // Submit
          GestureDetector(
            onTap: _submit,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Mulai Timer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _DurChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 38,
            decoration: BoxDecoration(
              gradient: selected ? AppColors.primaryGradient : null,
              color: selected ? null : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// POMODORO CARD — pinned, cannot be deleted
//
// Classic Pomodoro Technique:
//   - 4 cycles of (Work 25 min + Short Break 5 min)
//   - After 4th work session: Long Break 15 min
//   - Then start over from cycle 1
//
// Each phase transition shows a snackbar notification. User must manually
// tap Play to start the next phase (no aggressive auto-start so they can
// extend a break if needed).
// =============================================================================
enum _PomodoroPhase { idle, work, shortBreak, longBreak }

class _PomodoroCard extends StatefulWidget {
  const _PomodoroCard();

  @override
  State<_PomodoroCard> createState() => _PomodoroCardState();
}

class _PomodoroCardState extends State<_PomodoroCard>
    with SingleTickerProviderStateMixin {
  // ── Configurable durations ─────────────────────────────────────────
  Duration _workDur = const Duration(minutes: 25);
  Duration _shortBreakDur = const Duration(minutes: 5);
  Duration _longBreakDur = const Duration(minutes: 15);
  static const int _cyclesPerSet = 4;

  // ── Live state ─────────────────────────────────────────────────────
  _PomodoroPhase _phase = _PomodoroPhase.idle;
  int _cycle = 1; // 1..4
  late Duration _remaining;
  bool _isRunning = false;
  Timer? _ticker;

  // ── Glow pulse animation (active state) ────────────────────────────
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _remaining = _workDur;
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Phase metadata ─────────────────────────────────────────────────
  Duration get _currentPhaseDuration {
    switch (_phase) {
      case _PomodoroPhase.idle:
      case _PomodoroPhase.work:
        return _workDur;
      case _PomodoroPhase.shortBreak:
        return _shortBreakDur;
      case _PomodoroPhase.longBreak:
        return _longBreakDur;
    }
  }

  Color get _phaseColor {
    switch (_phase) {
      case _PomodoroPhase.idle:
      case _PomodoroPhase.work:
        return AppColors.red;
      case _PomodoroPhase.shortBreak:
        return AppColors.green;
      case _PomodoroPhase.longBreak:
        return AppColors.teal;
    }
  }

  IconData get _phaseIcon {
    switch (_phase) {
      case _PomodoroPhase.idle:
      case _PomodoroPhase.work:
        return Icons.local_fire_department_rounded;
      case _PomodoroPhase.shortBreak:
        return Icons.coffee_rounded;
      case _PomodoroPhase.longBreak:
        return Icons.spa_rounded;
    }
  }

  String get _phaseLabel {
    switch (_phase) {
      case _PomodoroPhase.idle:
        return 'Siap mulai';
      case _PomodoroPhase.work:
        return 'Fokus';
      case _PomodoroPhase.shortBreak:
        return 'Istirahat';
      case _PomodoroPhase.longBreak:
        return 'Istirahat Panjang';
    }
  }

  double get _progress {
    final total = _currentPhaseDuration.inSeconds;
    if (total == 0) return 0;
    return 1 - (_remaining.inSeconds / total);
  }

  Duration get _elapsed => _currentPhaseDuration - _remaining;

  // ── Actions ────────────────────────────────────────────────────────
  void _toggle() {
    if (_isRunning) {
      _pause();
    } else {
      _start();
    }
  }

  void _start() {
    if (_phase == _PomodoroPhase.idle) {
      // First start of a fresh session → enter work phase
      setState(() {
        _phase = _PomodoroPhase.work;
        _remaining = _workDur;
      });
    }
    _ticker?.cancel();
    setState(() => _isRunning = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        _ticker?.cancel();
        _advancePhase();
      } else {
        setState(() => _remaining = _remaining - const Duration(seconds: 1));
      }
    });
  }

  void _pause() {
    _ticker?.cancel();
    _ticker = null;
    setState(() => _isRunning = false);
  }

  void _reset() {
    _ticker?.cancel();
    _ticker = null;
    setState(() {
      _phase = _PomodoroPhase.idle;
      _cycle = 1;
      _remaining = _workDur;
      _isRunning = false;
    });
  }

  void _skip() {
    _ticker?.cancel();
    _advancePhase();
  }

  void _advancePhase() {
    _PomodoroPhase next;
    int nextCycle = _cycle;
    String message;
    IconData notifIcon;
    Color notifColor;

    if (_phase == _PomodoroPhase.work) {
      if (_cycle >= _cyclesPerSet) {
        next = _PomodoroPhase.longBreak;
        message =
            'Mantap! 4 sesi selesai. Istirahat panjang ${_longBreakDur.inMinutes} menit 🎉';
        notifIcon = Icons.celebration_rounded;
        notifColor = AppColors.teal;
      } else {
        next = _PomodoroPhase.shortBreak;
        message =
            'Fokus selesai. Istirahat ${_shortBreakDur.inMinutes} menit ☕';
        notifIcon = Icons.coffee_rounded;
        notifColor = AppColors.green;
      }
    } else if (_phase == _PomodoroPhase.shortBreak) {
      next = _PomodoroPhase.work;
      nextCycle = _cycle + 1;
      message = 'Lanjut fokus sesi ke-$nextCycle 🔥';
      notifIcon = Icons.local_fire_department_rounded;
      notifColor = AppColors.red;
    } else {
      // long break ended → start a fresh set
      next = _PomodoroPhase.work;
      nextCycle = 1;
      message = 'Set baru dimulai. Semangat! 💪';
      notifIcon = Icons.refresh_rounded;
      notifColor = AppColors.primary;
    }

    final newPhaseDur = (next == _PomodoroPhase.work)
        ? _workDur
        : (next == _PomodoroPhase.shortBreak ? _shortBreakDur : _longBreakDur);

    setState(() {
      _phase = next;
      _cycle = nextCycle;
      _remaining = newPhaseDur;
      _isRunning = false;
    });

    // Show notification
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(notifIcon, color: notifColor, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.surface,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _showSettings() async {
    final result = await showModalBottomSheet<_PomodoroSettings>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _PomodoroSettingsSheet(
        workMin: _workDur.inMinutes,
        shortMin: _shortBreakDur.inMinutes,
        longMin: _longBreakDur.inMinutes,
      ),
    );
    if (result == null) return;
    setState(() {
      _workDur = Duration(minutes: result.workMin);
      _shortBreakDur = Duration(minutes: result.shortMin);
      _longBreakDur = Duration(minutes: result.longMin);
      // Apply new duration only if currently idle (don't disrupt running phase)
      if (_phase == _PomodoroPhase.idle) {
        _remaining = _workDur;
      }
    });
  }

  // ── Formatters ─────────────────────────────────────────────────────
  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _elapsedLabel(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s berlalu';
  }

  // ── Build ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        // Glow intensity pulses while running
        final glow = _isRunning ? (0.15 + 0.15 * _pulseCtrl.value) : 0.0;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            // Subtle gradient using the phase color for visual distinction
            gradient: LinearGradient(
              colors: [
                _phaseColor.withOpacity(0.12),
                AppColors.card,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _phaseColor.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: _isRunning
                ? [
                    BoxShadow(
                      color: _phaseColor.withOpacity(glow),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: icon, name, PATEN badge, time ─────────────────
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _phaseColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_phaseIcon, color: _phaseColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Pomodoro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.push_pin_rounded,
                                  color: AppColors.primary, size: 9),
                              SizedBox(width: 3),
                              Text(
                                'PATEN',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_phaseLabel · Sesi $_cycle/$_cyclesPerSet',
                      style: TextStyle(
                        color: _phaseColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _format(_remaining),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _phase == _PomodoroPhase.idle
                        ? '${_workDur.inMinutes} min total'
                        : _elapsedLabel(_elapsed),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Progress bar ───────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(
                  height: 5,
                  width: double.infinity,
                  color: AppColors.surfaceLight,
                ),
                FractionallySizedBox(
                  widthFactor: _progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 5,
                    color: _phaseColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Bottom row: cycle dots + controls ──────────────────────
          Row(
            children: [
              // Cycle dots
              Row(
                children: List.generate(_cyclesPerSet, (i) {
                  final cycleNum = i + 1;
                  final isCompleted = cycleNum < _cycle;
                  final isCurrent = cycleNum == _cycle &&
                      _phase != _PomodoroPhase.idle;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: isCurrent ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? _phaseColor
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '${(_progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _phaseColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),

              // Play / Pause
              GestureDetector(
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: _isRunning
                        ? null
                        : LinearGradient(
                            colors: [
                              _phaseColor,
                              _phaseColor.withOpacity(0.7),
                            ],
                          ),
                    color: _isRunning ? _phaseColor.withOpacity(0.2) : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: _isRunning ? _phaseColor : Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isRunning
                            ? 'Pause'
                            : (_phase == _PomodoroPhase.idle
                                ? 'Mulai'
                                : 'Lanjut'),
                        style: TextStyle(
                          color: _isRunning ? _phaseColor : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Skip (only enabled if not idle)
              GestureDetector(
                onTap: _phase == _PomodoroPhase.idle ? null : _skip,
                behavior: HitTestBehavior.opaque,
                child: Opacity(
                  opacity: _phase == _PomodoroPhase.idle ? 0.4 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.skip_next_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Reset (only if not idle)
              GestureDetector(
                onTap: _phase == _PomodoroPhase.idle ? null : _reset,
                behavior: HitTestBehavior.opaque,
                child: Opacity(
                  opacity: _phase == _PomodoroPhase.idle ? 0.4 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Settings
              GestureDetector(
                onTap: _showSettings,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pomodoro settings bottom sheet ──────────────────────────────────
class _PomodoroSettings {
  final int workMin;
  final int shortMin;
  final int longMin;
  _PomodoroSettings(this.workMin, this.shortMin, this.longMin);
}

class _PomodoroSettingsSheet extends StatefulWidget {
  final int workMin;
  final int shortMin;
  final int longMin;
  const _PomodoroSettingsSheet({
    required this.workMin,
    required this.shortMin,
    required this.longMin,
  });

  @override
  State<_PomodoroSettingsSheet> createState() => _PomodoroSettingsSheetState();
}

class _PomodoroSettingsSheetState extends State<_PomodoroSettingsSheet> {
  late int _work;
  late int _short;
  late int _long;

  @override
  void initState() {
    super.initState();
    _work = widget.workMin;
    _short = widget.shortMin;
    _long = widget.longMin;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_fire_department_rounded,
                    color: AppColors.red, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setting Pomodoro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Atur durasi tiap fase',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          _DurRow(
            label: 'Fokus',
            icon: Icons.local_fire_department_rounded,
            color: AppColors.red,
            value: _work,
            min: 15,
            max: 60,
            step: 5,
            unit: 'menit',
            onChanged: (v) => setState(() => _work = v),
          ),
          const SizedBox(height: 14),
          _DurRow(
            label: 'Istirahat Pendek',
            icon: Icons.coffee_rounded,
            color: AppColors.green,
            value: _short,
            min: 3,
            max: 15,
            step: 1,
            unit: 'menit',
            onChanged: (v) => setState(() => _short = v),
          ),
          const SizedBox(height: 14),
          _DurRow(
            label: 'Istirahat Panjang',
            icon: Icons.spa_rounded,
            color: AppColors.teal,
            value: _long,
            min: 10,
            max: 30,
            step: 5,
            unit: 'menit',
            onChanged: (v) => setState(() => _long = v),
          ),

          const SizedBox(height: 22),

          // Info: 4 cycles
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppColors.textSecondary, size: 14),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tiap set = 4 sesi fokus + 3 istirahat pendek + 1 istirahat panjang.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          GestureDetector(
            onTap: () => Navigator.pop(
                context, _PomodoroSettings(_work, _short, _long)),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int value;
  final int min;
  final int max;
  final int step;
  final String unit;
  final ValueChanged<int> onChanged;
  const _DurRow({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$value $unit',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Minus
          GestureDetector(
            onTap: value > min ? () => onChanged(value - step) : null,
            child: Opacity(
              opacity: value > min ? 1.0 : 0.3,
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.remove_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          GestureDetector(
            onTap: value < max ? () => onChanged(value + step) : null,
            child: Opacity(
              opacity: value < max ? 1.0 : 0.3,
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
