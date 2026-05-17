import 'package:intl/intl.dart';

enum AlarmRepeat { never, daily, weekdays, weekends, custom }

enum ChallengeType { qrScan, mathChallenge, wordArrange, none }

class Alarm {
  final String id;
  final DateTime time;
  final String label;
  final bool isActive;
  final AlarmRepeat repeat;
  final List<int> repeatDays; // 0-6 (Sunday-Saturday)
  final String sound;
  final bool vibration;
  final ChallengeType challengeType;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  Alarm({
    required this.id,
    required this.time,
    required this.label,
    required this.isActive,
    this.repeat = AlarmRepeat.never,
    this.repeatDays = const [],
    this.sound = 'default',
    this.vibration = true,
    this.challengeType = ChallengeType.none,
    required this.createdAt,
    this.modifiedAt,
  });

  // Get time string in HH:MM format
  String getTimeString() {
    return DateFormat('HH:mm').format(time);
  }

  // Get time in 24-hour format for time picker
  TimeOfDay getTimeOfDay() {
    return TimeOfDay(hour: time.hour, minute: time.minute);
  }

  // Copy with modifications
  Alarm copyWith({
    String? id,
    DateTime? time,
    String? label,
    bool? isActive,
    AlarmRepeat? repeat,
    List<int>? repeatDays,
    String? sound,
    bool? vibration,
    ChallengeType? challengeType,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
      repeat: repeat ?? this.repeat,
      repeatDays: repeatDays ?? this.repeatDays,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      challengeType: challengeType ?? this.challengeType,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'label': label,
      'isActive': isActive,
      'repeat': repeat.toString(),
      'repeatDays': repeatDays,
      'sound': sound,
      'vibration': vibration,
      'challengeType': challengeType.toString(),
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] ?? '',
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
      label: json['label'] ?? 'Alarm',
      isActive: json['isActive'] ?? true,
      repeat: AlarmRepeat.values.firstWhere(
        (e) => e.toString() == json['repeat'],
        orElse: () => AlarmRepeat.never,
      ),
      repeatDays: List<int>.from(json['repeatDays'] ?? []),
      sound: json['sound'] ?? 'default',
      vibration: json['vibration'] ?? true,
      challengeType: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['challengeType'],
        orElse: () => ChallengeType.none,
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'])
          : null,
    );
  }
}

class Timer {
  final String id;
  final Duration duration;
  final String label;
  final DateTime startTime;
  final bool isRunning;
  final DateTime? pausedAt;

  Timer({
    required this.id,
    required this.duration,
    required this.label,
    required this.startTime,
    this.isRunning = false,
    this.pausedAt,
  });

  Duration getRemainingTime() {
    if (pausedAt != null) {
      final elapsed = pausedAt!.difference(startTime);
      return duration - elapsed;
    } else if (isRunning) {
      final elapsed = DateTime.now().difference(startTime);
      final remaining = duration - elapsed;
      return remaining.isNegative ? Duration.zero : remaining;
    }
    return duration;
  }

  String getDisplayTime() {
    final remaining = getRemainingTime();
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class User {
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
