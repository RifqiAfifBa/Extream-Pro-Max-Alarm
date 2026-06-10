import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/alarm_model.dart';

class AlarmRepository {
  static const String _boxName = 'alarms';
  late Box<AlarmModel> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    _box = await Hive.openBox<AlarmModel>(_boxName);
    // Seed with sample data if empty
    if (_box.isEmpty) {
      await _seedSampleAlarms();
    }
  }

  Future<void> _seedSampleAlarms() async {
    final alarms = [
      AlarmModel(
        id: _uuid.v4(),
        hour: 6,
        minute: 30,
        label: 'Morning Wake',
        isEnabled: true,
        repeatDays: [0, 1, 2, 3, 4],
        challengeIndex: 0,
        allowSnooze: true,
      ),
      AlarmModel(
        id: _uuid.v4(),
        hour: 8,
        minute: 0,
        label: 'Gym Time',
        isEnabled: true,
        repeatDays: [0, 1, 2, 3, 4, 5, 6],
        challengeIndex: 1,
        allowSnooze: false,
      ),
      AlarmModel(
        id: _uuid.v4(),
        hour: 22,
        minute: 0,
        label: 'Night Reminder',
        isEnabled: false,
        repeatDays: [5, 6],
        challengeIndex: 3,
        allowSnooze: true,
      ),
    ];
    for (final alarm in alarms) {
      await _box.put(alarm.id, alarm);
    }
  }

  List<AlarmModel> getAllAlarms() {
    final alarms = _box.values.toList();
    alarms.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return alarms;
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    await _box.put(alarm.id, alarm);
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    await _box.put(alarm.id, alarm);
  }

  Future<void> deleteAlarm(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleAlarm(String id) async {
    final alarm = _box.get(id);
    if (alarm != null) {
      alarm.isEnabled = !alarm.isEnabled;
      await alarm.save();
    }
  }

  String generateId() => _uuid.v4();
}
