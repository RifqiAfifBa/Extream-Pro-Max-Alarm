import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/translations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/preferences_provider.dart';

import '../../widgets/loading_indicators.dart';
class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(preferencesProvider.select((p) => p.language));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat bantuan...',
          child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header with back button ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/profile'),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 38, height: 38,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Help & Support',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontSize: 22)),
                        const SizedBox(height: 2),
                        Text('Kami siap membantu',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Quick contact cards ────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _ContactCard(
                        icon: Icons.email_outlined,
                        iconColor: AppColors.primary,
                        title: 'Email',
                        subtitle: 'support@xalarm.app',
                        onTap: () => _showSnack(context,
                            'Email: support@xalarm.app'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ContactCard(
                        icon: Icons.chat_bubble_outline_rounded,
                        iconColor: AppColors.green,
                        title: 'Live Chat',
                        subtitle: 'Sen-Jum 9-17',
                        onTap: () => _showSnack(context,
                            'Live chat akan segera tersedia'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── FAQ Section ────────────────────────────────────────
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text('PERTANYAAN UMUM',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    )),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    children: [
                      _FaqTile(
                        question: 'Kenapa alarm tidak berbunyi?',
                        answer:
                            'Pastikan volume HP tidak silent, izin notifikasi sudah diaktifkan, dan aplikasi tidak dibatasi battery saver. Cek juga apakah alarm dalam keadaan ON di halaman utama.',
                      ),
                      Divider(color: AppColors.border, height: 1, indent: 20),
                      _FaqTile(
                        question: 'Apa itu Wake-up Challenge?',
                        answer:
                            'Wake-up Challenge memaksa kamu menyelesaikan tugas (scan QR, math, riddle, atau menyusun kata) sebelum alarm bisa dimatikan. Tujuannya supaya kamu benar-benar bangun.',
                      ),
                      Divider(color: AppColors.border, height: 1, indent: 20),
                      _FaqTile(
                        question: 'Apa fungsi Anti-Cheat?',
                        answer:
                            'Anti-Cheat melindungi alarm dari upaya force-close, restart HP, atau menghindari challenge. Kamu bisa atur tingkat proteksi di menu Anti-Cheat Settings.',
                      ),
                      Divider(color: AppColors.border, height: 1, indent: 20),
                      _FaqTile(
                        question: 'Bagaimana cara reset password?',
                        answer:
                            'Di halaman login, tap "Forgot Password?" lalu masukkan email. Link reset akan dikirim ke email kamu dalam beberapa menit.',
                      ),
                      Divider(color: AppColors.border, height: 1, indent: 20),
                      _FaqTile(
                        question: 'Apakah data sleep tersinkronisasi?',
                        answer:
                            'Data analitik tidur disimpan lokal di device kamu. Sinkronisasi cloud akan tersedia di versi mendatang.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Additional Links ───────────────────────────────────
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text('LAINNYA',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    )),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _LinkTile(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: AppColors.primary,
                        title: tr('settings.privacy.title', lang),
                        onTap: () => context.push('/privacy'),
                      ),
                      const Divider(color: AppColors.border, height: 1, indent: 60),
                      _LinkTile(
                        icon: Icons.description_outlined,
                        iconColor: AppColors.teal,
                        title: tr('settings.tos.title', lang),
                        onTap: () => context.push('/tos'),
                      ),
                      const Divider(color: AppColors.border, height: 1, indent: 60),
                      _LinkTile(
                        icon: Icons.star_outline_rounded,
                        iconColor: AppColors.orange,
                        title: 'Beri Rating Aplikasi',
                        onTap: () =>
                            _showSnack(context, 'Terima kasih atas dukungannya!'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.answer,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  const _LinkTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 18,
      ),
    );
  }
}
