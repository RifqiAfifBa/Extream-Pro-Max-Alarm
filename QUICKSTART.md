# 🚀 XAlarm - Quick Start Guide

## Selamat datang di XAlarm!

Aplikasi alarm profesional yang dibangun dari Figma design dengan semua fitur lengkap dan siap pakai.

---

## ⚡ Setup Cepat (5 menit)

### Step 1: Persiapkan Environment

```bash
# Pastikan Flutter sudah terinstall
flutter --version

# Update Flutter (optional)
flutter upgrade
```

### Step 2: Navigasi ke Project

```bash
cd "d:\Kuliah Semester 6\Pemprograman Mobile\Extream Pro Max Alarm\Alarm"
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

Tunggu sampai semua packages terinstall ✓

### Step 4: Jalankan Aplikasi

```bash
# Di device/emulator Android
flutter run

# Atau di iOS device
flutter run -d [device-id]

# List available devices
flutter devices
```

---

## 🎮 Pertama Kali Menggunakan

### 1️⃣ Login Screen

- Masukkan email apapun (misal: `user@example.com`)
- Masukkan password apapun
- Tap "Sign In"
- ✅ Anda akan masuk ke Alarm List Screen

### 2️⃣ Buat Alarm Pertama

1. Tap tombol **"+"** (FAB) di pojok kanan bawah
2. **Set Time**: Tap time display → select jam & menit
3. **Label**: Ketik nama alarm (misal "Wake up")
4. **Repeat**: Pilih pola pengulangan (pilih "Daily" untuk contoh)
5. **Challenge**: Pilih challenge type:
   - "No Challenge" = alarm normal
   - "Math Challenge" = harus jawab soal
   - "QR Code Scan" = harus scan QR
   - "Word Arrange" = urutkan kata
6. **Options**: Toggle vibration jika mau
7. Tap **"Create Alarm"** ✅

### 3️⃣ Lihat Alarm di List

- Semua alarm akan muncul di Alarms tab
- Toggle switch untuk ON/OFF alarm
- Edit button (pensil) untuk ubah
- Delete button (tempat sampah) untuk hapus

### 4️⃣ Gunakan Timer

1. Tap tab **"Timer"** di Alarm List Screen
2. Select "Timer" sub-tab
3. Input durasi (jam:menit:detik)
4. Tap **"Start"**
5. Tunggu countdown selesai
6. Notifikasi akan muncul ✅

### 5️⃣ Gunakan Stopwatch

1. Di Alarm List Screen, tap "Stopwatch" tab
2. Select "Stopwatch" sub-tab
3. Tap **"Start"** untuk mulai tracking
4. Tap **"Pause"** untuk jeda
5. Tap **"Reset"** untuk reset ke 0:0:0

---

## 🎯 Fitur Utama

### ✅ Alarm Management

```
✓ Create alarm dengan time picker
✓ Edit alarm yang sudah ada
✓ Delete alarm
✓ Toggle active/inactive
✓ Pilih repeat pattern (Never, Daily, Weekdays, dll)
✓ Pilih challenge type untuk unlock alarm
✓ Control vibration & sound
```

### ✅ Alarm Challenges

```
1. No Challenge → Alarm normal biasa
2. QR Code Scan → Scan QR untuk matikan
3. Math Challenge → Jawab soal matematika
4. Word Arrange → Urutkan kata dalam urutan benar
```

### ✅ Timer & Stopwatch

```
✓ Set custom duration (0-99 jam:menit:detik)
✓ Real-time countdown dengan akurasi tinggi
✓ Play/Pause/Reset controls yang mudah
✓ Auto-stop dan notifikasi saat selesai
✓ Stopwatch untuk tracking waktu unlimited
```

### ✅ User Management

```
✓ Login dengan email
✓ Data otomatis tersimpan
✓ Logout functionality
✓ User greeting di home screen
```

---

## 🔧 Development Tips

### Rebuild Cache

Jika ada error atau UI tidak muncul:

```bash
flutter clean
flutter pub get
flutter run
```

### Run dengan Release Mode

Untuk performance lebih baik:

```bash
flutter run --release
```

### Debug Print

Untuk development, kamu bisa tambah debug prints:

```dart
print('Debug: $variable');
```

### Hot Reload

Saat ngembang, press `r` di terminal untuk hot reload (update tanpa restart):

```
flutter run
> r   # Hot reload
> R   # Full restart
> q   # Quit
```

---

## 📁 Project Structure Quick Reference

```
lib/
├── main.dart                 ← Entry point, routes
├── models/alarm_model.dart   ← Data structures
├── services/alarm_service.dart ← Business logic
├── providers/alarm_provider.dart ← State management
└── screens/
    ├── login_screen.dart
    ├── alarm_list_screen.dart
    ├── create_alarm_screen.dart
    ├── timer_screen.dart
    └── challenge_screens.dart
```

---

## 🎨 Customize Appearance

### Ubah Warna Primary

Edit `lib/main.dart` line ~25:

```dart
colorScheme: ColorScheme.dark(
  primary: Color(0xFF4F6BFF),  // ← ubah hex color di sini
  // ...
)
```

### Ubah Nama App

Edit `lib/main.dart` line ~20:

```dart
title: 'XAlarm - Extreme Pro Max',  // ← ubah di sini
```

---

## 🐛 Common Issues & Solutions

### ❌ "SharedPreferences not initialized"

**Solusi**: Pastikan `main()` function memiliki `WidgetsFlutterBinding.ensureInitialized()` sebelum `runApp()`

### ❌ "Provider not found"

**Solusi**: Wrap MaterialApp dengan `MultiProvider` dan pastikan `AlarmProvider` didaftarkan

### ❌ "Time picker tidak muncul"

**Solusi**: Pastikan device/emulator sudah support Material Time Picker (sudah support di semua Flutter version)

### ❌ "Data hilang saat close app"

**Solusi**: Data disimpan otomatis di SharedPreferences. Cek `SharedPreferences` key di `alarm_service.dart`

---

## 📚 Belajar Lebih Lanjut

### Dokumentasi Lengkap

Buka file `DOCUMENTATION.md` untuk:

- API Reference
- Architecture explanation
- Future enhancements
- Contributing guide

### Flutter Docs

- [Flutter Official Docs](https://docs.flutter.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

---

## ✨ Selanjutnya?

### Fitur yang bisa ditambah:

1. **Real Alarm Notifications** → Gunakan `flutter_local_notifications`
2. **Backend API** → Integrasi dengan Firebase/Supabase
3. **Custom Sounds** → Tambah library audio player
4. **Sleep Tracking** → Integrasi dengan health sensors
5. **Social Features** → Share alarm patterns dengan teman

### Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

---

## 🎓 Learning Points

Dari project ini, kamu belajar:

- ✅ State management dengan Provider
- ✅ Local data persistence dengan SharedPreferences
- ✅ Navigation & routing di Flutter
- ✅ Form handling & validation
- ✅ Time/Date manipulation
- ✅ UI best practices
- ✅ Responsive design

---

## 📞 Butuh Bantuan?

1. Cek `DOCUMENTATION.md` untuk detail lengkap
2. Lihat komentar di code (banyak penjelasan)
3. Print debug output untuk troubleshoot
4. Baca error message dengan teliti

---

## 🎉 Selamat Menggunakan XAlarm!

Semoga project ini membantu Anda dalam belajar Flutter development! 🚀

**Happy Coding!** 💻

---

**Last Updated**: May 16, 2026
**Built with**: Flutter + Provider + SharedPreferences
**Designed from**: Figma UI Design
