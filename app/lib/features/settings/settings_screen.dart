import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/local/app_database.dart';
import '../../data/providers.dart';
import '../auth/auth_controller.dart';
import 'settings_providers.dart';

/// "21:00" for 1260 minutes since midnight.
String formatMinutes(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _defaultEveningReminder = 21 * 60;

  /// Shows a 24-hour time picker; returns minutes since midnight or null.
  Future<int?> _pickTime(int minutes) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    return picked == null ? null : picked.hour * 60 + picked.minute;
  }

  Future<void> _changeBedtime(UserSettings s) async {
    final minutes = await _pickTime(s.bedtime);
    if (minutes == null || !mounted) return;
    await ref.read(settingsRepositoryProvider).setBedtime(minutes);
  }

  Future<void> _changeEveningTime(UserSettings s) async {
    final minutes = await _pickTime(s.eveningReminder ?? _defaultEveningReminder);
    if (minutes == null || !mounted) return;
    await ref.read(settingsRepositoryProvider).setEveningReminder(minutes);
  }

  Future<void> _toggleEvening(bool on) => ref
      .read(settingsRepositoryProvider)
      .setEveningReminder(on ? _defaultEveningReminder : null);

  Future<void> _confirmSignOut() async {
    final confirmed = await _ask(
      title: 'Выйти из аккаунта?',
      text: 'Записи отправятся на сервер и удалятся с этого устройства.',
    );
    if (confirmed != true || !mounted) return;

    // Upload everything first: sign-out wipes the local database.
    await ref.read(syncServiceProvider).syncNow();
    final unsent = await ref.read(checkinRepositoryProvider).pendingSync();
    if (!mounted) return;

    if (unsent.isNotEmpty) {
      final force = await _ask(
        title: 'Не всё отправлено',
        text: 'Нет связи с сервером. Неотправленные записи '
            '(${unsent.length}) будут потеряны. Выйти всё равно?',
      );
      if (force != true || !mounted) return;
    }

    // Take the notifier before leaving: after popUntil this screen is gone
    // and its ref can't be used anymore.
    final auth = ref.read(authControllerProvider.notifier);
    // Close Settings, otherwise it would stay on top of the login screen.
    Navigator.of(context).popUntil((route) => route.isFirst);
    await auth.signOut();
  }

  Future<bool?> _ask({required String title, required String text}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final email = ref.watch(myEmailProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (s) {
          // Wind-down starts this many minutes before bedtime (wraps midnight).
          final windDownStart = (s.bedtime - s.windDownMinutes) % (24 * 60);
          final evening = s.eveningReminder;

          return ListView(
            children: [
              const _SectionHeader('Аккаунт'),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(
                  email.when(
                    data: (value) => value ?? 'Почта не указана',
                    error: (_, _) => 'Нет связи с сервером',
                    loading: () => 'Загрузка…',
                  ),
                ),
                subtitle: const Text('Вход по почте'),
              ),
              const _SectionHeader('Сон'),
              ListTile(
                leading: const Icon(Icons.bedtime_outlined),
                title: const Text('Время отбоя'),
                subtitle: Text(
                  'Подготовка ко сну — с ${formatMinutes(windDownStart)}',
                ),
                trailing: Text(
                  formatMinutes(s.bedtime),
                  style: theme.textTheme.titleMedium,
                ),
                onTap: () => _changeBedtime(s),
              ),
              const _SectionHeader('Напоминания'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Вечерний чек-ин'),
                subtitle: Text(
                  evening == null
                      ? 'Выключено'
                      : 'Каждый день в ${formatMinutes(evening)}',
                ),
                value: evening != null,
                onChanged: _toggleEvening,
              ),
              if (evening != null)
                ListTile(
                  leading: const SizedBox(width: 24), // align with the switch row
                  title: const Text('Время напоминания'),
                  trailing: Text(
                    formatMinutes(evening),
                    style: theme.textTheme.titleMedium,
                  ),
                  onTap: () => _changeEveningTime(s),
                ),
              const SizedBox(height: 24),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text(
                  'Выйти из аккаунта',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: _confirmSignOut,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Small colored title above a group of settings.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}