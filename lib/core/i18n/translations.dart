import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/preferences_provider.dart';

// =============================================================================
// INTERNATIONALIZATION
// Map-based translations for ID & EN. Keys are dot-separated for organization.
// Fallback chain: requested lang → ID → key itself (so missing keys are visible).
//
// Usage:
//   1. Direct: `tr('tab.alarm', AppLanguage.id)` — when you have the language
//   2. Reactive: wrap with `T('tab.alarm')` widget that auto-rebuilds on change
//   3. Inline reactive: `ref.watch(...)` for the language, then call tr(...)
// =============================================================================

const Map<String, Map<AppLanguage, String>> _strings = {
  // ── Bottom nav tabs ────────────────────────────────────────────────────
  'tab.alarm': {AppLanguage.id: 'Alarm', AppLanguage.en: 'Alarm'},
  'tab.timer': {AppLanguage.id: 'Timer', AppLanguage.en: 'Timer'},
  'tab.settings': {AppLanguage.id: 'Settings', AppLanguage.en: 'Settings'},
  'tab.profile': {AppLanguage.id: 'Profil', AppLanguage.en: 'Profile'},

  // ── Splash ─────────────────────────────────────────────────────────────
  'splash.tagline': {
    AppLanguage.id: 'WAKE UP. NO EXCUSES.',
    AppLanguage.en: 'WAKE UP. NO EXCUSES.',
  },
  'splash.loading': {AppLanguage.id: 'Loading...', AppLanguage.en: 'Loading...'},

  // ── Common buttons / actions ───────────────────────────────────────────
  'common.save': {AppLanguage.id: 'Simpan', AppLanguage.en: 'Save'},
  'common.cancel': {AppLanguage.id: 'Batal', AppLanguage.en: 'Cancel'},
  'common.delete': {AppLanguage.id: 'Hapus', AppLanguage.en: 'Delete'},
  'common.edit': {AppLanguage.id: 'Edit', AppLanguage.en: 'Edit'},
  'common.add': {AppLanguage.id: 'Tambah', AppLanguage.en: 'Add'},
  'common.continue': {AppLanguage.id: 'Lanjut', AppLanguage.en: 'Continue'},
  'common.skip': {AppLanguage.id: 'Lewati', AppLanguage.en: 'Skip'},
  'common.start': {AppLanguage.id: 'Mulai', AppLanguage.en: 'Start'},
  'common.pause': {AppLanguage.id: 'Jeda', AppLanguage.en: 'Pause'},
  'common.resume': {AppLanguage.id: 'Lanjut', AppLanguage.en: 'Resume'},
  'common.reset': {AppLanguage.id: 'Reset', AppLanguage.en: 'Reset'},
  'common.done': {AppLanguage.id: 'Selesai', AppLanguage.en: 'Done'},
  'common.loading': {AppLanguage.id: 'Memuat...', AppLanguage.en: 'Loading...'},
  'common.yes': {AppLanguage.id: 'Ya', AppLanguage.en: 'Yes'},
  'common.no': {AppLanguage.id: 'Tidak', AppLanguage.en: 'No'},
  'common.preview': {AppLanguage.id: 'Preview', AppLanguage.en: 'Preview'},
  'common.menit': {AppLanguage.id: 'menit', AppLanguage.en: 'minutes'},
  'common.jam': {AppLanguage.id: 'jam', AppLanguage.en: 'hours'},

  // ── Login ──────────────────────────────────────────────────────────────
  'login.welcome': {
    AppLanguage.id: 'Selamat Datang',
    AppLanguage.en: 'Welcome Back',
  },
  'login.subtitle': {
    AppLanguage.id: 'Masuk untuk melanjutkan',
    AppLanguage.en: 'Sign in to continue',
  },
  'login.email': {AppLanguage.id: 'Email', AppLanguage.en: 'Email'},
  'login.password': {AppLanguage.id: 'Password', AppLanguage.en: 'Password'},
  'login.email_hint': {
    AppLanguage.id: 'kamu@example.com',
    AppLanguage.en: 'you@example.com',
  },
  'login.password_hint': {
    AppLanguage.id: 'Masukkan password',
    AppLanguage.en: 'Enter your password',
  },
  'login.forgot': {
    AppLanguage.id: 'Lupa password?',
    AppLanguage.en: 'Forgot Password?',
  },
  'login.sign_in': {AppLanguage.id: 'Masuk', AppLanguage.en: 'Sign In'},
  'login.or': {
    AppLanguage.id: 'atau lanjutkan dengan',
    AppLanguage.en: 'or continue with',
  },
  'login.no_account': {
    AppLanguage.id: 'Belum punya akun?',
    AppLanguage.en: "Don't have an account?",
  },
  'login.sign_up': {AppLanguage.id: 'Daftar', AppLanguage.en: 'Sign Up'},

  // ── Onboarding ─────────────────────────────────────────────────────────
  'onb.next': {AppLanguage.id: 'Lanjut', AppLanguage.en: 'Next'},
  'onb.start_now': {
    AppLanguage.id: 'Mulai Sekarang',
    AppLanguage.en: 'Get Started',
  },
  'onb.slide1.title': {
    AppLanguage.id: 'Bangun.\nTanpa Alasan.',
    AppLanguage.en: 'Wake Up.\nNo Excuses.',
  },
  'onb.slide1.desc': {
    AppLanguage.id:
        'Alarm yang tidak bisa kamu matikan dengan cuek. Dirancang khusus untuk yang punya masalah snooze parah.',
    AppLanguage.en:
        'An alarm you cannot dismiss carelessly. Built for people with serious snooze problems.',
  },
  'onb.slide2.title': {
    AppLanguage.id: 'Wake-up\nChallenge',
    AppLanguage.en: 'Wake-up\nChallenge',
  },
  'onb.slide2.desc': {
    AppLanguage.id:
        'Selesaikan tantangan sebelum alarm berhenti. Pilih dari 4 jenis: QR Scan, Math, Word Arrange, atau Riddle.',
    AppLanguage.en:
        'Complete a challenge before the alarm stops. Pick from 4 types: QR Scan, Math, Word Arrange, or Riddle.',
  },
  'onb.slide2.badge': {
    AppLanguage.id: '4 JENIS CHALLENGE',
    AppLanguage.en: '4 CHALLENGE TYPES',
  },
  'onb.slide3.title': {
    AppLanguage.id: 'Anti-Cheat\nSystem',
    AppLanguage.en: 'Anti-Cheat\nSystem',
  },
  'onb.slide3.desc': {
    AppLanguage.id:
        'Force-close di-block. Mute volume di-detect. Buka aplikasi lain di-warning. Alarm gak bisa kabur.',
    AppLanguage.en:
        'Force-close blocked. Mute detected. Switching apps warned. The alarm cannot escape.',
  },
  'onb.slide4.title': {
    AppLanguage.id: 'Lacak\nPola Tidur',
    AppLanguage.en: 'Track Your\nSleep',
  },
  'onb.slide4.desc': {
    AppLanguage.id:
        'Statistik mingguan, success rate, streak konsistensi, dan analitik untuk bantu kamu bangun lebih baik.',
    AppLanguage.en:
        'Weekly stats, success rate, consistency streak, and analytics to help you wake up better.',
  },
  'onb.slide4.badge': {
    AppLanguage.id: 'TRACK YOUR PROGRESS',
    AppLanguage.en: 'TRACK YOUR PROGRESS',
  },

  // ── Home ───────────────────────────────────────────────────────────────
  'home.greeting': {
    AppLanguage.id: 'Selamat datang kembali',
    AppLanguage.en: 'Welcome back',
  },
  'home.my_alarms': {
    AppLanguage.id: 'Alarm Saya',
    AppLanguage.en: 'My Alarms',
  },
  'home.empty_title': {
    AppLanguage.id: 'Belum ada alarm',
    AppLanguage.en: 'No alarms yet',
  },
  'home.empty_desc': {
    AppLanguage.id:
        'Buat alarm pertamamu untuk mulai\nbangun tepat waktu setiap hari',
    AppLanguage.en:
        'Create your first alarm to start\nwaking up on time every day',
  },
  'home.empty_cta': {
    AppLanguage.id: 'Buat Alarm Pertama',
    AppLanguage.en: 'Create First Alarm',
  },

  // ── Settings ───────────────────────────────────────────────────────────
  'settings.title': {AppLanguage.id: 'Pengaturan', AppLanguage.en: 'Settings'},
  'settings.section.alarm': {AppLanguage.id: 'ALARM', AppLanguage.en: 'ALARM'},
  'settings.section.notif': {
    AppLanguage.id: 'NOTIFIKASI',
    AppLanguage.en: 'NOTIFICATIONS',
  },
  'settings.section.security': {
    AppLanguage.id: 'KEAMANAN',
    AppLanguage.en: 'SECURITY',
  },
  'settings.section.appearance': {
    AppLanguage.id: 'TAMPILAN',
    AppLanguage.en: 'APPEARANCE',
  },
  'settings.section.help': {
    AppLanguage.id: 'BANTUAN & TENTANG',
    AppLanguage.en: 'HELP & ABOUT',
  },

  'settings.sound.title': {
    AppLanguage.id: 'Suara Alarm',
    AppLanguage.en: 'Alarm Sound',
  },
  'settings.sound.desc': {
    AppLanguage.id: 'Pilih ringtone untuk alarm kamu',
    AppLanguage.en: 'Choose a ringtone for your alarm',
  },
  'settings.snooze.title': {
    AppLanguage.id: 'Durasi Snooze',
    AppLanguage.en: 'Snooze Duration',
  },
  'settings.snooze.desc': {
    AppLanguage.id: 'Berapa menit alarm di-snooze',
    AppLanguage.en: 'How many minutes to snooze',
  },
  'settings.format.title': {
    AppLanguage.id: 'Format Waktu',
    AppLanguage.en: 'Time Format',
  },
  'settings.format.h24': {
    AppLanguage.id: '24 jam (13:00)',
    AppLanguage.en: '24-hour (13:00)',
  },
  'settings.format.h12': {
    AppLanguage.id: '12 jam (1:00 PM)',
    AppLanguage.en: '12-hour (1:00 PM)',
  },
  'settings.vibration.title': {
    AppLanguage.id: 'Getaran',
    AppLanguage.en: 'Vibration',
  },
  'settings.vibration.desc': {
    AppLanguage.id: 'Getarkan perangkat saat alarm berbunyi',
    AppLanguage.en: 'Vibrate device when alarm rings',
  },
  'settings.gradual.title': {
    AppLanguage.id: 'Volume Bertahap',
    AppLanguage.en: 'Gradual Volume',
  },
  'settings.gradual.desc': {
    AppLanguage.id: 'Naikkan volume perlahan dari pelan ke keras',
    AppLanguage.en: 'Gradually increase volume from soft to loud',
  },

  'settings.notif.enable.title': {
    AppLanguage.id: 'Aktifkan Notifikasi',
    AppLanguage.en: 'Enable Notifications',
  },
  'settings.notif.enable.desc': {
    AppLanguage.id: 'Push notification untuk alarm & pengingat',
    AppLanguage.en: 'Push notifications for alarms & reminders',
  },
  'settings.bedtime.title': {
    AppLanguage.id: 'Pengingat Tidur',
    AppLanguage.en: 'Bedtime Reminder',
  },
  'settings.bedtime.desc_off': {
    AppLanguage.id: 'Reminder untuk tidur lebih awal',
    AppLanguage.en: 'Reminder to go to bed earlier',
  },
  'settings.bedtime.hours_title': {
    AppLanguage.id: 'Jam Sebelum Alarm',
    AppLanguage.en: 'Hours Before Alarm',
  },

  'settings.anticheat.title': {
    AppLanguage.id: 'Anti-Cheat System',
    AppLanguage.en: 'Anti-Cheat System',
  },
  'settings.anticheat.desc': {
    AppLanguage.id: 'Cegah alarm dimatikan dengan cara curang',
    AppLanguage.en: 'Prevent the alarm from being cheated off',
  },
  'settings.lock.title': {
    AppLanguage.id: 'Lock Screen',
    AppLanguage.en: 'Lock Screen',
  },
  'settings.lock.desc': {
    AppLanguage.id: 'Tampilkan alarm di lock screen',
    AppLanguage.en: 'Show alarm on lock screen',
  },

  'settings.theme.title': {AppLanguage.id: 'Tema', AppLanguage.en: 'Theme'},
  'settings.theme.desc': {
    AppLanguage.id: 'Pilih tampilan aplikasi',
    AppLanguage.en: 'Choose app appearance',
  },
  'settings.theme.dark': {
    AppLanguage.id: 'Dark Mode',
    AppLanguage.en: 'Dark Mode',
  },
  'settings.theme.light': {
    AppLanguage.id: 'Light Mode',
    AppLanguage.en: 'Light Mode',
  },
  'settings.theme.system': {
    AppLanguage.id: 'Ikuti Sistem',
    AppLanguage.en: 'Follow System',
  },

  'settings.lang.title': {AppLanguage.id: 'Bahasa', AppLanguage.en: 'Language'},
  'settings.lang.desc': {
    AppLanguage.id: 'Pilih bahasa aplikasi',
    AppLanguage.en: 'Choose app language',
  },
  'settings.lang.id': {
    AppLanguage.id: 'Bahasa Indonesia',
    AppLanguage.en: 'Bahasa Indonesia',
  },
  'settings.lang.en': {AppLanguage.id: 'English', AppLanguage.en: 'English'},

  'settings.help.title': {
    AppLanguage.id: 'Pusat Bantuan',
    AppLanguage.en: 'Help Center',
  },
  'settings.help.desc': {
    AppLanguage.id: 'FAQ, panduan, dan kontak support',
    AppLanguage.en: 'FAQ, guides, and support contact',
  },
  'settings.privacy.title': {
    AppLanguage.id: 'Kebijakan Privasi',
    AppLanguage.en: 'Privacy Policy',
  },
  'settings.privacy.desc': {
    AppLanguage.id: 'Cara kami menjaga data kamu',
    AppLanguage.en: 'How we protect your data',
  },
  'settings.tos.title': {
    AppLanguage.id: 'Syarat & Ketentuan',
    AppLanguage.en: 'Terms of Service',
  },
  'settings.tos.desc': {
    AppLanguage.id: 'Aturan penggunaan aplikasi',
    AppLanguage.en: 'App usage rules',
  },
  'settings.version.title': {
    AppLanguage.id: 'Versi Aplikasi',
    AppLanguage.en: 'App Version',
  },

  'settings.signout': {AppLanguage.id: 'Keluar', AppLanguage.en: 'Sign Out'},
  'settings.signout.confirm.title': {
    AppLanguage.id: 'Keluar?',
    AppLanguage.en: 'Sign Out?',
  },
  'settings.signout.confirm.body': {
    AppLanguage.id: 'Kamu akan dikeluarkan dari akun. Yakin?',
    AppLanguage.en: 'You will be signed out of your account. Are you sure?',
  },

  // ── Profile ────────────────────────────────────────────────────────────
  'profile.title': {AppLanguage.id: 'Profil', AppLanguage.en: 'Profile'},
  'profile.section.account': {AppLanguage.id: 'AKUN', AppLanguage.en: 'ACCOUNT'},
  'profile.edit': {
    AppLanguage.id: 'Edit Profil',
    AppLanguage.en: 'Edit Profile',
  },
  'profile.analytics': {
    AppLanguage.id: 'Analitik Tidur',
    AppLanguage.en: 'Sleep Analytics',
  },
  'profile.achievements': {
    AppLanguage.id: 'Semua Pencapaian',
    AppLanguage.en: 'All Achievements',
  },
  'profile.achievements.preview_title': {
    AppLanguage.id: 'Pencapaian',
    AppLanguage.en: 'Achievements',
  },

  // ── Timer ──────────────────────────────────────────────────────────────
  'timer.title': {AppLanguage.id: 'Timer', AppLanguage.en: 'Timer'},
  'timer.subtitle': {
    AppLanguage.id: 'Set countdown',
    AppLanguage.en: 'Set countdown',
  },
  'stopwatch.title': {
    AppLanguage.id: 'Stopwatch',
    AppLanguage.en: 'Stopwatch',
  },
  'stopwatch.subtitle': {
    AppLanguage.id: 'Lacak waktu berjalan',
    AppLanguage.en: 'Track elapsed time',
  },
  'timer.status.ready': {AppLanguage.id: 'SIAP', AppLanguage.en: 'READY'},
  'timer.status.running': {
    AppLanguage.id: 'BERJALAN',
    AppLanguage.en: 'RUNNING',
  },
  'timer.status.paused': {AppLanguage.id: 'DIJEDA', AppLanguage.en: 'PAUSED'},
  'timer.active_timers': {
    AppLanguage.id: 'Timer Aktif',
    AppLanguage.en: 'Active Timers',
  },
  'timer.running_count': {
    AppLanguage.id: 'berjalan',
    AppLanguage.en: 'running',
  },
  'timer.empty_title': {
    AppLanguage.id: 'Belum ada timer tambahan',
    AppLanguage.en: 'No additional timers',
  },
  'timer.empty_desc': {
    AppLanguage.id: 'Tap "+ Add" buat bikin timer baru',
    AppLanguage.en: 'Tap "+ Add" to create one',
  },
  'timer.add_title': {
    AppLanguage.id: 'Tambah Timer',
    AppLanguage.en: 'Add Timer',
  },
  'timer.add_desc': {
    AppLanguage.id: 'Timer baru akan langsung berjalan',
    AppLanguage.en: 'New timer will start immediately',
  },
  'timer.add_button': {
    AppLanguage.id: 'Mulai Timer',
    AppLanguage.en: 'Start Timer',
  },
  'timer.name_label': {AppLanguage.id: 'NAMA', AppLanguage.en: 'NAME'},
  'timer.duration_label': {
    AppLanguage.id: 'DURASI (MENIT)',
    AppLanguage.en: 'DURATION (MINUTES)',
  },
  'timer.icon_label': {AppLanguage.id: 'IKON', AppLanguage.en: 'ICON'},
  'timer.lap_times': {AppLanguage.id: 'Lap Times', AppLanguage.en: 'Lap Times'},
  'timer.no_laps_title': {
    AppLanguage.id: 'Belum ada lap',
    AppLanguage.en: 'No laps yet',
  },
  'timer.no_laps_desc': {
    AppLanguage.id: 'Tap "Lap" saat berjalan untuk merekam',
    AppLanguage.en: 'Tap "Lap" while running to record',
  },

  // ── Pomodoro ───────────────────────────────────────────────────────────
  'pomodoro.title': {AppLanguage.id: 'Pomodoro', AppLanguage.en: 'Pomodoro'},
  'pomodoro.badge': {AppLanguage.id: 'PATEN', AppLanguage.en: 'PINNED'},
  'pomodoro.phase.idle': {
    AppLanguage.id: 'Siap mulai',
    AppLanguage.en: 'Ready to start',
  },
  'pomodoro.phase.work': {AppLanguage.id: 'Fokus', AppLanguage.en: 'Focus'},
  'pomodoro.phase.short': {
    AppLanguage.id: 'Istirahat',
    AppLanguage.en: 'Break',
  },
  'pomodoro.phase.long': {
    AppLanguage.id: 'Istirahat Panjang',
    AppLanguage.en: 'Long Break',
  },
  'pomodoro.session': {AppLanguage.id: 'Sesi', AppLanguage.en: 'Session'},

  // ── Achievements ───────────────────────────────────────────────────────
  'ach.title': {AppLanguage.id: 'Pencapaian', AppLanguage.en: 'Achievements'},
  'ach.subtitle': {
    AppLanguage.id: 'Kumpulkan badge dengan rutin pakai XAlarm',
    AppLanguage.en: 'Earn badges by using XAlarm regularly',
  },
  'ach.unlocked_count': {
    AppLanguage.id: 'badge sudah terbuka',
    AppLanguage.en: 'badges unlocked',
  },
  'ach.remaining': {
    AppLanguage.id: 'badge tersisa untuk dibuka',
    AppLanguage.en: 'badges left to unlock',
  },

  // ── Privacy / ToS / Help (just headers) ────────────────────────────────
  'privacy.title': {
    AppLanguage.id: 'Kebijakan Privasi',
    AppLanguage.en: 'Privacy Policy',
  },
  'tos.title': {
    AppLanguage.id: 'Syarat & Ketentuan',
    AppLanguage.en: 'Terms of Service',
  },
  'help.title': {
    AppLanguage.id: 'Pusat Bantuan',
    AppLanguage.en: 'Help Center',
  },
  'help.subtitle': {
    AppLanguage.id: 'Kami siap membantu kamu',
    AppLanguage.en: "We're here to help",
  },
};

// ─────────────────────────────────────────────────────────────────────────────
// Public API
// ─────────────────────────────────────────────────────────────────────────────

/// Look up a translation by key + language. Falls back to ID, then key itself.
String tr(String key, AppLanguage lang) {
  final entry = _strings[key];
  if (entry == null) return key;
  return entry[lang] ?? entry[AppLanguage.id] ?? key;
}

/// Reactive widget that re-renders when language changes.
/// Use anywhere you'd normally use a Text() with a hardcoded string.
class T extends ConsumerWidget {
  final String tKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const T(
    this.tKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(preferencesProvider.select((p) => p.language));
    return Text(
      tr(tKey, lang),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
