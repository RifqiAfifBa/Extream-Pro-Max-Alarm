import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/alarm_model.dart';

class AlarmService {
  static const String _alarmsKey = 'alarms';
  static const String _userKey = 'user';
  static const String _timersKey = 'timers';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== ALARM OPERATIONS ==========

  Future<List<Alarm>> getAlarms() async {
    final jsonString = _prefs.getString(_alarmsKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Alarm.fromJson(json)).toList();
    } catch (e) {
      print('Error loading alarms: $e');
      return [];
    }
  }

  Future<void> saveAlarms(List<Alarm> alarms) async {
    final jsonList = alarms.map((alarm) => alarm.toJson()).toList();
    await _prefs.setString(_alarmsKey, jsonEncode(jsonList));
  }

  Future<void> addAlarm(Alarm alarm) async {
    final alarms = await getAlarms();
    alarms.add(alarm);
    await saveAlarms(alarms);
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final alarms = await getAlarms();
    final index = alarms.indexWhere((a) => a.id == alarm.id);
    if (index != -1) {
      alarms[index] = alarm;
      await saveAlarms(alarms);
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    final alarms = await getAlarms();
    alarms.removeWhere((a) => a.id == alarmId);
    await saveAlarms(alarms);
  }

  Future<void> toggleAlarmActive(String alarmId) async {
    final alarms = await getAlarms();
    final index = alarms.indexWhere((a) => a.id == alarmId);
    if (index != -1) {
      final alarm = alarms[index];
      alarms[index] = alarm.copyWith(isActive: !alarm.isActive);
      await saveAlarms(alarms);
    }
  }

  Future<Alarm?> getAlarmById(String alarmId) async {
    final alarms = await getAlarms();
    try {
      return alarms.firstWhere((a) => a.id == alarmId);
    } catch (e) {
      return null;
    }
  }

  // Get next alarm that will ring
  Future<Alarm?> getNextAlarm() async {
    final alarms = await getAlarms();
    final activeAlarms = alarms.where((a) => a.isActive).toList();

    if (activeAlarms.isEmpty) return null;

    final now = DateTime.now();
    activeAlarms.sort((a, b) {
      final aDiff = _getDurationUntilAlarm(a, now);
      final bDiff = _getDurationUntilAlarm(b, now);
      return aDiff.compareTo(bDiff);
    });

    return activeAlarms.first;
  }

  // ========== TIMER OPERATIONS ==========

  Future<List<Timer>> getTimers() async {
    final jsonString = _prefs.getString(_timersKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) {
        return Timer(
          id: json['id'],
          duration: Duration(seconds: json['durationSeconds']),
          label: json['label'],
          startTime: DateTime.parse(json['startTime']),
          isRunning: json['isRunning'],
          pausedAt: json['pausedAt'] != null
              ? DateTime.parse(json['pausedAt'])
              : null,
        );
      }).toList();
    } catch (e) {
      print('Error loading timers: $e');
      return [];
    }
  }

  Future<void> saveTimers(List<Timer> timers) async {
    final jsonList = timers.map((timer) {
      return {
        'id': timer.id,
        'durationSeconds': timer.duration.inSeconds,
        'label': timer.label,
        'startTime': timer.startTime.toIso8601String(),
        'isRunning': timer.isRunning,
        'pausedAt': timer.pausedAt?.toIso8601String(),
      };
    }).toList();
    await _prefs.setString(_timersKey, jsonEncode(jsonList));
  }

  Future<void> addTimer(Timer timer) async {
    final timers = await getTimers();
    timers.add(timer);
    await saveTimers(timers);
  }

  Future<void> updateTimer(Timer timer) async {
    final timers = await getTimers();
    final index = timers.indexWhere((t) => t.id == timer.id);
    if (index != -1) {
      timers[index] = timer;
      await saveTimers(timers);
    }
  }

  Future<void> deleteTimer(String timerId) async {
    final timers = await getTimers();
    timers.removeWhere((t) => t.id == timerId);
    await saveTimers(timers);
  }

  // ========== USER OPERATIONS ==========

  Future<User?> getUser() async {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString == null) return null;

    try {
      return User.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // ========== HELPER METHODS ==========

  Duration _getDurationUntilAlarm(Alarm alarm, DateTime now) {
    var alarmTime = alarm.time;

    // If today's alarm time has passed, check for next occurrence
    if (alarmTime.hour < now.hour ||
        (alarmTime.hour == now.hour && alarmTime.minute < now.minute)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    return alarmTime.difference(now);
  }

  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
