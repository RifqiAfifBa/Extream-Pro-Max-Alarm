import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alarm_model.dart';

class AlarmCard extends StatefulWidget {
  final AlarmModel alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _pressController;
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.alarm.isEnabled;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _pressController.reverse(),
        onTapUp: (_) {
          _pressController.forward();
          widget.onTap();
        },
        onTapCancel: () => _pressController.forward(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isEnabled ? AppColors.border : AppColors.border.withOpacity(0.4),
              width: 1,
            ),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle switch
                  Transform.scale(
                    scale: 0.85,
                    alignment: Alignment.centerLeft,
                    child: Switch(
                      value: isEnabled,
                      onChanged: (_) => widget.onToggle(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: isEnabled
                                ? Colors.white
                                : AppColors.textTertiary,
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            height: 1,
                          ),
                          child: Text(widget.alarm.formattedTime24),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: isEnabled
                                ? AppColors.textSecondary
                                : AppColors.textTertiary,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          child: Text(
                            widget.alarm.label.isNotEmpty
                                ? widget.alarm.label
                                : 'Alarm',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // More options
                  GestureDetector(
                    onTap: () => _showOptions(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.more_vert,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Chips row
              Wrap(
                spacing: 8,
                children: [
                  if (widget.alarm.repeatDays.isNotEmpty)
                    _SmallChip(label: widget.alarm.repeatLabel),
                  _SmallChip(
                    icon: _challengeIcon(widget.alarm.challengeType),
                    label: widget.alarm.challengeLabel,
                    color: _challengeColor(widget.alarm.challengeType),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _challengeIcon(ChallengeType type) {
    switch (type) {
      case ChallengeType.qrScan:
        return Icons.qr_code_scanner_rounded;
      case ChallengeType.math:
        return Icons.calculate_outlined;
      case ChallengeType.wordArrange:
        return Icons.text_fields_rounded;
      case ChallengeType.riddle:
        return Icons.extension_outlined;
      case ChallengeType.none:
        return Icons.alarm;
    }
  }

  Color _challengeColor(ChallengeType type) {
    switch (type) {
      case ChallengeType.qrScan:
        return AppColors.primary;
      case ChallengeType.math:
        return AppColors.orange;
      case ChallengeType.wordArrange:
        return AppColors.teal;
      case ChallengeType.riddle:
        return AppColors.purple;
      case ChallengeType.none:
        return AppColors.textTertiary;
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.white),
              title: const Text('Edit Alarm',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                widget.onTap();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.red),
              title: const Text('Delete Alarm', style: TextStyle(color: AppColors.red)),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const _SmallChip({required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (color ?? AppColors.textTertiary).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color ?? AppColors.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
