import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/translations.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/loading_indicators.dart';
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);
    final lang = prefs.language;
    final notifier = ref.read(preferencesProvider.notifier);
    final selectedSound = getSoundById(prefs.alarmSoundId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat pengaturan...',
          child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header (no back button — this is a tab) ─────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(
                      tr('settings.title', lang),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),

            // ── ALARM ──────────────────────────────────────────────────
            _SectionLabel(tr('settings.section.alarm', lang)),
            SliverToBoxAdapter(
              child: _SettingsCard(children: [
                _SettingsTile(
                  icon: Icons.music_note_rounded,
                  iconColor: AppColors.primary,
                  title: tr('settings.sound.title', lang),
                  subtitle: selectedSound.name,
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () =>
                      _showSoundPicker(context, ref, prefs.alarmSoundId),
                ),
                _Div(),
                _SettingsTile(
                  icon: Icons.snooze_rounded,
                  iconColor: AppColors.orange,
                  title: tr('settings.snooze.title', lang),
                  subtitle: '${prefs.snoozeMinutes} menit',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () =>
                      _showSnoozePicker(context, ref, prefs.snoozeMinutes),
                ),
                _Div(),
                _SettingsTile(
                  icon: Icons.access_time_rounded,
                  iconColor: AppColors.teal,
                  title: tr('settings.format.title', lang),
                  subtitle: prefs.timeFormat == TimeFormat.h24
                      ? '24 jam (13:00)'
                      : '12 jam (1:00 PM)',
                  trailing: _SegmentedToggle(
                    selected: prefs.timeFormat == TimeFormat.h24 ? 1 : 0,
                    options: const ['12h', '24h'],
                    onChanged: (i) => notifier.setTimeFormat(
                        i == 0 ? TimeFormat.h12 : TimeFormat.h24),
                  ),
                ),
                _Div(),
                _SwitchTile(
                  icon: Icons.vibration,
                  iconColor: AppColors.purple,
                  title: tr('settings.vibration.title', lang),
                  subtitle: tr('settings.vibration.desc', lang),
                  value: prefs.vibrationEnabled,
                  onChanged: notifier.setVibration,
                ),
                _Div(),
                _SwitchTile(
                  icon: Icons.volume_up_outlined,
                  iconColor: AppColors.green,
                  title: tr('settings.gradual.title', lang),
                  subtitle: tr('settings.gradual.desc', lang),
                  value: prefs.gradualVolumeEnabled,
                  onChanged: notifier.setGradualVolume,
                ),
              ]),
            ),

            // ── NOTIFIKASI ─────────────────────────────────────────────
            _SectionLabel(tr('settings.section.notif', lang)),
            SliverToBoxAdapter(
              child: _SettingsCard(children: [
                _SwitchTile(
                  icon: Icons.notifications_active_rounded,
                  iconColor: AppColors.primary,
                  title: tr('settings.notif.enable.title', lang),
                  subtitle: tr('settings.notif.enable.desc', lang),
                  value: prefs.notificationsEnabled,
                  onChanged: notifier.setNotifications,
                ),
                _Div(),
                _SwitchTile(
                  icon: Icons.bedtime_outlined,
                  iconColor: AppColors.purple,
                  title: tr('settings.bedtime.title', lang),
                  subtitle: prefs.bedtimeReminderEnabled
                      ? '${prefs.bedtimeReminderHoursBeforeAlarm} jam sebelum alarm'
                      : 'Reminder untuk tidur lebih awal',
                  value: prefs.bedtimeReminderEnabled,
                  onChanged: (v) =>
                      notifier.setBedtimeReminder(v,
                          hoursBeforeAlarm:
                              prefs.bedtimeReminderHoursBeforeAlarm),
                ),
                if (prefs.bedtimeReminderEnabled) ...[
                  _Div(),
                  _SettingsTile(
                    icon: Icons.schedule_rounded,
                    iconColor: AppColors.teal,
                    title: tr('settings.bedtime.hours_title', lang),
                    subtitle:
                        '${prefs.bedtimeReminderHoursBeforeAlarm} jam (target ${8} jam tidur)',
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                    onTap: () => _showHoursPicker(context, ref,
                        prefs.bedtimeReminderHoursBeforeAlarm),
                  ),
                ],
              ]),
            ),

            // ── KEAMANAN ───────────────────────────────────────────────
            _SectionLabel(tr('settings.section.security', lang)),
            SliverToBoxAdapter(
              child: _SettingsCard(children: [
                _SettingsTile(
                  icon: Icons.security,
                  iconColor: AppColors.red,
                  title: tr('settings.anticheat.title', lang),
                  subtitle: tr('settings.anticheat.desc', lang),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => context.push('/anti-cheat'),
                ),
                _Div(),
                _SwitchTile(
                  icon: Icons.lock_outline,
                  iconColor: AppColors.orange,
                  title: tr('settings.lock.title', lang),
                  subtitle: tr('settings.lock.desc', lang),
                  value: prefs.lockScreenEnabled,
                  onChanged: notifier.setLockScreen,
                ),
              ]),
            ),

            // ── TAMPILAN ───────────────────────────────────────────────
            _SectionLabel(tr('settings.section.appearance', lang)),
            SliverToBoxAdapter(
              child: _SettingsCard(children: [
                _SettingsTile(
                  icon: Icons.brightness_6_rounded,
                  iconColor: AppColors.purple,
                  title: tr('settings.theme.title', lang),
                  subtitle: prefs.themeMode == AppThemeMode.dark
                      ? 'Dark Mode'
                      : (prefs.themeMode == AppThemeMode.light
                          ? 'Light Mode'
                          : 'Otomatis'),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => _showThemePicker(context, ref, prefs.themeMode),
                ),
                _Div(),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  iconColor: AppColors.teal,
                  title: tr('settings.lang.title', lang),
                  subtitle: prefs.language == AppLanguage.id
                      ? 'Bahasa Indonesia'
                      : 'English',
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () =>
                      _showLanguagePicker(context, ref, prefs.language),
                ),
              ]),
            ),

            // ── BANTUAN & TENTANG ──────────────────────────────────────
            _SectionLabel(tr('settings.section.help', lang)),
            SliverToBoxAdapter(
              child: _SettingsCard(children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  iconColor: AppColors.primary,
                  title: tr('settings.help.title', lang),
                  subtitle: tr('settings.help.desc', lang),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => context.push('/help'),
                ),
                _Div(),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  iconColor: AppColors.green,
                  title: tr('settings.privacy.title', lang),
                  subtitle: tr('settings.privacy.desc', lang),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => context.push('/privacy'),
                ),
                _Div(),
                _SettingsTile(
                  icon: Icons.gavel_outlined,
                  iconColor: AppColors.orange,
                  title: tr('settings.tos.title', lang),
                  subtitle: tr('settings.tos.desc', lang),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () => context.push('/tos'),
                ),
                _Div(),
                _SettingsTile(
                  icon: Icons.info_outline,
                  iconColor: AppColors.textSecondary,
                  title: tr('settings.version.title', lang),
                  subtitle: 'XAlarm v1.0.0 (build 2026.05)',
                ),
              ]),
            ),

            // ── Sign out ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: GestureDetector(
                  onTap: () => _confirmSignOut(context, ref),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded,
                            color: AppColors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          tr('settings.signout', lang),
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      
        ),
      ),
    );
  }

  // ── Modal pickers ──────────────────────────────────────────────────────

  void _showSoundPicker(
      BuildContext context, WidgetRef ref, String currentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SoundPickerSheet(currentId: currentId, ref: ref),
    );
  }

  void _showSnoozePicker(
      BuildContext context, WidgetRef ref, int current) {
    final lang = ref.read(preferencesProvider).language;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _OptionsSheet<int>(
        title: tr('settings.snooze.title', lang),
        subtitle: tr('settings.snooze.desc', lang),
        options: const [1, 3, 5, 10, 15],
        labelOf: (m) => '$m ${tr('common.menit', lang)}',
        current: current,
        onPick: (m) {
          ref.read(preferencesProvider.notifier).setSnoozeMinutes(m);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showHoursPicker(BuildContext context, WidgetRef ref, int current) {
    final lang = ref.read(preferencesProvider).language;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _OptionsSheet<int>(
        title: tr('settings.bedtime.title', lang),
        subtitle: tr('settings.bedtime.hours_title', lang),
        options: const [6, 7, 8, 9, 10],
        labelOf: (h) => '$h ${tr('common.jam', lang)} ${lang == AppLanguage.id ? 'sebelum alarm' : 'before alarm'}',
        current: current,
        onPick: (h) {
          ref.read(preferencesProvider.notifier).setBedtimeReminder(true,
              hoursBeforeAlarm: h);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, AppThemeMode current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final lang = ref.read(preferencesProvider).language;
        return _OptionsSheet<AppThemeMode>(
        title: tr('settings.theme.title', lang),
        subtitle: tr('settings.theme.desc', lang),
        options: AppThemeMode.values,
        labelOf: (m) {
          switch (m) {
            case AppThemeMode.dark:
              return '🌙  ${tr('settings.theme.dark', lang)}';
            case AppThemeMode.light:
              return '☀️  ${tr('settings.theme.light', lang)}';
            case AppThemeMode.system:
              return '🔄  ${tr('settings.theme.system', lang)}';
          }
        },
        current: current,
        onPick: (m) {
          ref.read(preferencesProvider.notifier).setThemeMode(m);
          Navigator.pop(ctx);
        },
      );
      },
    );
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, AppLanguage current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final lang = ref.read(preferencesProvider).language;
        return _OptionsSheet<AppLanguage>(
        title: tr('settings.lang.title', lang),
        subtitle: tr('settings.lang.desc', lang),
        options: AppLanguage.values,
        labelOf: (l) =>
            l == AppLanguage.id ? '🇮🇩  ${tr('settings.lang.id', lang)}' : '🇬🇧  ${tr('settings.lang.en', lang)}',
        current: current,
        onPick: (l) {
          ref.read(preferencesProvider.notifier).setLanguage(l);
          Navigator.pop(ctx);
        },
      );
      },
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    final lang = ref.read(preferencesProvider).language;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded,
                  color: AppColors.red, size: 18),
            ),
            const SizedBox(width: 12),
            Text(tr('settings.signout.confirm.title', lang),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
        content: Text(
          tr('settings.signout.confirm.body', lang),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr('common.cancel', lang),
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: Text(tr('settings.signout', lang),
                style: const TextStyle(
                    color: AppColors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// REUSABLE WIDGETS
// =============================================================================

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 20, 8),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: children),
      ),
    );
  }
}

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.border, height: 1, indent: 60);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
      onTap: () => onChanged(!value),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final int selected;
  final List<String> options;
  final ValueChanged<int> onChanged;
  const _SegmentedToggle({
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (i) {
          final isSel = i == selected;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSel ? AppColors.primaryGradient : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                options[i],
                style: TextStyle(
                  color: isSel ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Generic options bottom sheet ─────────────────────────────────────────────
class _OptionsSheet<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<T> options;
  final T current;
  final String Function(T) labelOf;
  final bool Function(T)? disabledFn;
  final ValueChanged<T> onPick;
  const _OptionsSheet({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.current,
    required this.labelOf,
    required this.onPick,
    this.disabledFn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...options.map((opt) {
            final selected = opt == current;
            final disabled = disabledFn?.call(opt) ?? false;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Opacity(
                opacity: disabled ? 0.4 : 1.0,
                child: GestureDetector(
                  onTap: disabled ? null : () => onPick(opt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            labelOf(opt),
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle,
                              color: AppColors.primary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Sound picker sheet (separate because items show icon + description) ─────
class _SoundPickerSheet extends StatelessWidget {
  final String currentId;
  final WidgetRef ref;
  const _SoundPickerSheet({required this.currentId, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text('Suara Alarm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 4),
          const Text(
            'Pilih ringtone untuk alarm kamu',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: alarmSoundCatalog.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final sound = alarmSoundCatalog[i];
                final selected = sound.id == currentId;
                return GestureDetector(
                  onTap: () {
                    ref.read(alarmAudioProvider).previewSound(sound.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selected ? AppColors.primary : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(alarmAudioProvider).previewSound(sound.id);
                          },
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(sound.icon,
                                color: AppColors.primary, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(preferencesProvider.notifier)
                                  .setSoundId(sound.id);
                              ref.read(alarmAudioProvider).stopPreview();
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sound.name,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  sound.description,
                                  style: const TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle,
                              color: AppColors.primary, size: 18),
                        if (!selected)
                          GestureDetector(
                            onTap: () {
                              ref.read(alarmAudioProvider).previewSound(sound.id);
                            },
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: AppColors.primary, size: 18),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
