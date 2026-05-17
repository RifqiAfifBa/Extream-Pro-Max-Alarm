import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/alarm_list_screen.dart';
import 'screens/create_alarm_screen.dart';
import 'screens/timer_screen.dart';
import 'services/alarm_service.dart';
import 'providers/alarm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final alarmService = AlarmService();
  runApp(MainApp(alarmService: alarmService));
}

class MainApp extends StatelessWidget {
  final AlarmService alarmService;
  const MainApp({super.key, required this.alarmService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmProvider(alarmService)),
      ],
      child: MaterialApp(
        title: 'XAlarm - Extreme Pro Max',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Color(0xFF4F6BFF),
          scaffoldBackgroundColor: Color(0xFF0D0F14),
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF4F6BFF),
            secondary: Color(0xFFFF6B9D),
            surface: Color(0xFF1A1D26),
            background: Color(0xFF0D0F14),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/alarms': (context) => const AlarmListScreen(),
          '/create-alarm': (context) => const CreateAlarmScreen(),
          '/timer': (context) => const TimerScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final provider = Provider.of<AlarmProvider>(context, listen: false);
    await provider.init();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final user = provider.user;
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/alarms');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0F14),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, 0.0),
            radius: 0.80,
            colors: [Color(0x1A4F6BFF), Color(0x004F6BFF)],
            stops: [0, 0.7],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4F6BFF).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(Icons.alarm, size: 60, color: Color(0xFF4F6BFF)),
              ),
              SizedBox(height: 20),
              Text(
                'XAlarm',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Extreme Pro Max',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
