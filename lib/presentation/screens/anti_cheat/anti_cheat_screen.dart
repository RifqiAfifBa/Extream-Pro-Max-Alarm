import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/alarm_providers.dart';

import '../../widgets/loading_indicators.dart';
class AntiCheatScreen extends ConsumerWidget {
  const AntiCheatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(antiCheatProvider);
    final notifier = ref.read(antiCheatProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat keamanan...',
          child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => context.pop(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 38, height: 38,
                        margin: const EdgeInsets.only(right: 12, top: 2),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Anti-Cheat',
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 26)),
                              const SizedBox(width: 12),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (state.masterEnabled ? AppColors.green : AppColors.textTertiary).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6, height: 6,
                                      decoration: BoxDecoration(
                                        color: state.masterEnabled ? AppColors.green : AppColors.textTertiary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      state.masterEnabled ? 'Aktif' : 'Nonaktif',
                                      style: TextStyle(
                                        color: state.masterEnabled ? AppColors.green : AppColors.textTertiary,
                                        fontSize: 12, fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Sistem perlindungan alarm', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Container(
                      width: 42, height: 42,
                      decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                      child: const Center(child: Text('JD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
                    ),
                  ],
                ),
              ),
            ),

            // Master card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    gradient: state.masterEnabled ? AppColors.greenGradient : const LinearGradient(colors: [AppColors.card, AppColors.card]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.security, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Proteksi Anti-Cheat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                                SizedBox(height: 2),
                                Text('Lindungi alarm dari kecurangan', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          Switch(
                            value: state.masterEnabled,
                            onChanged: (_) => notifier.toggle('master'),
                            thumbColor: WidgetStateProperty.all(Colors.white),
                            trackColor: WidgetStateProperty.resolveWith(
                              (s) => s.contains(WidgetState.selected) ? Colors.white30 : AppColors.surfaceLight,
                            ),
                            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                        ],
                      ),
                      if (state.masterEnabled) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.white.withOpacity(0.8), size: 15),
                              const SizedBox(width: 8),
                              Text('Semua sistem perlindungan berjalan normal',
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Threats
            SliverToBoxAdapter(child: _sectionHeader(context, 'ANCAMAN YANG DIBLOKIR')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20)),
                  child: const Column(
                    children: [
                      _ThreatTile(icon: Icons.close, iconColor: AppColors.red, title: 'Force Stop Aplikasi', subtitle: 'Paksa tutup dari pengaturan sistem'),
                      Divider(color: AppColors.border, height: 1, indent: 64),
                      _ThreatTile(icon: Icons.replay, iconColor: AppColors.red, title: 'Restart / Reboot HP', subtitle: 'Matikan dan nyalakan ulang perangkat'),
                    ],
                  ),
                ),
              ),
            ),

            // Solutions
            SliverToBoxAdapter(child: _sectionHeader(context, 'SOLUSI PERLINDUNGAN')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      _ProtectionTile(icon: Icons.check_circle_outline, iconColor: AppColors.primary, title: 'Deteksi Force Close', subtitle: 'Alarm aktif kembali jika ditutup paksa', value: state.detectForceClose, onChanged: (_) => notifier.toggle('forceClose')),
                      const Divider(color: AppColors.border, height: 1, indent: 64),
                      _ProtectionTile(icon: Icons.phone_android, iconColor: AppColors.green, title: 'Alarm Aktif Setelah Reboot', subtitle: 'Alarm tetap berjalan setelah HP dinyalakan ulang', value: state.alarmAfterReboot, onChanged: (_) => notifier.toggle('reboot')),
                      const Divider(color: AppColors.border, height: 1, indent: 64),
                      _ProtectionTile(icon: Icons.lock_outline, iconColor: AppColors.yellow, title: 'Mode Lock Screen', subtitle: 'Tampilkan alarm di atas lock screen', value: state.lockScreenMode, onChanged: (_) => notifier.toggle('lockScreen'), isOptional: true),
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

  Widget _sectionHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: AppColors.textSecondary)),
    );
  }
}

class _ThreatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ThreatTile({required this.icon, required this.iconColor, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: const Text('Ancaman', style: TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ProtectionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isOptional;

  const _ProtectionTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.value, required this.onChanged, this.isOptional = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    if (isOptional) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.yellow.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Opsional', style: TextStyle(color: AppColors.yellow, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                    const SizedBox(width: 4),
                    const Icon(Icons.help_outline, color: AppColors.textTertiary, size: 14),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
