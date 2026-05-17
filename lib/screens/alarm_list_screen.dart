import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/alarm_model.dart';
import '../providers/alarm_provider.dart';
import '../tokens.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    // Load data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AlarmProvider>(context, listen: false);
      provider.loadAlarms();
      provider.loadTimers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToCreateAlarm(BuildContext context, {Alarm? alarm}) async {
    final result = await Navigator.pushNamed(
      context,
      '/create-alarm',
      arguments: alarm,
    );

    if (result == true && mounted) {
      Provider.of<AlarmProvider>(context, listen: false).loadAlarms();
    }
  }

  void _showDeleteConfirmation(BuildContext context, String alarmId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A1D26),
        title: Text('Delete Alarm?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this alarm?',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF4F6BFF))),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AlarmProvider>(
                context,
                listen: false,
              ).deleteAlarm(alarmId);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Alarm deleted')));
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0D0F14),
        body: Consumer<AlarmProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                // Background gradient
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.0000, 0.0000),
                        radius: 0.80,
                        colors: [Color(0x144F6BFF), Color(0x004F6BFF)],
                        stops: [0, 0.7],
                      ),
                    ),
                  ),
                ),
                // Content
                Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Morning',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Text(
                                    provider.user?.name ?? 'User',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      MediaQuery.of(context).size.width - 70,
                                      80,
                                      20,
                                      0,
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        child: Text('Settings'),
                                        value: 'settings',
                                      ),
                                      PopupMenuItem(
                                        child: Text('Logout'),
                                        value: 'logout',
                                      ),
                                    ],
                                  ).then((value) {
                                    if (value == 'logout') {
                                      provider.logout().then((_) {
                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed('/login');
                                      });
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF4F6BFF),
                                  child: Text(
                                    (provider.user?.name ?? 'U')[0]
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Next Alarm Info
                          if (provider.alarms.any((a) => a.isActive))
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF4F6BFF).withOpacity(0.1),
                                border: Border.all(
                                  color: Color(0xFF4F6BFF).withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF4F6BFF),
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Next alarm: ${_getNextAlarmTime(provider.alarms)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Tab Bar
                    Container(
                      color: Color(0xFF1A1D26),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Color(0xFF4F6BFF),
                        labelColor: Color(0xFF4F6BFF),
                        unselectedLabelColor: Colors.grey[500],
                        tabs: [
                          Tab(text: 'Alarms'),
                          Tab(text: 'Timer'),
                          Tab(text: 'Stopwatch'),
                        ],
                      ),
                    ),
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Alarms Tab
                          _buildAlarmsTab(context, provider),
                          // Timer Tab
                          _buildTimerTab(context, provider),
                          // Stopwatch Tab
                          _buildStopwatchTab(context, provider),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () => _navigateToCreateAlarm(context),
                backgroundColor: Color(0xFF4F6BFF),
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget _buildAlarmsTab(BuildContext context, AlarmProvider provider) {
    final alarms = provider.alarms;

    if (alarms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alarm_off_outlined, size: 64, color: Colors.grey[600]),
            SizedBox(height: 16),
            Text(
              'No alarms yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create your first alarm to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        return _buildAlarmCard(context, provider, alarm);
      },
    );
  }

  Widget _buildAlarmCard(
    BuildContext context,
    AlarmProvider provider,
    Alarm alarm,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: alarm.isActive
            ? Color(0xFF4F6BFF).withOpacity(0.1)
            : Color(0xFF1A1D26),
        border: Border.all(
          color: alarm.isActive
              ? Color(0xFF4F6BFF).withOpacity(0.3)
              : Colors.grey[700]!,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Time Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.getTimeString(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  alarm.label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                if (alarm.repeat != AlarmRepeat.never)
                  Text(
                    _getRepeatString(alarm.repeat),
                    style: TextStyle(fontSize: 12, color: Color(0xFF4F6BFF)),
                  ),
              ],
            ),
            Spacer(),
            // Action Buttons
            Column(
              children: [
                // Toggle Switch
                Switch(
                  value: alarm.isActive,
                  onChanged: (value) {
                    provider.toggleAlarmActive(alarm.id);
                  },
                  activeColor: Color(0xFF4F6BFF),
                ),
                SizedBox(height: 8),
                // Edit Button
                IconButton(
                  onPressed: () =>
                      _navigateToCreateAlarm(context, alarm: alarm),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF4F6BFF),
                    size: 20,
                  ),
                ),
                // Delete Button
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, alarm.id),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerTab(BuildContext context, AlarmProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, size: 64, color: Colors.grey[600]),
          SizedBox(height: 16),
          Text(
            'Timer',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/timer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4F6BFF),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text('Go to Timer'),
          ),
        ],
      ),
    );
  }

  Widget _buildStopwatchTab(BuildContext context, AlarmProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_outlined, size: 64, color: Colors.grey[600]),
          SizedBox(height: 16),
          Text(
            'Stopwatch',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/timer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4F6BFF),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text('Go to Stopwatch'),
          ),
        ],
      ),
    );
  }

  String _getNextAlarmTime(List<Alarm> alarms) {
    final activeAlarms = alarms.where((a) => a.isActive).toList();
    if (activeAlarms.isEmpty) return 'None';

    activeAlarms.sort((a, b) => a.time.compareTo(b.time));
    final nextAlarm = activeAlarms.first;

    return '${DateFormat('HH:mm').format(nextAlarm.time)} - ${nextAlarm.label}';
  }

  String _getRepeatString(AlarmRepeat repeat) {
    switch (repeat) {
      case AlarmRepeat.never:
        return 'Never';
      case AlarmRepeat.daily:
        return 'Every day';
      case AlarmRepeat.weekdays:
        return 'Weekdays';
      case AlarmRepeat.weekends:
        return 'Weekends';
      case AlarmRepeat.custom:
        return 'Custom';
    }
  }
}
