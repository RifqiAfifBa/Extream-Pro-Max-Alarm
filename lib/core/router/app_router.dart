import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_alarm/add_alarm_screen.dart';
import '../../presentation/screens/timer/timer_screen.dart';
import '../../presentation/screens/challenge/choose_challenge_screen.dart';
import '../../presentation/screens/anti_cheat/anti_cheat_screen.dart';
import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/shell/main_shell.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/edit_profile/edit_profile_screen.dart';
import '../../presentation/screens/help/help_support_screen.dart';
import '../../presentation/screens/alarm_ringing/alarm_ringing_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/legal/privacy_policy_screen.dart';
import '../../presentation/screens/legal/terms_of_service_screen.dart';
import '../../presentation/screens/achievements/achievements_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // ── Splash & Login (no shell, no bottom nav) ─────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    // ── Main shell routes (with bottom nav) ──────────────────────────
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/alarm',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/timer',
          builder: (context, state) => const TimerScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/add-alarm',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AddAlarmScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/choose-challenge',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ChooseChallengeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/anti-cheat',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AntiCheatScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AnalyticsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const EditProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/help',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HelpSupportScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/alarm-ringing',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AlarmRingingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade + scale — alarm pops up like a system overlay
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    ),
    // ── Onboarding ─────────────────────────────────────────────────────
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    // ── Legal pages ────────────────────────────────────────────────────
    GoRoute(
      path: '/privacy',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const PrivacyPolicyScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/tos',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const TermsOfServiceScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/achievements',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AchievementsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    ),
  ],
);
