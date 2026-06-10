import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/alarm_providers.dart';

class ChooseChallengeScreen extends ConsumerStatefulWidget {
  const ChooseChallengeScreen({super.key});

  @override
  ConsumerState<ChooseChallengeScreen> createState() =>
      _ChooseChallengeScreenState();
}

class _ChooseChallengeScreenState
    extends ConsumerState<ChooseChallengeScreen> {
  int _selected = 0;

  final _challenges = [
    const _ChallengeData(
      title: 'QR Scan',
      description: 'Scan QR code sent to your email',
      icon: Icons.qr_code_scanner_rounded,
      color: Color(0xFF5B5FEF),
      difficulty: 'EXTREME',
      difficultyColor: Color(0xFFFF3B30),
    ),
    const _ChallengeData(
      title: 'Math Challenge',
      description: 'Solve equations to dismiss',
      icon: Icons.calculate_outlined,
      color: Color(0xFFFF9500),
      difficulty: 'HARD',
      difficultyColor: Color(0xFFFF9500),
    ),
    const _ChallengeData(
      title: 'Word Arrange',
      description: 'Rearrange words into correct sentence',
      icon: Icons.text_fields_rounded,
      color: Color(0xFF30D5C8),
      difficulty: 'MEDIUM',
      difficultyColor: Color(0xFF30D5C8),
    ),
    const _ChallengeData(
      title: 'Riddle',
      description: 'Solve a riddle to stop the alarm',
      icon: Icons.extension_outlined,
      color: Color(0xFF9B59B6),
      difficulty: 'HARD',
      difficultyColor: Color(0xFFFF9500),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = ref.read(selectedChallengeProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: const Text('Choose Challenge'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select how you'll prove you're awake",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'The harder the challenge, the more extreme!',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Challenge list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _challenges.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final c = _challenges[i];
                final isSelected = _selected == i;
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + i * 80),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) => Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value.clamp(0, 1), child: child),
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: c.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child:
                                Icon(c.icon, color: c.color, size: 26),
                          ),
                          const SizedBox(width: 14),

                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  c.description,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Difficulty badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color:
                                        c.difficultyColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    c.difficulty,
                                    style: TextStyle(
                                      color: c.difficultyColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Radio indicator
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 14)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Info text
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.primary, size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'QR codes are generated and sent to your email by the developer. Make sure your email is verified.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: GestureDetector(
              onTap: () {
                ref
                    .read(selectedChallengeProvider.notifier)
                    .state = _selected;
                context.pop();
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Confirm Challenge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String difficulty;
  final Color difficultyColor;

  const _ChallengeData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.difficultyColor,
  });
}
