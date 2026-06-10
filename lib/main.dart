import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/models/alarm_model.dart';
import 'data/repositories/alarm_repository.dart';
import 'presentation/providers/alarm_providers.dart';
import 'presentation/providers/preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter());

  // Initialize repository (seeds sample data)
  final repo = AlarmRepository();
  await repo.init();

  // Status bar styling
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF161820),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        alarmRepositoryProvider.overrideWithValue(repo),
      ],
      child: const XAlarmApp(),
    ),
  );
}

class XAlarmApp extends ConsumerWidget {
  const XAlarmApp({super.key});

  // Figma mobile design width.
  static const double _phoneWidth = 412;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePref = ref.watch(preferencesProvider).themeMode;
    // Map our enum → Flutter's ThemeMode
    final flutterThemeMode = switch (themePref) {
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.system => ThemeMode.system,
    };

    return MaterialApp.router(
      title: 'XAlarm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: flutterThemeMode,
      routerConfig: appRouter,
      // ── Mobile-frame builder ──────────────────────────────────────
      // The Figma design is a mobile (portrait) UI ≈ 412 px wide.
      // On real phones the viewport is already narrow → no framing.
      // On desktop browsers the viewport is huge → we center the app
      // inside a 412-px column on a black backdrop so it matches the
      // original mobile layout instead of stretching across the screen.
      builder: (context, child) {
        final width = MediaQuery.of(context).size.width;
        if (width <= 500 || child == null) return child ?? const SizedBox.shrink();

        return ColoredBox(
          color: Colors.black,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                width: _phoneWidth,
                height: double.infinity,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
