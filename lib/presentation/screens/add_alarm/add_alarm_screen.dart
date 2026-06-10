import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alarm_model.dart';
import '../../providers/alarm_providers.dart';

class AddAlarmScreen extends ConsumerStatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  ConsumerState<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends ConsumerState<AddAlarmScreen> {
  int _selectedHour = 6;
  int _selectedMinute = 0;
  bool _isAM = true;
  String _label = 'Morning Wake';
  List<int> _repeatDays = [0, 1, 2, 3, 4];
  int _challengeIndex = 0;
  bool _allowSnooze = true;
  bool _isEditing = false;
  String? _editingId;
  String _qrSecret = '';

  final _labelController = TextEditingController(text: 'Morning Wake');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editingId != null) return;
    final alarm = GoRouterState.of(context).extra as AlarmModel?;
    if (alarm == null) return;

    setState(() {
      _isEditing = true;
      _editingId = alarm.id;
      _isAM = alarm.hour < 12;
      _selectedHour = alarm.hour == 0
          ? 12
          : (alarm.hour > 12 ? alarm.hour - 12 : alarm.hour);
      _selectedMinute = alarm.minute;
      _label = alarm.label;
      _repeatDays = [...alarm.repeatDays];
      _challengeIndex = alarm.challengeIndex;
      _allowSnooze = alarm.allowSnooze;
      _labelController.text = alarm.label;
      _qrSecret = alarm.qrSecret;
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  String get _repeatLabel {
    if (_repeatDays.isEmpty) return 'Once';
    if (_repeatDays.length == 7) return 'Every day';
    final weekdays = [0, 1, 2, 3, 4];
    if (weekdays.every((d) => _repeatDays.contains(d)) && _repeatDays.length == 5) {
      return 'Mon-Fri';
    }
    if (_repeatDays.length == 2 && _repeatDays.contains(5) && _repeatDays.contains(6)) {
      return 'Weekend';
    }
    return 'Custom';
  }

  String get _challengeLabel {
    switch (_challengeIndex) {
      case 0: return 'QR Scan';
      case 1: return 'Math Challenge';
      case 2: return 'Word Arrange';
      case 3: return 'Riddle';
      default: return 'None';
    }
  }

  IconData get _challengeIcon {
    switch (_challengeIndex) {
      case 0: return Icons.qr_code_scanner_rounded;
      case 1: return Icons.calculate_outlined;
      case 2: return Icons.text_fields_rounded;
      case 3: return Icons.extension_outlined;
      default: return Icons.alarm;
    }
  }

  String get _challengeDesc {
    switch (_challengeIndex) {
      case 0: return 'Scan QR from email to dismiss';
      case 1: return 'Solve equations to dismiss';
      case 2: return 'Rearrange words into sentence';
      case 3: return 'Solve a riddle to stop alarm';
      default: return 'No challenge';
    }
  }

  void _save() {
    final hour24 = _isAM ? _selectedHour % 12 : (_selectedHour % 12) + 12;
    final secret = _qrSecret.isEmpty ? const Uuid().v4() : _qrSecret;
    if (_isEditing && _editingId != null) {
      final alarm = AlarmModel(
        id: _editingId!,
        hour: hour24,
        minute: _selectedMinute,
        label: _label,
        repeatDays: _repeatDays,
        challengeIndex: _challengeIndex,
        allowSnooze: _allowSnooze,
        qrSecret: secret,
      );
      ref.read(alarmListProvider.notifier).updateAlarm(alarm);
    } else {
      final alarm = AlarmModel(
        id: const Uuid().v4(),
        hour: hour24,
        minute: _selectedMinute,
        label: _label,
        repeatDays: _repeatDays,
        challengeIndex: _challengeIndex,
        allowSnooze: _allowSnooze,
        qrSecret: secret,
      );
      ref.read(alarmListProvider.notifier).addAlarm(alarm);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Text(_isEditing ? 'Edit Alarm' : 'New Alarm'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: _save,
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ── Time Picker ──
            _buildTimePicker(),
            const SizedBox(height: 16),

            // ── Label ──
            _buildSection(
              label: 'LABEL',
              child: TextField(
                controller: _labelController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                onChanged: (v) => setState(() => _label = v),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 18),
                  hintText: 'Alarm name',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Repeat ──
            _buildSection(
              label: 'REPEAT',
              trailing: Text(
                _repeatLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              child: _buildDaySelector(),
            ),
            const SizedBox(height: 12),

            // ── Wake-up Challenge ──
            _buildSection(
              label: 'WAKE-UP CHALLENGE',
              child: GestureDetector(
                onTap: () async {
                  await context.push('/choose-challenge');
                  if (mounted) {
                    setState(() {
                      _challengeIndex = ref.read(selectedChallengeProvider);
                    });
                  }
                },
                child: _buildChallengeTile(),
              ),
            ),
            if (_challengeIndex == 0 && _qrSecret.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildQRDisplay(),
            ],
            const SizedBox(height: 12),

            // ── Snooze ──
            _buildSnoozeRow(),
            const SizedBox(height: 28),

            // ── Create Button ──
            _buildCreateButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Hour picker
          Expanded(
            child: _NumberStepper(
              value: _selectedHour,
              min: 1,
              max: 12,
              onChanged: (v) => setState(() => _selectedHour = v),
            ),
          ),

          // Colon
          const Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),

          // Minute picker
          Expanded(
            child: _NumberStepper(
              value: _selectedMinute,
              min: 0,
              max: 59,
              onChanged: (v) => setState(() => _selectedMinute = v),
            ),
          ),

          // AM/PM
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: Column(
              children: [
                _AmPmButton(
                  label: 'AM',
                  isSelected: _isAM,
                  onTap: () => setState(() => _isAM = true),
                ),
                const SizedBox(height: 8),
                _AmPmButton(
                  label: 'PM',
                  isSelected: !_isAM,
                  onTap: () => setState(() => _isAM = false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String label,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isSelected = _repeatDays.contains(i);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _repeatDays = _repeatDays.where((d) => d != i).toList();
              } else {
                _repeatDays = [..._repeatDays, i];
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                days[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildQRDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Scan QR ini saat alarm aktif',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          QrImageView(
            data: _qrSecret,
            version: QrVersions.auto,
            size: 160,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(8),
          ),
          const SizedBox(height: 8),
          Text(
            'Secret: $_qrSecret',
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeTile() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_challengeIcon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _challengeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _challengeDesc,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _buildSnoozeRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Allow Snooze',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Snooze disabled for extreme mode',
                  style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: _allowSnooze,
            onChanged: (v) => setState(() => _allowSnooze = v),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isEditing ? 'Save Changes' : 'Create Alarm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Number Stepper (unified for hour & minute — tap number to cycle) ──────

class _NumberStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  void _up() => onChanged(value >= max ? min : value + 1);
  void _down() => onChanged(value <= min ? max : value - 1);
  void _tap() => _up();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _up,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              child: const Icon(Icons.keyboard_arrow_up_rounded,
                  color: AppColors.textSecondary, size: 32),
            ),
          ),
          GestureDetector(
            onTap: _tap,
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Text(
                value.toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _down,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AM/PM Button ────────────────────────────────────────────────────────────

class _AmPmButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmPmButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
