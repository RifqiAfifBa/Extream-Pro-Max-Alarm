import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/alarm_model.dart';
import '../../providers/alarm_providers.dart';
import '../../widgets/loading_indicators.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmListProvider);
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM').format(now);

    final enabled = alarms.where((a) => a.isEnabled).toList();
    final total = alarms.length;
    final enabledCount = enabled.length;
    final snoozeCount = alarms.where((a) => a.allowSnooze).length;

    String earliest = '--:--';
    String latest = '--:--';
    if (enabled.isNotEmpty) {
      final sorted = List<AlarmModel>.from(enabled)
        ..sort((a, b) => a.hour != b.hour
            ? a.hour.compareTo(b.hour)
            : a.minute.compareTo(b.minute));
      earliest = '${sorted.first.formattedTime} ${sorted.first.amPm}';
      latest = '${sorted.last.formattedTime} ${sorted.last.amPm}';
    }

    final successPct = total > 0 ? (enabledCount / total * 100).round() : 0;

    // Per-day alarm count for charts
    final dayCounts = List.generate(
        7,
        (i) => enabled
            .where((a) => a.repeatDays.isEmpty || a.repeatDays.contains(i))
            .length);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat statistik...',
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => context.pop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 38,
                          height: 38,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 16),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Analitik',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontSize: 26)),
                            const SizedBox(height: 2),
                            Text(dateStr,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle),
                        child: const Center(
                            child: Text('JD',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13))),
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Grid 2x2
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _StatCard(
                        icon: Icons.wb_sunny_outlined,
                        iconColor: const Color(0xFF34C759),
                        label: 'BANGUN',
                        value: earliest,
                        sub: '$enabledCount alarm aktif',
                        subColor: const Color(0xFF34C759),
                      ),
                      _StatCard(
                        icon: Icons.bedtime_outlined,
                        iconColor: const Color(0xFF5B5FEF),
                        label: 'TERAKHIR',
                        value: latest,
                        sub: '${total - enabledCount} nonaktif',
                        subColor: const Color(0xFFFF6B6B),
                      ),
                      _StatCard(
                        icon: Icons.snooze_outlined,
                        iconColor: const Color(0xFFFF3B30),
                        label: 'SNOOZE',
                        value: '$snoozeCount',
                        sub: 'dari $total alarm',
                        subColor: const Color(0xFFFF3B30),
                      ),
                      _StatCard(
                        icon: Icons.check_circle_outline,
                        iconColor: const Color(0xFF34C759),
                        label: 'AKTIF',
                        value: '$successPct%',
                        sub: '$enabledCount dari $total alarm',
                        subColor: const Color(0xFF34C759),
                      ),
                    ],
                  ),
                ),
              ),

              // Alarms per day Bar Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _ChartCard(
                    title: 'Alarm per Hari',
                    subtitle: 'Minggu ini',
                    legend: const Row(
                      children: [
                        _LegendDot(color: AppColors.primary, label: 'Aktif'),
                        SizedBox(width: 12),
                        _LegendDot(
                            color: AppColors.textTertiary, label: 'Hari'),
                      ],
                    ),
                    child: SizedBox(
                      height: 160,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (dayCounts.reduce((a, b) => a > b ? a : b) + 1)
                              .toDouble()
                              .clamp(2, 10),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (v) => const FlLine(
                                color: AppColors.border, strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, meta) {
                                  const days = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(days[v.toInt()],
                                        style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                              7,
                              (i) => BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: dayCounts[i].toDouble(),
                                        color: AppColors.primary,
                                        width: 18,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                    ],
                                  )),
                          barTouchData: BarTouchData(enabled: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Snooze Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _ChartCard(
                    title: 'Snooze per Hari',
                    subtitle: 'Alarm dengan izin snooze',
                    legend: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text('$snoozeCount alarm',
                              style: const TextStyle(
                                  color: AppColors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    child: SizedBox(
                      height: 140,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (dayCounts.reduce((a, b) => a > b ? a : b) + 1)
                              .toDouble()
                              .clamp(2, 10),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (v) => const FlLine(
                                color: AppColors.border, strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, meta) {
                                  const days = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                        '${dayCounts[v.toInt()]}\n${days[v.toInt()]}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 9)),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                              7,
                              (i) => BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: dayCounts[i].toDouble(),
                                        color: dayCounts[i] > 0
                                            ? const Color(0xFFE74C3C)
                                            : const Color(0xFFB8860B),
                                        width: 22,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ],
                                  )),
                          barTouchData: BarTouchData(enabled: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Wake Quality Donut
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _ChartCard(
                    title: 'Kualitas Alarm',
                    subtitle: 'Aktif vs Nonaktif',
                    child: SizedBox(
                      height: 140,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 36,
                                sections: [
                                  PieChartSectionData(
                                    value: enabledCount.toDouble(),
                                    color: AppColors.green,
                                    radius: 20,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    value: (total - enabledCount).toDouble(),
                                    color: AppColors.red,
                                    radius: 20,
                                    showTitle: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LegendDot(
                                  color: AppColors.green,
                                  label: 'Aktif $successPct%'),
                              const SizedBox(height: 8),
                              _LegendDot(
                                  color: AppColors.red,
                                  label: 'Nonaktif ${100 - successPct}%'),
                              const SizedBox(height: 12),
                              Text(
                                  '$enabledCount dari $total alarm\nsaat ini aktif',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  final Color subColor;

  const _StatCard(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.value,
      required this.sub,
      required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.card, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8)),
            ],
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1)),
          Row(
            children: [
              Container(
                  width: 5,
                  height: 5,
                  decoration:
                      BoxDecoration(color: subColor, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(sub,
                      style: TextStyle(color: subColor, fontSize: 10),
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? legend;

  const _ChartCard(
      {required this.title,
      required this.subtitle,
      required this.child,
      this.legend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.card, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              if (legend != null) legend!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
