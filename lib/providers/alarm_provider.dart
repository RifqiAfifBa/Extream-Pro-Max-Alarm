import 'package:flutter/foundation.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';

class AlarmProvider extends ChangeNotifier {
  final AlarmService _alarmService;

  List<Alarm> _alarms = [];
  List<Timer> _timers = [];
  User? _user;
  bool _isLoading = false;
  String? _error;

  AlarmProvider(this._alarmService);

  // Getters
  List<Alarm> get alarms => _alarms;
  List<Timer> get timers => _timers;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize
  Future<void> init() async {
    _setLoading(true);
    try {
      await _alarmService.init();
      await loadAlarms();
      await loadUser();
      _setLoading(false);
    } catch (e) {
      _setError('Error initializing: $e');
      _setLoading(false);
    }
  }

  // ========== ALARM METHODS ==========

  Future<void> loadAlarms() async {
    try {
      _alarms = await _alarmService.getAlarms();
      _alarms.sort((a, b) => a.time.compareTo(b.time));
      notifyListeners();
    } catch (e) {
      _setError('Error loading alarms: $e');
    }
  }

  Future<void> addAlarm(Alarm alarm) async {
    try {
      await _alarmService.addAlarm(alarm);
      await loadAlarms();
      _clearError();
    } catch (e) {
      _setError('Error adding alarm: $e');
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    try {
      await _alarmService.updateAlarm(alarm);
      await loadAlarms();
      _clearError();
    } catch (e) {
      _setError('Error updating alarm: $e');
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    try {
      await _alarmService.deleteAlarm(alarmId);
      await loadAlarms();
      _clearError();
    } catch (e) {
      _setError('Error deleting alarm: $e');
    }
  }

  Future<void> toggleAlarmActive(String alarmId) async {
    try {
      await _alarmService.toggleAlarmActive(alarmId);
      await loadAlarms();
      _clearError();
    } catch (e) {
      _setError('Error toggling alarm: $e');
    }
  }

  Future<Alarm?> getAlarmById(String alarmId) async {
    return await _alarmService.getAlarmById(alarmId);
  }

  Future<Alarm?> getNextAlarm() async {
    return await _alarmService.getNextAlarm();
  }

  // ========== TIMER METHODS ==========

  Future<void> loadTimers() async {
    try {
      _timers = await _alarmService.getTimers();
      notifyListeners();
    } catch (e) {
      _setError('Error loading timers: $e');
    }
  }

  Future<void> addTimer(Timer timer) async {
    try {
      await _alarmService.addTimer(timer);
      await loadTimers();
      _clearError();
    } catch (e) {
      _setError('Error adding timer: $e');
    }
  }

  Future<void> updateTimer(Timer timer) async {
    try {
      await _alarmService.updateTimer(timer);
      notifyListeners();
      _clearError();
    } catch (e) {
      _setError('Error updating timer: $e');
    }
  }

  Future<void> deleteTimer(String timerId) async {
    try {
      await _alarmService.deleteTimer(timerId);
      await loadTimers();
      _clearError();
    } catch (e) {
      _setError('Error deleting timer: $e');
    }
  }

  // ========== USER METHODS ==========

  Future<void> loadUser() async {
    try {
      _user = await _alarmService.getUser();
      notifyListeners();
    } catch (e) {
      _setError('Error loading user: $e');
    }
  }

  Future<void> setUser(User user) async {
    try {
      await _alarmService.saveUser(user);
      _user = user;
      notifyListeners();
      _clearError();
    } catch (e) {
      _setError('Error setting user: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _alarmService.clearUser();
      _user = null;
      notifyListeners();
      _clearError();
    } catch (e) {
      _setError('Error logging out: $e');
    }
  }

  // ========== HELPER METHODS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> clearAllData() async {
    try {
      await _alarmService.clearAllData();
      _alarms = [];
      _timers = [];
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Error clearing data: $e');
    }
  }
}
