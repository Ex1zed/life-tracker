import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/dates.dart';
import '../../core/theme.dart';
import '../../data/local/app_database.dart';
import '../../data/providers.dart';
import '../settings/settings_screen.dart';
import 'checkin_providers.dart';
import 'score_row.dart';
import 'week_chart.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  final _noteController = TextEditingController();
  int _mood = 5;
  int _energy = 5;
  int _productivity = 5;
  bool _loading = true;
  bool _saving = false;
  bool _hasToday = false;

  String get _todayKey => toDateKey(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  /// Prefills the form if today's check-in already exists.
  Future<void> _loadToday() async {
    final existing =
        await ref.read(checkinRepositoryProvider).getForDate(_todayKey);
    if (!mounted) return;
    setState(() {
      if (existing != null) {
        _mood = existing.mood;
        _energy = existing.energy;
        _productivity = existing.productivity;
        _noteController.text = existing.note ?? '';
        _hasToday = true;
      }
      _loading = false;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus(); // hide the keyboard
    setState(() => _saving = true);
    try {
      await ref.read(checkinRepositoryProvider).saveForDate(
            date: _todayKey,
            mood: _mood,
            energy: _energy,
            productivity: _productivity,
            note: _noteController.text,
          );
      // Saved locally; send it to the server in the background.
      unawaited(ref.read(syncServiceProvider).syncNow());
      if (!mounted) return;
      setState(() => _hasToday = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Чек-ин сохранён')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось сохранить: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
    );
  }

  /// Monday..Sunday of the current week. Today shows the form's live values,
  /// so the chart reacts while the user is still picking scores.
  List<WeekDayScores> _weekDays(List<DailyCheckin> recent) {
    final now = DateTime.now();
    final monday = startOfWeek(now);
    final byDate = {for (final c in recent) c.date: c};

    return [
      for (var i = 0; i < 7; i++)
        _dayScores(
          DateTime(monday.year, monday.month, monday.day + i),
          byDate,
        ),
    ];
  }

  WeekDayScores _dayScores(DateTime day, Map<String, DailyCheckin> byDate) {
    final key = toDateKey(day);
    if (key == _todayKey) {
      return WeekDayScores(
        label: shortWeekday(day),
        isToday: true,
        mood: _mood,
        energy: _energy,
        productivity: _productivity,
      );
    }
    final checkin = byDate[key];
    return WeekDayScores(
      label: shortWeekday(day),
      isToday: false,
      mood: checkin?.mood,
      energy: checkin?.energy,
      productivity: checkin?.productivity,
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // Recent check-ins feed the week chart; while loading, it's just empty.
    final recent =
        ref.watch(recentCheckinsProvider).value ?? const <DailyCheckin>[];

    return Scaffold(
      body: SafeArea(
        bottom: false, // the navigation bar below handles the bottom inset
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _Header(
                    date: formatLongDate(DateTime.now()),
                    onSettings: _openSettings,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          ScoreRow(
                            label: 'Настроение',
                            value: _mood,
                            color: colors.mood,
                            onChanged: (v) => setState(() => _mood = v),
                          ),
                          const Divider(),
                          ScoreRow(
                            label: 'Энергия',
                            value: _energy,
                            color: colors.energy,
                            onChanged: (v) => setState(() => _energy = v),
                          ),
                          const Divider(),
                          ScoreRow(
                            label: 'Продуктивность',
                            value: _productivity,
                            color: colors.productivity,
                            onChanged: (v) =>
                                setState(() => _productivity = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          minLines: 1,
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Пара слов о дне…',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        child: Text(_hasToday ? 'Обновить' : 'Готово'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  WeekChart(days: _weekDays(recent)),
                ],
              ),
      ),
    );
  }
}

/// Date, title and the settings button.
class _Header extends StatelessWidget {
  const _Header({required this.date, required this.onSettings});

  final String date;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.muted,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Сегодня',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onSettings,
          tooltip: 'Настройки',
          icon: const Icon(Icons.tune),
          style: IconButton.styleFrom(
            fixedSize: const Size(44, 44),
            backgroundColor: colors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}