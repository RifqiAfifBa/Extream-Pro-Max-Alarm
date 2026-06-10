import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/translations.dart';
import '../../providers/preferences_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    // Navigate after 2.4 seconds — to onboarding if first launch, else login
    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      final isFirstLaunch = ref.read(preferencesProvider).isFirstLaunch;
      context.go(isFirstLaunch ? '/onboarding' : '/login');
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(preferencesProvider.select((p) => p.language));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Subtle radial gradient backdrop
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.background,
                  ],
                ),
              ),
            ),
            // Center content
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing bell icon
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (context, _) {
                        final t = _pulseCtrl.value;
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary
                                    .withOpacity(0.4 + 0.3 * t),
                                blurRadius: 30 + 20 * t,
                                spreadRadius: 2 + 6 * t,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.white,
                            size: 56,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'XAlarm',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 36, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr('splash.tagline', lang),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Loading indicator at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Column(
                children: [
                  const _LoadingDots(),
                  const SizedBox(height: 12),
                  Text(
                    tr('splash.loading', lang),
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: AppColors.textTertiary.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated loading dots (3 bouncing dots) ────────────────────────
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
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
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            // Stagger each dot's animation by 1/3 of the cycle
            final phase = (_ctrl.value - i * 0.15) % 1.0;
            // Each dot fades from 0.3 -> 1.0 -> 0.3 over the first half
            final brightness = phase < 0.5
                ? 0.3 + 0.7 * (phase * 2)
                : 0.3 + 0.7 * (1 - (phase - 0.5) * 2);
            final size = 6.0 + 2.0 * brightness.clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color:
                      AppColors.primary.withOpacity(brightness.clamp(0.3, 1.0)),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
