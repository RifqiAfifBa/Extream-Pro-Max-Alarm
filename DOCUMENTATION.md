# XAlarm - Extreme Pro Max Alarm App

## 🎯 Overview

XAlarm adalah aplikasi alarm profesional yang dibangun dengan Flutter, menawarkan pengalaman pengguna yang modern dan intuitif dengan berbagai fitur canggih untuk manajemen alarm, timer, dan stopwatch.

## ✨ Fitur Utama

### 1. **Alarm Management**

- ✅ Buat alarm baru dengan waktu yang fleksibel
- ✅ Edit alarm yang sudah ada
- ✅ Hapus alarm dengan konfirmasi
- ✅ Toggle status aktif/nonaktif
- ✅ Opsi pengulangan (Never, Daily, Weekdays, Weekends, Custom)
- ✅ Pengaturan label alarm custom
- ✅ Kontrol vibration dan sound
- ✅ Tampilan list alarm terorganisir

### 2. **Alarm Challenges** (Solusi Inovatif untuk Snooze Prevention)

- **QR Code Scan**: Pengguna harus scan QR code untuk mematikan alarm
- **Math Challenge**: Selesaikan soal matematika sederhana
- **Word Arrange**: Urutkan kata-kata dalam urutan yang benar
- **No Challenge**: Mode normal tanpa challenge (default)

### 3. **Timer**

- ⏱️ Set timer dengan durasi custom (jam, menit, detik)
- ⏱️ Play/Pause/Reset controls
- ⏱️ Notifikasi ketika timer selesai
- ⏱️ Display waktu real-time yang akurat

### 4. **Stopwatch**

- ⏸️ Start/Pause/Reset functionality
- ⏸️ Tracking waktu dalam jam, menit, detik
- ⏸️ Display real-time yang smooth

### 5. **User Authentication**

- 🔐 Login screen dengan validasi email
- 🔐 Display nama user di home screen
- 🔐 Logout functionality
- 🔐 User data persistence

### 6. **Data Persistence**

- 💾 LocalStorage menggunakan SharedPreferences
- 💾 Automatic save untuk semua alarm
- 💾 Restore data saat app dibuka kembali
- 💾 User session management

## 📁 Project Structure

```
lib/
├── main.dart                          # Entry point, routing, splash screen
├── models/
│   └── alarm_model.dart              # Data models (Alarm, Timer, User)
├── services/
│   └── alarm_service.dart            # Business logic & LocalStorage
├── providers/
│   └── alarm_provider.dart           # State management (ChangeNotifier)
├── screens/
│   ├── login_screen.dart             # Authentication screen
│   ├── alarm_list_screen.dart        # Main alarm list & tab navigation
│   ├── create_alarm_screen.dart      # Create/Edit alarm screen
│   ├── timer_screen.dart             # Timer & Stopwatch screen
│   └── challenge_screens.dart        # QR, Math, WordArrange challenges
└── tokens.dart                        # Design tokens & constants
```

## 🎨 Design System

### Colors

- **Primary**: `#4F6BFF` (Blue)
- **Secondary**: `#FF6B9D` (Pink/Red)
- **Background**: `#0D0F14` (Dark)
- **Surface**: `#1A1D26` (Card)

### Typography

- **Large**: 32px, Bold (Titles)
- **Medium**: 18px, Bold (Headers)
- **Normal**: 14-16px (Body)
- **Small**: 12px (Captions)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.11.1)
- Dart SDK
- Android Studio or Xcode (untuk testing di device)

### Installation

```bash
# 1. Clone or navigate to project
cd "d:\Kuliah Semester 6\Pemprograman Mobile\Extream Pro Max Alarm\Alarm"

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Dependencies

```yaml
provider: ^6.0.0 # State management
shared_preferences: ^2.2.0 # Local storage
uuid: ^4.0.0 # Unique ID generation
intl: ^0.19.0 # Internationalization
```

## 📱 Screen Flow

```
Splash Screen
    ↓
Login Screen → [User enters email & password]
    ↓
Alarm List Screen
    ├── Alarms Tab
    │   ├── List of alarms with toggle
    │   ├── FAB → Create Alarm Screen
    │   └── Edit/Delete options
    ├── Timer Tab
    │   └── Navigate to Timer Screen
    └── Stopwatch Tab
        └── Navigate to Timer Screen

Create/Edit Alarm Screen
    ├── Time Picker
    ├── Label Input
    ├── Repeat Selection
    ├── Challenge Type Selection
    └── Save/Update Button

Timer Screen
    ├── Timer Tab
    │   ├── Duration Input (H:M:S)
    │   ├── Play/Pause/Reset
    │   └── Finished Dialog
    └── Stopwatch Tab
        ├── Play/Pause/Reset
        └── Real-time Display
```

## 🔧 Key Classes & Methods

### Alarm Model

```dart
class Alarm {
  final String id;
  final DateTime time;
  final String label;
  final bool isActive;
  final AlarmRepeat repeat;
  final List<int> repeatDays;
  final String sound;
  final bool vibration;
  final ChallengeType challengeType;

  // Methods
  String getTimeString()
  TimeOfDay getTimeOfDay()
  Alarm copyWith(...)
  Map<String, dynamic> toJson()
  factory Alarm.fromJson(Map<String, dynamic> json)
}
```

### AlarmService

```dart
class AlarmService {
  Future<void> init()
  Future<List<Alarm>> getAlarms()
  Future<void> saveAlarms(List<Alarm> alarms)
  Future<void> addAlarm(Alarm alarm)
  Future<void> updateAlarm(Alarm alarm)
  Future<void> deleteAlarm(String alarmId)
  Future<void> toggleAlarmActive(String alarmId)
  // ... timer & user methods
}
```

### AlarmProvider

```dart
class AlarmProvider extends ChangeNotifier {
  Future<void> init()
  Future<void> loadAlarms()
  Future<void> addAlarm(Alarm alarm)
  Future<void> updateAlarm(Alarm alarm)
  Future<void> deleteAlarm(String alarmId)
  // ... semua method untuk state management
}
```

## 💡 Usage Examples

### Create New Alarm

```dart
final alarm = Alarm(
  id: const Uuid().v4(),
  time: DateTime(2024, 5, 16, 7, 30),
  label: 'Wake up',
  isActive: true,
  repeat: AlarmRepeat.daily,
  challengeType: ChallengeType.mathChallenge,
  createdAt: DateTime.now(),
);

await provider.addAlarm(alarm);
```

### Toggle Alarm Active

```dart
await provider.toggleAlarmActive(alarmId);
```

### Start Timer

```dart
final timer = Timer(
  id: const Uuid().v4(),
  duration: Duration(minutes: 5),
  label: 'Workout',
  startTime: DateTime.now(),
  isRunning: true,
);

await provider.addTimer(timer);
```

## 🎮 Features in Action

### Login Flow

1. Aplikasi membuka splash screen
2. User navigate ke login screen
3. Input email dan password
4. Data disimpan di SharedPreferences
5. Navigate ke alarm list screen

### Create Alarm

1. User tap FAB di Alarm List Screen
2. Open Create Alarm Screen
3. Select time (tap time display)
4. Enter alarm label
5. Select repeat pattern
6. Select challenge type
7. Toggle vibration/sound
8. Tap "Create Alarm" button
9. Alarm ditambahkan ke list

### Use Timer

1. User navigate ke Timer tab
2. Select Timer sub-tab
3. Input jam, menit, detik
4. Tap "Start"
5. Timer akan countdown
6. Saat selesai, dialog notification muncul
7. User bisa reset atau create timer baru

### Solve Math Challenge

1. Alarm goes off dengan math challenge
2. Sistem menampilkan soal (e.g., "15 + 23 = ?")
3. User input jawaban
4. Submit → cek jawaban
5. Jika benar, alarm mati
6. Jika salah, user harus coba lagi

## 🔔 Future Enhancements

- [ ] Actual alarm notifications dengan notification package
- [ ] Integrasi dengan backend API untuk sync
- [ ] Cloud backup untuk data
- [ ] Custom alarm sounds
- [ ] Sleep tracking dengan wearables
- [ ] Advanced analytics & statistics
- [ ] Dark/Light theme toggle
- [ ] Multi-language support
- [ ] Actual QR code scanning dengan camera
- [ ] Real alarm sound playback

## 🛠️ Development Notes

### State Management

Aplikasi menggunakan **Provider** pattern dengan `ChangeNotifier` untuk state management yang sederhana dan efficient.

### Local Storage

Menggunakan **SharedPreferences** untuk menyimpan:

- List of alarms (JSON)
- Active timers (JSON)
- User information

### Architecture

Project mengikuti **Clean Architecture** dengan separation of concerns:

- **Models**: Data structures
- **Services**: Business logic & storage
- **Providers**: State management
- **Screens**: UI Layer

## 📝 License

This project is open source and available under the MIT License.

## 👨‍💻 Contributing

Contributions are welcome! Feel free to submit issues and enhancement requests.

## 📞 Support

Untuk pertanyaan atau bug reports, silakan buat issue di repository.

---

**Built with Flutter 💙 | Made with ❤️**
