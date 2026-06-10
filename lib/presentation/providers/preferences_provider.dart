import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// =============================================================================
// PREFERENCES PROVIDER
// Holds all user-facing app settings (sound, snooze, time format, theme,
// language, notifications, bedtime reminder, first-launch flag, achievements).
//
// In a production app you'd persist these via SharedPreferences or Hive.
// For this UI demo state is kept in-memory — works perfectly for a dosen demo.
// =============================================================================

// ── Enums ───────────────────────────────────────────────────────────────────
enum TimeFormat { h12, h24 }

enum AppLanguage { id, en }

enum AppThemeMode { dark, light, system }

// ── Model ───────────────────────────────────────────────────────────────────
class AppPreferences {
  final bool isFirstLaunch;
  final bool notificationsEnabled;
  final String alarmSoundId;
  final int snoozeMinutes;
  final TimeFormat timeFormat;
  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool bedtimeReminderEnabled;
  final int bedtimeReminderHoursBeforeAlarm;
  // Newly-wired toggles (previously hardcoded true)
  final bool vibrationEnabled;
  final bool gradualVolumeEnabled;
  final bool lockScreenEnabled;

  const AppPreferences({
    this.isFirstLaunch = true,
    this.notificationsEnabled = true,
    this.alarmSoundId = 'default_bell',
    this.snoozeMinutes = 5,
    this.timeFormat = TimeFormat.h24,
    this.themeMode = AppThemeMode.dark,
    this.language = AppLanguage.id,
    this.bedtimeReminderEnabled = false,
    this.bedtimeReminderHoursBeforeAlarm = 8,
    this.vibrationEnabled = true,
    this.gradualVolumeEnabled = true,
    this.lockScreenEnabled = true,
  });

  AppPreferences copyWith({
    bool? isFirstLaunch,
    bool? notificationsEnabled,
    String? alarmSoundId,
    int? snoozeMinutes,
    TimeFormat? timeFormat,
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? bedtimeReminderEnabled,
    int? bedtimeReminderHoursBeforeAlarm,
    bool? vibrationEnabled,
    bool? gradualVolumeEnabled,
    bool? lockScreenEnabled,
  }) {
    return AppPreferences(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      alarmSoundId: alarmSoundId ?? this.alarmSoundId,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      timeFormat: timeFormat ?? this.timeFormat,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      bedtimeReminderEnabled:
          bedtimeReminderEnabled ?? this.bedtimeReminderEnabled,
      bedtimeReminderHoursBeforeAlarm: bedtimeReminderHoursBeforeAlarm ??
          this.bedtimeReminderHoursBeforeAlarm,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      gradualVolumeEnabled: gradualVolumeEnabled ?? this.gradualVolumeEnabled,
      lockScreenEnabled: lockScreenEnabled ?? this.lockScreenEnabled,
    );
  }
}

// ── Notifier ────────────────────────────────────────────────────────────────
class PreferencesNotifier extends StateNotifier<AppPreferences> {
  PreferencesNotifier() : super(const AppPreferences());

  void completeOnboarding() => state = state.copyWith(isFirstLaunch: false);
  void setNotifications(bool v) =>
      state = state.copyWith(notificationsEnabled: v);
  void setSoundId(String id) => state = state.copyWith(alarmSoundId: id);
  void setSnoozeMinutes(int m) => state = state.copyWith(snoozeMinutes: m);
  void setTimeFormat(TimeFormat f) => state = state.copyWith(timeFormat: f);
  void setThemeMode(AppThemeMode m) => state = state.copyWith(themeMode: m);
  void setLanguage(AppLanguage l) => state = state.copyWith(language: l);
  void setBedtimeReminder(bool on, {int? hoursBeforeAlarm}) =>
      state = state.copyWith(
        bedtimeReminderEnabled: on,
        bedtimeReminderHoursBeforeAlarm: hoursBeforeAlarm,
      );
  void setVibration(bool v) => state = state.copyWith(vibrationEnabled: v);
  void setGradualVolume(bool v) =>
      state = state.copyWith(gradualVolumeEnabled: v);
  void setLockScreen(bool v) => state = state.copyWith(lockScreenEnabled: v);
}

// ── Provider ────────────────────────────────────────────────────────────────
final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, AppPreferences>(
  (ref) => PreferencesNotifier(),
);

// =============================================================================
// ALARM SOUND CATALOG
// =============================================================================
class AlarmSound {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  const AlarmSound({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

const List<AlarmSound> alarmSoundCatalog = [
  AlarmSound(
    id: 'default_bell',
    name: 'Default Bell',
    icon: Icons.notifications_active_rounded,
    description: 'Bunyi alarm klasik yang lembut',
  ),
  AlarmSound(
    id: 'morning_wake',
    name: 'Morning Wake',
    icon: Icons.wb_sunny_rounded,
    description: 'Suara burung berkicau & sinar pagi',
  ),
  AlarmSound(
    id: 'sunrise',
    name: 'Sunrise',
    icon: Icons.wb_twilight_rounded,
    description: 'Ambient pagi yang menenangkan',
  ),
  AlarmSound(
    id: 'gentle_wave',
    name: 'Gentle Wave',
    icon: Icons.waves_rounded,
    description: 'Suara ombak menenangkan',
  ),
  AlarmSound(
    id: 'energetic_beat',
    name: 'Energetic Beat',
    icon: Icons.music_note_rounded,
    description: 'Beat energik untuk bangun semangat',
  ),
  AlarmSound(
    id: 'classic_alarm',
    name: 'Classic Alarm',
    icon: Icons.alarm_rounded,
    description: 'Bunyi alarm tradisional yang nyaring',
  ),
];

AlarmSound getSoundById(String id) =>
    alarmSoundCatalog.firstWhere((s) => s.id == id,
        orElse: () => alarmSoundCatalog.first);

// =============================================================================
// ACHIEVEMENTS CATALOG
// =============================================================================
class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final String? unlockedAt; // human-readable date
  final int? progress; // 0-100 if locked

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
    this.unlockedAt,
    this.progress,
  });
}

// Static list — in production these would derive from actual user stats.
List<Achievement> getAchievements() {
  return [
    const Achievement(
      id: 'first_wake',
      name: 'Bangun Pertama',
      description: 'Selesaikan challenge alarm pertamamu',
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFFFB400),
      unlocked: true,
      unlockedAt: '20 Mei',
    ),
    const Achievement(
      id: 'streak_7',
      name: 'Konsisten 7 Hari',
      description: 'Bangun tepat waktu 7 hari beruntun',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFFF6B6B),
      unlocked: true,
      unlockedAt: '23 Mei',
    ),
    const Achievement(
      id: 'no_snooze',
      name: 'Anti Snooze',
      description: '5 alarm tanpa snooze sekali pun',
      icon: Icons.do_not_disturb_off_rounded,
      color: Color(0xFF10B981),
      unlocked: true,
      unlockedAt: '24 Mei',
    ),
    const Achievement(
      id: 'speed_demon',
      name: 'Speed Demon',
      description: 'Matikan alarm dalam <30 detik',
      icon: Icons.bolt_rounded,
      color: Color(0xFF9333EA),
      unlocked: true,
      unlockedAt: '25 Mei',
    ),
    const Achievement(
      id: 'streak_30',
      name: 'Konsisten 30 Hari',
      description: 'Bangun tepat waktu 30 hari beruntun',
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFF06B6D4),
      unlocked: false,
      progress: 23,
    ),
    const Achievement(
      id: 'math_master',
      name: 'Math Master',
      description: 'Selesaikan 50 math challenge tanpa error',
      icon: Icons.calculate_rounded,
      color: Color(0xFFEC4899),
      unlocked: false,
      progress: 64,
    ),
    const Achievement(
      id: 'early_bird',
      name: 'Early Bird',
      description: 'Bangun sebelum jam 5 pagi 10 kali',
      icon: Icons.wb_sunny_outlined,
      color: Color(0xFFF59E0B),
      unlocked: false,
      progress: 30,
    ),
    const Achievement(
      id: 'hundred_wakes',
      name: '100 Sukses',
      description: 'Total 100 alarm berhasil dimatikan',
      icon: Icons.military_tech_rounded,
      color: Color(0xFF8B5CF6),
      unlocked: false,
      progress: 57,
    ),
  ];
}
