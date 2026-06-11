import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/translations.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/alarm_providers.dart';
import '../../widgets/alarm_card.dart';
import '../../widgets/next_alarm_card.dart';
import '../../widgets/loading_indicators.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  Timer? _alarmChecker;
  Timer? _clockTimer;
  String _timeText = '';
  String? _lastFiredAlarmId;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _alarmChecker =
        Timer.periodic(const Duration(seconds: 15), (_) => _checkAlarms());
    _updateTime();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _timeText =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  void _checkAlarms() {
    if (!mounted) return;
    final alarms = ref.read(alarmListProvider);
    final now = DateTime.now();
    final today = (now.weekday + 6) % 7;

    for (final alarm in alarms) {
      if (!alarm.isEnabled) continue;
      if (alarm.hour != now.hour || alarm.minute != now.minute) continue;
      if (_lastFiredAlarmId == alarm.id) continue;
      if (alarm.repeatDays.isNotEmpty && !alarm.repeatDays.contains(today))
        continue;

      _lastFiredAlarmId = alarm.id;
      context.push('/alarm-ringing', extra: alarm);
      return;
    }
  }

  @override
  void dispose() {
    _alarmChecker?.cancel();
    _clockTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(alarmListProvider);
    final nextAlarm = ref.watch(nextAlarmProvider);
    final lang = ref.watch(preferencesProvider.select((p) => p.language));
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat alarm...',
          child: FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _timeText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(fontSize: 36, letterSpacing: -1),
                            ),
                            Text(
                              DateFormat('EEEE, d MMMM').format(now),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Analytics button
                        GestureDetector(
                          onTap: () => context.push('/analytics'),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'JD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Next Alarm Card → tap to preview the Alarm Ringing screen
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              context.push('/alarm-ringing', extra: nextAlarm),
                          child: NextAlarmCard(alarm: nextAlarm),
                        ),
                      ],
                    ),
                  ),
                ),

                // My Alarms header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                    child: Row(
                      children: [
                        Text(
                          tr('home.my_alarms', lang),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.push('/add-alarm'),
                          child: Text(
                            '+ ' + tr('common.add', lang),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Alarm list
                if (alarms.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.border,
                              width: 1,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.2),
                                    AppColors.primary.withOpacity(0.05),
                                  ],
                                ),
                              ),
                              child: const Icon(Icons.alarm_off_rounded,
                                  color: AppColors.primary, size: 36),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              tr('home.empty_title', lang),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tr('home.empty_desc', lang),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.5,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 18),
                            GestureDetector(
                              onTap: () => context.push('/add-alarm'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_rounded,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      tr('home.empty_cta', lang),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final alarm = alarms[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + index * 80),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                  opacity: value.clamp(0.0, 1.0), child: child),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: AlarmCard(
                              alarm: alarm,
                              onToggle: () => ref
                                  .read(alarmListProvider.notifier)
                                  .toggleAlarm(alarm.id),
                              onDelete: () => ref
                                  .read(alarmListProvider.notifier)
                                  .deleteAlarm(alarm.id),
                              onTap: () =>
                                  context.push('/add-alarm', extra: alarm),
                            ),
                          ),
                        );
                      },
                      childCount: alarms.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
