# XAlarm — Production Readiness Update (Iterasi 6)

Iterasi besar untuk bikin app siap dipresentasikan ke dosen dengan kesan profesional.

## 🆕 Fitur baru

### Onboarding Flow (`/onboarding`)
PageView 4 slide yang muncul **pertama kali user buka app**:
1. **Bangun. Tanpa Alasan.** — value prop alarm anti-snooze
2. **Wake-up Challenge** — 4 jenis challenge (QR/Math/Word/Riddle)
3. **Anti-Cheat System** — proteksi force-close, mute detect, dll
4. **Lacak Pola Tidur** — analytics & streak

Fitur: skip button, step counter, dot indicator, gradient CTA. Splash auto-check first-launch dari `preferencesProvider`.

### Achievements / Pencapaian (`/achievements`)
Grid 8 badge dengan state locked/unlocked:
- **4 sudah terbuka**: Bangun Pertama, Konsisten 7 Hari, Anti Snooze, Speed Demon
- **4 masih terkunci** dengan progress bar: Konsisten 30 Hari (23%), Math Master (64%), Early Bird (30%), 100 Sukses (57%)

Tiap badge punya warna khas, ikon, deskripsi, dan tanggal unlock. Progress card di atas grid nunjukin total "4 dari 8" dengan progress bar.

Preview card di Profile screen ngarah ke screen ini.

### Privacy Policy (`/privacy`) & Terms of Service (`/tos`)
Konten **asli & komprehensif** (bukan placeholder):
- Privacy: 8 section — data yang dikumpulkan, izin sistem, cara data digunakan, hak user, keamanan, anak di bawah umur, perubahan kebijakan, kontak
- ToS: 10 section — penerimaan, penggunaan yang dibolehkan/dilarang, tanggung jawab user, IP, batasan tanggung jawab, perubahan layanan, penghentian, hukum, kontak
- Linked dari Settings → Bantuan & Tentang, dan dari Help Center

### Preferences Provider (Riverpod)
State global untuk semua user settings:
- isFirstLaunch (onboarding gate)
- notificationsEnabled
- alarmSoundId (6 sound catalog)
- snoozeMinutes (1/3/5/10/15)
- timeFormat (12h/24h)
- themeMode (dark active; light/system "coming soon")
- language (ID active; EN "coming soon")
- bedtimeReminderEnabled + hoursBeforeAlarm

## 🛠️ Settings — overhaul total

Settings di-rewrite ulang. Sekarang ada **5 section** terorganisir:

**ALARM**: Suara Alarm (picker 6 sound), Durasi Snooze, Format Waktu (12h/24h toggle), Getaran, Volume Bertahap

**NOTIFIKASI**: Aktifkan Notifikasi, Pengingat Tidur, Jam Sebelum Alarm

**KEAMANAN**: Anti-Cheat System (link), Lock Screen toggle

**TAMPILAN**: Tema (modal picker dark/light/system), Bahasa (modal picker ID/EN)

**BANTUAN & TENTANG**: Pusat Bantuan, Kebijakan Privasi, Syarat & Ketentuan, Versi Aplikasi

Plus Sign Out button.

## 🧹 Redundansi dibersihkan

### Profile (dirampingkan)
Sebelum: Edit Profile, Sleep Analytics, **Anti-Cheat Settings** ❌, **App Settings** ❌, **Help & Support** ❌, Sign Out

Setelah: Edit Profil, Analitik Tidur, **Pencapaian** (baru), Sign Out + card **preview Achievements**

Anti-Cheat / Settings / Help yang dihapus → tetap accessible via tab Settings.

### Settings (focused jadi app config)
Edit Profile dihapus dari sini (cuma di Profile sekarang). Sleep Analytics dihapus (cuma di Profile, karena itu data personal).

## 🎨 UX/UI fixes

- **Visual hint** badge "▶ Preview" di NEXT ALARM card — user tau bisa diklik
- **Empty state** alarm list: ikon glow + heading "Belum ada alarm" + CTA gradient "Buat Alarm Pertama"
- **Back button dihapus** dari tab Profile & Settings (tab gak biasa pakai back)
- **Bahasa konsisten**: Profile→Profil, My Alarms→Alarm Saya, Add→Tambah, READY→SIAP, RUNNING→BERJALAN, PAUSED→DIJEDA, Active Timers→Timer Aktif
- **Title Profile** sekarang "Profil" (Indonesia)
- **Splash** sekarang baca preferences — kalau first-launch → onboarding, kalau bukan → langsung login

## 🚧 Tier 3 — TIDAK dikerjain (butuh infrastructure)

Beberapa hal **sengaja di-skip** karena butuh native code atau backend server, tidak bisa dikerjakan via UI-only iteration:

1. **Authentication backend asli** (Firebase Auth / Supabase)
   - Login Google/Apple sekarang masih cosmetic (langsung navigate ke /alarm)
   - Buat implement: setup Firebase project, integrate firebase_auth package, replace UI login logic dengan AuthProvider

2. **Cloud sync** alarm antar device
   - Perlu backend (Firestore / Supabase database) + sync logic
   - Replace HiveStorage dengan repository pattern yang sync ke cloud

3. **Push notification OS-level**
   - Sekarang notif cuma snackbar dalam app
   - Buat implement: flutter_local_notifications + AndroidAlarmManager + iOS background modes

4. **Background alarm trigger**
   - Alarm harus jalan walau app close — butuh native Android Service / iOS background fetch
   - Package: android_alarm_manager_plus + iOS local notification scheduling

5. **Crashlytics & Analytics**
   - Add firebase_crashlytics + firebase_analytics packages
   - Setup di main.dart

6. **App icon production** & **native splash**
   - Generate dengan flutter_launcher_icons + flutter_native_splash
   - Butuh asset PNG icon 1024x1024

7. **Light theme** full implementation
   - Theme picker sudah ada di settings, tapi UI heavily dark-themed
   - Butuh rewrite color references di banyak custom widget

## 📦 File baru
- `lib/presentation/providers/preferences_provider.dart`
- `lib/presentation/screens/onboarding/onboarding_screen.dart`
- `lib/presentation/screens/legal/privacy_policy_screen.dart`
- `lib/presentation/screens/legal/terms_of_service_screen.dart`
- `lib/presentation/screens/achievements/achievements_screen.dart`

## ✏️ File modified
- `lib/core/router/app_router.dart` — +4 routes (onboarding/privacy/tos/achievements)
- `lib/presentation/screens/splash/splash_screen.dart` — first-launch routing logic
- `lib/presentation/screens/settings/settings_screen.dart` — total rewrite
- `lib/presentation/screens/profile/profile_screen.dart` — trim duplikat, add Achievements
- `lib/presentation/screens/home/home_screen.dart` — empty state + preview hint
- `lib/presentation/screens/help/help_support_screen.dart` — link ke privacy/tos asli
- `lib/presentation/screens/timer/timer_screen.dart` — language consistency

## 🚀 Cara test alur lengkap

1. `flutter clean && flutter pub get && flutter run -d chrome --web-port 8080`
2. **Splash → Onboarding** (4 slides, swipe atau tap Lanjut)
3. Setelah onboarding selesai → **Login**
4. Login → **Home** — coba tap NEXT ALARM (ada badge "▶ Preview")
5. **Tab Timer** → scroll bawah → lihat Pomodoro PATEN + Active Timers
6. **Tab Settings** → buka tiap section, coba Suara Alarm, Durasi Snooze, Format Waktu, Tema picker
7. **Tab Profile** → tap preview Achievements
8. Settings → Kebijakan Privasi / Syarat & Ketentuan → baca konten asli

## ⏪ Iterasi sebelumnya
- **Iterasi 5**: Pomodoro paten card di Active Timers
- **Iterasi 4**: Alarm Berbunyi (QR Scanner) + Active Timers + splash dots
- **Iterasi 3**: Edit Profile, Help & Support, Sign Out
- **Iterasi 2**: Match Figma design (splash, login, timer/stopwatch redesign)
- **Iterasi 1**: Timer & Stopwatch awal + back buttons

---

## Iterasi 7 — Loading effects & polish

### 🆕 PageLoader pada setiap navigasi
Setiap masuk halaman baru, **muncul 3-dot bounce loader (450ms)** lalu fade-in ke konten — sama persis dengan Figma splash style. Diterapkan ke 11 screen:

- Home (`Memuat alarm...`)
- Timer (`Menyiapkan timer...`)
- Settings (`Memuat pengaturan...`)
- Profile (`Memuat profil...`)
- Analytics (`Memuat statistik...`)
- Anti-Cheat (`Memuat keamanan...`)
- Edit Profile (`Memuat profil...`)
- Help & Support (`Memuat bantuan...`)
- Privacy Policy (`Memuat kebijakan...`)
- Terms of Service (`Memuat syarat...`)
- Achievements (`Memuat pencapaian...`)

Karena `ShellRoute` di router gak preserve state antar tab, **loader fire setiap kali user pindah tab** — sesuai keinginan ("setiap refresh halaman ada efek loading").

### 🆕 Shared widget `loading_indicators.dart`
- `XAlarmLoader` — 3-dot bounce reusable (configurable size, color, optional text)
- `PageLoader` — wrapper yang nampilin loader brief, lalu fade-in child

### 🆕 Haptic feedback
- Sign Out (Settings + Profile) → `HapticFeedback.mediumImpact()` saat dikonfirmasi
- Works on Android/iOS, no-op on web (gracefully)

### ✅ Semua toggle & picker sudah fungsional (iterasi sebelumnya)
- Getaran, Volume Bertahap, Lock Screen — wired ke prefs
- Theme picker — Dark/Light/Sistem semua bisa dipilih, Light Mode beneran kerja untuk Material widgets via `MaterialApp.themeMode`
- Language picker — Indonesia/English bisa dipilih

---

## Iterasi 8 — Language switching beneran kerja & button audit

### 🌐 Sistem terjemahan ID ↔ EN
- File baru `lib/core/i18n/translations.dart` dengan **~100 string** untuk 2 bahasa
- Helper `tr(key, lang)` + widget `T('key')` reaktif (auto-rebuild saat bahasa diganti)
- Pakai `ref.watch(preferencesProvider.select((p) => p.language))` jadi cuma rebuild widget yang dengerin language

### 📝 Screen yang diterjemahin (visible saat language change)
- **MainShell bottom nav**: Alarm/Timer/Settings/Profile
- **Splash**: tagline + Loading...
- **Login**: Welcome Back, Email, Password, Forgot, Sign In, OR, Sign Up
- **Onboarding**: 4 slides (title + description + badge), Lewati, Lanjut, Mulai Sekarang
- **Home**: Alarm Saya, + Tambah, empty state, Preview badge
- **Settings**: header, semua section labels (ALARM/NOTIFIKASI/KEAMANAN/TAMPILAN/BANTUAN), semua tile titles & subtitles, modal picker titles (Suara/Snooze/Tema/Bahasa), Sign Out dialog
- **Profile**: title, AKUN, menu items
- **Help & Support**: header
- **Achievements**: header

### 🔧 Dead buttons fixed
- **Forgot Password** (Login) — sebelumnya `onPressed: () {}` kosong → sekarang nampilin snackbar (translated)
- **Google / Apple login** — keep simulating successful OAuth (navigate ke /alarm)
- **Sign Up** — keep simulating successful registration
- **Edit Profile**: Save / Change Password / Delete Account — semua wired dengan dialog konfirmasi atau snackbar

### Penting tentang i18n
- String yang **panjang & jarang dibuka** (isi Privacy Policy, ToS, FAQ) **tetap Indonesia** untuk simplifikasi. Membatasi scope ke ~100 string visible (titles, buttons, tile labels) bikin app **berasa beneran multilingual** tanpa overhead translate ribuan baris.
- Saat user ganti bahasa, widget yang dengerin akan rebuild **instant** (gak perlu restart app)

---

## Hotfix — `const_eval_method_invocation` (10 errors)

**Masalah:** Pas string literal diganti `tr('key', lang)`, beberapa widget masih punya keyword `const`. Dart gak ngebolehin method call (`tr()`) di dalam `const` expression → 10 compile error.

**Fix:** Script otomatis nyari setiap `const Widget(...)` / `const [...]` yang subtree-nya mengandung `tr(`, lalu hapus keyword `const`-nya. Total **10 const dihapus** di 6 file:
- profile_screen.dart (2), home_screen.dart (4), settings_screen.dart (1), login_screen.dart (1), achievements_screen.dart (1), onboarding_screen.dart (1)

Sisanya (warning `withOpacity is deprecated`) cuma **info-level**, bukan error — app tetap jalan. Itu karena Flutter versi baru nyaranin `.withValues(alpha:)` ganti `.withOpacity()`, tapi `withOpacity` masih fully functional.
