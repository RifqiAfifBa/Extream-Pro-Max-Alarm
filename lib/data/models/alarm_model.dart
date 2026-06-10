// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

enum ChallengeType { qrScan, math, wordArrange, riddle, none }

enum RepeatDay { mon, tue, wed, thu, fri, sat, sun }

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int hour;

  @HiveField(2)
  int minute;

  @HiveField(3)
  String label;

  @HiveField(4)
  bool isEnabled;

  @HiveField(5)
  List<int> repeatDays; // 0=Mon ... 6=Sun

  @HiveField(6)
  int challengeIndex; // ChallengeType index

  @HiveField(7)
  bool allowSnooze;

  @HiveField(8)
  bool isAntiCheatEnabled;

  @HiveField(9)
  String qrSecret;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    this.label = '',
    this.isEnabled = true,
    this.repeatDays = const [],
    this.challengeIndex = 0,
    this.allowSnooze = true,
    this.isAntiCheatEnabled = false,
    this.qrSecret = '',
  });

  ChallengeType get challengeType => ChallengeType.values[challengeIndex.clamp(0, ChallengeType.values.length - 1)];

  String get formattedTime {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get amPm => hour < 12 ? 'AM' : 'PM';

  String get formattedTime24 {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get repeatLabel {
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Daily';
    final weekdays = [0, 1, 2, 3, 4];
    final weekend = [5, 6];
    if (weekdays.every((d) => repeatDays.contains(d)) &&
        !repeatDays.any((d) => weekend.contains(d))) return 'Mon-Fri';
    if (weekend.every((d) => repeatDays.contains(d)) &&
        !repeatDays.any((d) => weekdays.contains(d))) return 'Weekend';
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return repeatDays.map((d) => dayNames[d]).join(', ');
  }

  String get challengeLabel {
    switch (challengeType) {
      case ChallengeType.qrScan:
        return 'QR Scan';
      case ChallengeType.math:
        return 'Math Challenge';
      case ChallengeType.wordArrange:
        return 'Word Arrange';
      case ChallengeType.riddle:
        return 'Riddle';
      case ChallengeType.none:
        return 'None';
    }
  }

  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    String? label,
    bool? isEnabled,
    List<int>? repeatDays,
    int? challengeIndex,
    bool? allowSnooze,
    bool? isAntiCheatEnabled,
    String? qrSecret,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
      challengeIndex: challengeIndex ?? this.challengeIndex,
      allowSnooze: allowSnooze ?? this.allowSnooze,
      isAntiCheatEnabled: isAntiCheatEnabled ?? this.isAntiCheatEnabled,
      qrSecret: qrSecret ?? this.qrSecret,
    );
  }
}
