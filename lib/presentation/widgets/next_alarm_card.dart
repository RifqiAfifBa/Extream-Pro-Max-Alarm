import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alarm_model.dart';

class NextAlarmCard extends StatefulWidget {
  final AlarmModel? alarm;
  const NextAlarmCard({super.key, required this.alarm});

  @override
  State<NextAlarmCard> createState() => _NextAlarmCardState();
}

class _NextAlarmCardState extends State<NextAlarmCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getCountdown(AlarmModel alarm) {
    final now = DateTime.now();
    int alarmMins = alarm.hour * 60 + alarm.minute;
    int nowMins = now.hour * 60 + now.minute;
    int diff = alarmMins - nowMins;
    if (diff <= 0) diff += 1440;
    final hours = diff ~/ 60;
    final minutes = diff % 60;
    if (hours > 0)
      return 'In $hours hours ${minutes > 0 ? '$minutes minutes' : ''}';
    return 'In $minutes minutes';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alarm == null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No active alarms',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final alarm = widget.alarm!;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.nextAlarmGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Text(
                'NEXT ALARM',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.5,
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              // ACTIVE badge
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.red
                            .withOpacity(0.3 + 0.2 * _pulseController.value),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.red.withOpacity(
                                    0.4 + 0.4 * _pulseController.value),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Color(0xFFFF6B6B),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time display
          Text(
            '${alarm.formattedTime} ${alarm.amPm}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),

          // Countdown
          Text(
            _getCountdown(alarm),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),

          // Chips row
          Row(
            children: [
              _Chip(
                icon: Icons.qr_code_scanner_rounded,
                label: alarm.challengeLabel,
              ),
              const SizedBox(width: 8),
              _Chip(
                icon: Icons.wb_sunny_outlined,
                label: alarm.label.isNotEmpty ? alarm.label : 'Alarm',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
