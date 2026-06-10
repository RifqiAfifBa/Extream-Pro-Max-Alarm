import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/translations.dart';
import '../../providers/preferences_provider.dart';

// =============================================================================
// ONBOARDING SCREEN — shown on first launch
// 4 slides explaining the app's unique value props
// =============================================================================

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  List<_SlideData> _getSlides(AppLanguage lang) => [
    _SlideData(
      icon: Icons.notifications_active_rounded,
      iconColor: AppColors.primary,
      title: tr('onb.slide1.title', lang),
      description: tr('onb.slide1.desc', lang),
      badge: tr('splash.tagline', lang),
    ),
    _SlideData(
      icon: Icons.quiz_rounded,
      iconColor: AppColors.purple,
      title: tr('onb.slide2.title', lang),
      description: tr('onb.slide2.desc', lang),
      badge: tr('onb.slide2.badge', lang),
    ),
    _SlideData(
      icon: Icons.shield_rounded,
      iconColor: AppColors.green,
      title: tr('onb.slide3.title', lang),
      description: tr('onb.slide3.desc', lang),
      badge: 'NO CHEATING',
    ),
    _SlideData(
      icon: Icons.analytics_rounded,
      iconColor: AppColors.orange,
      title: tr('onb.slide4.title', lang),
      description: tr('onb.slide4.desc', lang),
      badge: tr('onb.slide4.badge', lang),
    ),
  ];

  void _next() {
    if (_page < _getSlides(ref.read(preferencesProvider).language).length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  void _finish() {
    ref.read(preferencesProvider.notifier).completeOnboarding();
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(preferencesProvider.select((p) => p.language));
    final slides = _getSlides(lang);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar — skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  // Step counter
                  Text(
                    '${_page + 1}/${slides.length}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (_page < slides.length - 1)
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        tr('common.skip', lang),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PageView slides
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: slides.length,
                itemBuilder: (_, i) => _OnboardingSlide(data: slides[i]),
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (i) {
                final isActive = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // CTA button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: GestureDetector(
                onTap: _next,
                child: Container(
                  height: 56,
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
                      Text(
                        _page < slides.length - 1
                            ? tr('onb.next', lang)
                            : tr('onb.start_now', lang),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _page < slides.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String badge;
  const _SlideData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.badge,
  });
}

class _OnboardingSlide extends StatelessWidget {
  final _SlideData data;
  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing icon hero
          Container(
            width: 180, height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.iconColor.withOpacity(0.25),
                  data.iconColor.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.iconColor.withOpacity(0.18),
                  border: Border.all(
                    color: data.iconColor.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: data.iconColor.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(data.icon, color: data.iconColor, size: 44),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: data.iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.badge,
              style: TextStyle(
                color: data.iconColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 14),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
