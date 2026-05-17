import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/alarm_model.dart';
import '../providers/alarm_provider.dart';
import '../tokens.dart';

class CreateAlarmScreen extends StatefulWidget {
  const CreateAlarmScreen({super.key});

  @override
  State<CreateAlarmScreen> createState() => _CreateAlarmScreenState();
}

class _CreateAlarmScreenState extends State<CreateAlarmScreen> {
  late Alarm? _existingAlarm;
  late TextEditingController _labelController;
  late TimeOfDay _selectedTime;
  late AlarmRepeat _selectedRepeat;
  late ChallengeType _selectedChallenge;
  late bool _vibrationEnabled;
  late bool _soundEnabled;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();

    // Get existing alarm from arguments if editing
    Future.delayed(Duration.zero, () {
      final alarm = ModalRoute.of(context)?.settings.arguments as Alarm?;
      _initializeWithAlarm(alarm);
    });

    _labelController = TextEditingController();
    _selectedTime = TimeOfDay.now();
    _selectedRepeat = AlarmRepeat.never;
    _selectedChallenge = ChallengeType.none;
    _vibrationEnabled = true;
    _soundEnabled = true;
    _selectedDays = [];
    _existingAlarm = null;
  }

  void _initializeWithAlarm(Alarm? alarm) {
    if (alarm != null) {
      _existingAlarm = alarm;
      _labelController.text = alarm.label;
      _selectedTime = alarm.getTimeOfDay();
      _selectedRepeat = alarm.repeat;
      _selectedChallenge = alarm.challengeType;
      _vibrationEnabled = alarm.vibration;
      _soundEnabled = true; // Simplified
      _selectedDays = List.from(alarm.repeatDays);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAlarm() async {
    if (_labelController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter an alarm label')));
      return;
    }

    final now = DateTime.now();
    final alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final alarm = Alarm(
      id: _existingAlarm?.id ?? const Uuid().v4(),
      time: alarmDateTime,
      label: _labelController.text,
      isActive: true,
      repeat: _selectedRepeat,
      repeatDays: _selectedDays,
      sound: 'default',
      vibration: _vibrationEnabled,
      challengeType: _selectedChallenge,
      createdAt: _existingAlarm?.createdAt ?? DateTime.now(),
      modifiedAt: DateTime.now(),
    );

    final provider = Provider.of<AlarmProvider>(context, listen: false);

    if (_existingAlarm != null) {
      await provider.updateAlarm(alarm);
    } else {
      await provider.addAlarm(alarm);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _existingAlarm != null ? 'Alarm updated' : 'Alarm created',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0D0F14),
        appBar: AppBar(
          backgroundColor: Color(0xFF1A1D26),
          title: Text(
            _existingAlarm != null ? 'Edit Alarm' : 'Create New Alarm',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Picker Section
                Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF4F6BFF).withOpacity(0.1),
                      border: Border.all(color: Color(0xFF4F6BFF), width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        _selectedTime.format(context),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F6BFF),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // Label Section
                Text(
                  'Alarm Label',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _labelController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., Wake up, Work meeting...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Color(0xFF1A1D26),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFF4F6BFF).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF4F6BFF)),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // Repeat Section
                Text(
                  'Repeat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildRepeatSelector(),
                SizedBox(height: 32),
                // Challenge Type Section
                Text(
                  'Alarm Challenge',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildChallengeSelector(),
                SizedBox(height: 32),
                // Options Section
                Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildOptionRow(
                  'Vibration',
                  Icons.vibration,
                  _vibrationEnabled,
                  (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  },
                ),
                SizedBox(height: 12),
                _buildOptionRow(
                  'Sound',
                  Icons.volume_up_outlined,
                  _soundEnabled,
                  (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                ),
                SizedBox(height: 40),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4F6BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _existingAlarm != null ? 'Update Alarm' : 'Create Alarm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AlarmRepeat.values.map((repeat) {
        final isSelected = _selectedRepeat == repeat;
        return FilterChip(
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedRepeat = repeat;
            });
          },
          label: Text(
            _getRepeatLabel(repeat),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected ? Color(0xFF4F6BFF) : Color(0xFF1A1D26),
          side: BorderSide(
            color: isSelected ? Color(0xFF4F6BFF) : Colors.grey[700]!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChallengeSelector() {
    return Column(
      children: [
        _buildChallengeOption(
          'No Challenge',
          Icons.check_circle_outline,
          ChallengeType.none,
        ),
        SizedBox(height: 12),
        _buildChallengeOption(
          'QR Code Scan',
          Icons.qr_code_2,
          ChallengeType.qrScan,
        ),
        SizedBox(height: 12),
        _buildChallengeOption(
          'Math Challenge',
          Icons.calculate_outlined,
          ChallengeType.mathChallenge,
        ),
        SizedBox(height: 12),
        _buildChallengeOption(
          'Word Arrange',
          Icons.text_fields,
          ChallengeType.wordArrange,
        ),
      ],
    );
  }

  Widget _buildChallengeOption(
    String label,
    IconData icon,
    ChallengeType type,
  ) {
    final isSelected = _selectedChallenge == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChallenge = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF4F6BFF).withOpacity(0.2)
              : Color(0xFF1A1D26),
          border: Border.all(
            color: isSelected ? Color(0xFF4F6BFF) : Colors.grey[700]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFF4F6BFF) : Colors.grey[400],
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Color(0xFF4F6BFF) : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Spacer(),
            if (isSelected) Icon(Icons.check, color: Color(0xFF4F6BFF)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(
    String label,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1A1D26),
        border: Border.all(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4F6BFF)),
          SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.white)),
          Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF4F6BFF),
          ),
        ],
      ),
    );
  }

  String _getRepeatLabel(AlarmRepeat repeat) {
    switch (repeat) {
      case AlarmRepeat.never:
        return 'Never';
      case AlarmRepeat.daily:
        return 'Daily';
      case AlarmRepeat.weekdays:
        return 'Weekdays';
      case AlarmRepeat.weekends:
        return 'Weekends';
      case AlarmRepeat.custom:
        return 'Custom';
    }
  }
}
