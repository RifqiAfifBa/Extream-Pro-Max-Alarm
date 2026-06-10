import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// =============================================================================
// LOADING INDICATORS
// Centralized loaders so every screen has a consistent feel.
//
// - XAlarmLoader: 3-dot bounce animation (same as splash screen)
// - PageLoader: wraps page content, shows the loader briefly on first build,
//   then fades into the actual content. Triggers on every fresh navigation.
// =============================================================================

class XAlarmLoader extends StatefulWidget {
  final String? text;
  final Color? color;
  final double dotSize;
  final double spacing;

  const XAlarmLoader({
    super.key,
    this.text,
    this.color,
    this.dotSize = 7,
    this.spacing = 3,
  });

  @override
  State<XAlarmLoader> createState() => _XAlarmLoaderState();
}

class _XAlarmLoaderState extends State<XAlarmLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                // Stagger each dot's animation by ~1/3 of the cycle
                final phase = (_ctrl.value - i * 0.15) % 1.0;
                final brightness = phase < 0.5
                    ? 0.3 + 0.7 * (phase * 2)
                    : 0.3 + 0.7 * (1 - (phase - 0.5) * 2);
                final size = widget.dotSize + 2.0 * brightness.clamp(0.0, 1.0);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.spacing),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: color.withOpacity(brightness.clamp(0.3, 1.0)),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            );
          },
        ),
        if (widget.text != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.text!,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PageLoader — wraps screen body to show a brief loader on first build, then
// fades into the child content. Triggers on every fresh navigation
// (re-entering tab with kept state will NOT re-show because the State persists).
// ─────────────────────────────────────────────────────────────────────────────

class PageLoader extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final String? loadingText;

  const PageLoader({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 450),
    this.loadingText,
  });

  @override
  State<PageLoader> createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader>
    with SingleTickerProviderStateMixin {
  bool _loaded = false;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _loaded = true);
        _fadeCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Container(
        color: AppColors.background,
        alignment: Alignment.center,
        child: XAlarmLoader(text: widget.loadingText ?? 'Memuat...'),
      );
    }
    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
      child: widget.child,
    );
  }
}
