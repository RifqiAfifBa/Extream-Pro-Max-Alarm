import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/alarm_model.dart';
import '../../data/repositories/alarm_repository.dart';

// Repository provider
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepository();
});

// Alarm list notifier
class AlarmNotifier extends StateNotifier<List<AlarmModel>> {
  final AlarmRepository _repo;

  AlarmNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() {
    state = _repo.getAllAlarms();
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    await _repo.addAlarm(alarm);
    _load();
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    await _repo.updateAlarm(alarm);
    _load();
  }

  Future<void> deleteAlarm(String id) async {
    await _repo.deleteAlarm(id);
    _load();
  }

  Future<void> toggleAlarm(String id) async {
    await _repo.toggleAlarm(id);
    _load();
  }
}

final alarmListProvider =
    StateNotifierProvider<AlarmNotifier, List<AlarmModel>>((ref) {
  final repo = ref.read(alarmRepositoryProvider);
  return AlarmNotifier(repo);
});

// Next alarm provider
final nextAlarmProvider = Provider<AlarmModel?>((ref) {
  final alarms = ref.watch(alarmListProvider);
  final enabled = alarms.where((a) => a.isEnabled).toList();
  if (enabled.isEmpty) return null;

  final now = DateTime.now();
  final nowMins = now.hour * 60 + now.minute;
  final today = (now.weekday + 6) % 7;

  AlarmModel? next;
  int minDiff = 999999;

  for (final alarm in enabled) {
    final alarmMins = alarm.hour * 60 + alarm.minute;

    if (alarm.repeatDays.isEmpty) {
      final diff = alarmMins - nowMins;
      if (diff > 0 && diff < minDiff) {
        minDiff = diff;
        next = alarm;
      }
      continue;
    }

    for (int offset = 0; offset < 7; offset++) {
      final day = (today + offset) % 7;
      if (!alarm.repeatDays.contains(day)) continue;

      int diff;
      if (offset == 0) {
        diff = alarmMins - nowMins;
        if (diff <= 0) continue;
      } else {
        diff = offset * 1440 + alarmMins - nowMins;
      }

      if (diff < minDiff) {
        minDiff = diff;
        next = alarm;
      }
    }
  }
  return next;
});

// Anti-cheat settings provider
class AntiCheatState {
  final bool masterEnabled;
  final bool detectForceClose;
  final bool alarmAfterReboot;
  final bool lockScreenMode;

  const AntiCheatState({
    this.masterEnabled = true,
    this.detectForceClose = true,
    this.alarmAfterReboot = true,
    this.lockScreenMode = false,
  });

  AntiCheatState copyWith({
    bool? masterEnabled,
    bool? detectForceClose,
    bool? alarmAfterReboot,
    bool? lockScreenMode,
  }) {
    return AntiCheatState(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      detectForceClose: detectForceClose ?? this.detectForceClose,
      alarmAfterReboot: alarmAfterReboot ?? this.alarmAfterReboot,
      lockScreenMode: lockScreenMode ?? this.lockScreenMode,
    );
  }
}

class AntiCheatNotifier extends StateNotifier<AntiCheatState> {
  AntiCheatNotifier() : super(const AntiCheatState());

  void toggle(String key) {
    switch (key) {
      case 'master':
        state = state.copyWith(masterEnabled: !state.masterEnabled);
        break;
      case 'forceClose':
        state = state.copyWith(detectForceClose: !state.detectForceClose);
        break;
      case 'reboot':
        state = state.copyWith(alarmAfterReboot: !state.alarmAfterReboot);
        break;
      case 'lockScreen':
        state = state.copyWith(lockScreenMode: !state.lockScreenMode);
        break;
    }
  }
}

final antiCheatProvider =
    StateNotifierProvider<AntiCheatNotifier, AntiCheatState>((ref) {
  return AntiCheatNotifier();
});

// Selected challenge for add alarm
final selectedChallengeProvider = StateProvider<int>((ref) => 0);
