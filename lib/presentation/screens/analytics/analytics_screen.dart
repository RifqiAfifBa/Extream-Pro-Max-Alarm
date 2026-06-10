import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

import '../../widgets/loading_indicators.dart';
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _period = 'This Week';

  @override
  Widget build(BuildContext context) {
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
                        width: 38, height: 38,
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
                          Text('Analitik', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 26)),
                          const SizedBox(height: 2),
                          Text('Senin, 23 Juni', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    // Period selector
                    GestureDetector(
                      onTap: () => setState(() => _period = _period == 'This Week' ? 'This Month' : 'This Week'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Text(_period, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 38, height: 38,
                      decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                      child: const Center(child: Text('JD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))),
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
                  children: const [
                    _StatCard(icon: Icons.bedtime_outlined, iconColor: Color(0xFF5B5FEF), label: 'TIDUR', value: '22:45', sub: '~15 mnt dari target', subColor: Color(0xFFFF6B6B)),
                    _StatCard(icon: Icons.wb_sunny_outlined, iconColor: Color(0xFF34C759), label: 'BANGUN', value: '06:38', sub: '+8 mnt dari alarm', subColor: Color(0xFF34C759)),
                    _StatCard(icon: Icons.snooze_outlined, iconColor: Color(0xFFFF3B30), label: 'SNOOZE', value: '2.3x', sub: '16 total minggu ini', subColor: Color(0xFFFF3B30)),
                    _StatCard(icon: Icons.check_circle_outline, iconColor: Color(0xFF34C759), label: 'SUKSES', value: '57%', sub: '4 dari 7 hari', subColor: Color(0xFF34C759)),
                  ],
                ),
              ),
            ),

            // Sleep/Wake Bar Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _ChartCard(
                  title: 'Jam Tidur & Bangun',
                  subtitle: 'Minggu ini',
                  legend: const Row(
                    children: [
                      _LegendDot(color: AppColors.primary, label: 'Tidur'),
                      SizedBox(width: 12),
                      _LegendDot(color: AppColors.green, label: 'Bangun'),
                    ],
                  ),
                  child: SizedBox(
                    height: 160,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 12,
                        minY: 0,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 4,
                          getDrawingHorizontalLine: (v) => const FlLine(color: AppColors.border, strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, meta) {
                                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(days[v.toInt()], style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _sleepGroup(0, 7.5, 6.5),
                          _sleepGroup(1, 8.0, 6.6),
                          _sleepGroup(2, 7.0, 7.0),
                          _sleepGroup(3, 9.0, 6.3),
                          _sleepGroup(4, 8.5, 6.8),
                          _sleepGroup(5, 9.5, 7.5),
                          _sleepGroup(6, 7.0, 6.5),
                        ],
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
                  title: 'Frekuensi Snooze',
                  subtitle: 'Per hari dalam seminggu',
                  legend: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        const Text('Total: 16x', style: TextStyle(color: AppColors.red, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  child: SizedBox(
                    height: 140,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 6,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2,
                          getDrawingHorizontalLine: (v) => const FlLine(color: AppColors.border, strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, meta) {
                                const labels = ['3x\nMon', '1x\nTue', '0x\nWed', '4x\nThu', '2x\nFri', '5x\nSat', '1x\nSun'];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(labels[v.toInt()], textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _snoozeGroup(0, 3, const Color(0xFFB8860B)),
                          _snoozeGroup(1, 1, const Color(0xFFB8860B)),
                          _snoozeGroup(2, 0, const Color(0xFFB8860B)),
                          _snoozeGroup(3, 4, const Color(0xFFE74C3C)),
                          _snoozeGroup(4, 2, const Color(0xFFB8860B)),
                          _snoozeGroup(5, 5, const Color(0xFFE74C3C)),
                          _snoozeGroup(6, 1, const Color(0xFFB8860B)),
                        ],
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
                  title: 'Kualitas Bangun',
                  subtitle: 'Berhasil vs Gagal',
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
                                  value: 57,
                                  color: AppColors.green,
                                  radius: 20,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 43,
                                  color: AppColors.red,
                                  radius: 20,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LegendDot(color: AppColors.green, label: 'Berhasil 57%'),
                            SizedBox(height: 8),
                            _LegendDot(color: AppColors.red, label: 'Gagal 43%'),
                            SizedBox(height: 12),
                            Text('4 dari 7 hari\nberhasil bangun', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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

  static BarChartGroupData _sleepGroup(int x, double sleep, double wake) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: sleep, color: AppColors.primary, width: 8, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: wake, color: AppColors.green, width: 8, borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 3,
    );
  }

  static BarChartGroupData _snoozeGroup(int x, double val, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [BarChartRodData(toY: val, color: color, width: 22, borderRadius: BorderRadius.circular(6))],
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

  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value, required this.sub, required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700, height: 1)),
          Row(
            children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(color: subColor, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Expanded(child: Text(sub, style: TextStyle(color: subColor, fontSize: 10), overflow: TextOverflow.ellipsis)),
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

  const _ChartCard({required this.title, required this.subtitle, required this.child, this.legend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
