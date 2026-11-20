import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/dates.dart';
import '../../data/local/app_database.dart';
import '../../data/providers.dart';
import 'checkin_providers.dart';
import '../auth/auth_controller.dart';

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
  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Записи на этом устройстве будут удалены.'),
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
    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentCheckinsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
       appBar: AppBar(
        title: const Text('Сегодня'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Как прошёл день?', style: textTheme.titleLarge),
                const SizedBox(height: 16),
                _ScoreSlider(
                  label: 'Настроение',
                  value: _mood,
                  onChanged: (v) => setState(() => _mood = v),
                ),
                _ScoreSlider(
                  label: 'Энергия',
                  value: _energy,
                  onChanged: (v) => setState(() => _energy = v),
                ),
                _ScoreSlider(
                  label: 'Продуктивность',
                  value: _productivity,
                  onChanged: (v) => setState(() => _productivity = v),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Заметка (необязательно)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_hasToday ? 'Обновить чек-ин' : 'Сохранить чек-ин'),
                ),
                const SizedBox(height: 32),
                Text('Последние 7 дней', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                recent.when(
                  data: (items) => items.isEmpty
                      ? const Text('Пока нет чек-инов — сделай первый.')
                      : Column(
                          children: [
                            for (final c in items)
                              _CheckinTile(
                                checkin: c,
                                isToday: c.date == _todayKey,
                              ),
                          ],
                        ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Ошибка загрузки: $e'),
                ),
              ],
            ),
    );
  }
}

/// Label, current value and a 1..10 slider.
class _ScoreSlider extends StatelessWidget {
  const _ScoreSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: textTheme.titleSmall),
            const Spacer(),
            Text('$value', style: textTheme.titleMedium),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9, // 9 steps between 1 and 10 -> whole numbers only
          label: '$value',
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

/// One row in the "last 7 days" list.
class _CheckinTile extends StatelessWidget {
  const _CheckinTile({required this.checkin, required this.isToday});

  final DailyCheckin checkin;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(checkin.date);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(isToday ? 'Сегодня' : '$day.$month'),
      subtitle: Text(
        'Настроение ${checkin.mood} · Энергия ${checkin.energy} · '
        'Продуктивность ${checkin.productivity}',
      ),
      trailing: checkin.note == null ? null : const Icon(Icons.notes_outlined),
    );
  }
}