import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../data/providers.dart';
import '../features/checkin/checkin_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/sleep/sleep_screen.dart';

/// Root screen with bottom navigation between the four main tabs.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;
  late final AppLifecycleListener _lifecycle;

  // Order must match the destinations below.
  static const _screens = <Widget>[
    CheckinScreen(),
    SleepScreen(),
    DashboardScreen(),
    InsightsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _sync(); // right after sign-in or app start
    // The app came back from the background: catch up with the server.
    _lifecycle = AppLifecycleListener(onResume: _sync);
  }

  /// Fire and forget: the UI never waits for sync.
  void _sync() => unawaited(ref.read(syncServiceProvider).syncNow());

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all tabs alive, so switching tabs doesn't reset them.
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Сегодня',
          ),
          NavigationDestination(
            icon: Icon(Icons.bedtime_outlined),
            selectedIcon: Icon(Icons.bedtime),
            label: 'Сон',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Дашборд',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Инсайты',
          ),
        ],
      ),
    );
  }
}