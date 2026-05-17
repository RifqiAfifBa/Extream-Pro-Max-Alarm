import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm_model.dart';
import '../providers/alarm_provider.dart';
import '../tokens.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _timerInputController;

  int _timerHours = 0;
  int _timerMinutes = 1;
  int _timerSeconds = 0;

  int _stopwatchHours = 0;
  int _stopwatchMinutes = 0;
  int _stopwatchSeconds = 0;

  bool _timerIsRunning = false;
  bool _stopwatchIsRunning = false;

  late DateTime _timerStartTime;
  late DateTime _stopwatchStartTime;
  late Duration _timerDuration;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _timerInputController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timerInputController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timerHours == 0 && _timerMinutes == 0 && _timerSeconds == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please set a timer duration')));
      return;
    }

    setState(() {
      _timerIsRunning = true;
      _timerStartTime = DateTime.now();
      _timerDuration = Duration(
        hours: _timerHours,
        minutes: _timerMinutes,
        seconds: _timerSeconds,
      );
    });

    _startTimerTick();
  }

  void _startTimerTick() {
    Future.doWhile(() async {
      if (!_timerIsRunning) return false;

      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        final elapsed = DateTime.now().difference(_timerStartTime);
        final remaining = _timerDuration - elapsed;

        if (remaining.isNegative || remaining.inSeconds == 0) {
          setState(() {
            _timerIsRunning = false;
            _timerHours = 0;
            _timerMinutes = 0;
            _timerSeconds = 0;
          });
          _showTimerFinishedDialog();
          return false;
        }

        setState(() {
          _timerHours = remaining.inHours;
          _timerMinutes = remaining.inMinutes % 60;
          _timerSeconds = remaining.inSeconds % 60;
        });
      }
      return _timerIsRunning;
    });
  }

  void _pauseTimer() {
    setState(() {
      _timerIsRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _timerIsRunning = false;
      _timerHours = 0;
      _timerMinutes = 1;
      _timerSeconds = 0;
    });
  }

  void _startStopwatch() {
    setState(() {
      _stopwatchIsRunning = true;
      _stopwatchStartTime = DateTime.now();
    });

    _startStopwatchTick();
  }

  void _startStopwatchTick() {
    Future.doWhile(() async {
      if (!_stopwatchIsRunning) return false;

      await Future.delayed(Duration(milliseconds: 100));

      if (mounted && _stopwatchIsRunning) {
        final elapsed = DateTime.now().difference(_stopwatchStartTime);

        // Add previous time if was running before
        final totalElapsed =
            Duration(
              hours: _stopwatchHours,
              minutes: _stopwatchMinutes,
              seconds: _stopwatchSeconds,
            ).inSeconds +
            elapsed.inSeconds;

        setState(() {
          _stopwatchHours = totalElapsed ~/ 3600;
          _stopwatchMinutes = (totalElapsed % 3600) ~/ 60;
          _stopwatchSeconds = totalElapsed % 60;
        });
      }
      return _stopwatchIsRunning;
    });
  }

  void _pauseStopwatch() {
    setState(() {
      _stopwatchIsRunning = false;
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatchIsRunning = false;
      _stopwatchHours = 0;
      _stopwatchMinutes = 0;
      _stopwatchSeconds = 0;
    });
  }

  void _showTimerFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A1D26),
        title: Text(
          'Timer Finished!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Your timer has finished!',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text('OK', style: TextStyle(color: Color(0xFF4F6BFF))),
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
        appBar: AppBar(
          backgroundColor: Color(0xFF1A1D26),
          title: Text(
            'Timer & Stopwatch',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color(0xFF4F6BFF),
            labelColor: Color(0xFF4F6BFF),
            unselectedLabelColor: Colors.grey[500],
            tabs: [
              Tab(text: 'Timer'),
              Tab(text: 'Stopwatch'),
            ],
          ),
          elevation: 0,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildTimerTab(), _buildStopwatchTab()],
        ),
      ),
    );
  }

  Widget _buildTimerTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            // Timer Display
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4F6BFF).withOpacity(0.2),
                    Color(0xFF4F6BFF).withOpacity(0.05),
                  ],
                ),
                border: Border.all(color: Color(0xFF4F6BFF), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_timerHours.toString().padLeft(2, '0')}:${_timerMinutes.toString().padLeft(2, '0')}:${_timerSeconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F6BFF),
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _timerIsRunning ? 'Running' : 'Paused',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            // Time Input
            if (!_timerIsRunning)
              Column(
                children: [
                  Text(
                    'Set Timer Duration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimeInputField('Hours', _timerHours, (value) {
                        setState(() {
                          _timerHours = int.tryParse(value) ?? 0;
                        });
                      }),
                      _buildTimeInputField('Minutes', _timerMinutes, (value) {
                        setState(() {
                          _timerMinutes = int.tryParse(value) ?? 0;
                        });
                      }),
                      _buildTimeInputField('Seconds', _timerSeconds, (value) {
                        setState(() {
                          _timerSeconds = int.tryParse(value) ?? 0;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _timerIsRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F6BFF),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(
                    _timerIsRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: Text(
                    _timerIsRunning ? 'Pause' : 'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.3),
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(Icons.refresh, color: Colors.red),
                  label: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStopwatchTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            // Stopwatch Display
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF6B9D).withOpacity(0.2),
                    Color(0xFFFF6B9D).withOpacity(0.05),
                  ],
                ),
                border: Border.all(color: Color(0xFFFF6B9D), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_stopwatchHours.toString().padLeft(2, '0')}:${_stopwatchMinutes.toString().padLeft(2, '0')}:${_stopwatchSeconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B9D),
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _stopwatchIsRunning ? 'Running' : 'Stopped',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _stopwatchIsRunning
                      ? _pauseStopwatch
                      : _startStopwatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B9D),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(
                    _stopwatchIsRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: Text(
                    _stopwatchIsRunning ? 'Pause' : 'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetStopwatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.3),
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(Icons.refresh, color: Colors.red),
                  label: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputField(
    String label,
    int value,
    Function(String) onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
        SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            controller: TextEditingController(
              text: value.toString().padLeft(2, '0'),
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF1A1D26),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFF4F6BFF).withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFF4F6BFF).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF4F6BFF)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
