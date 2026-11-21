import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

/// Scores of one day of the week; null scores = no check-in that day.
class WeekDayScores {
  const WeekDayScores({
    required this.label,
    required this.isToday,
    this.mood,
    this.energy,
    this.productivity,
  });

  final String label;
  final bool isToday;
  final int? mood;
  final int? energy;
  final int? productivity;
}

/// "Эта неделя": three thin bars per day, Monday to Sunday.
class WeekChart extends StatelessWidget {
  const WeekChart({super.key, required this.days});

  final List<WeekDayScores> days;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Эта неделя',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                _Legend(color: colors.mood, label: 'Настр.'),
                const SizedBox(width: 10),
                _Legend(color: colors.energy, label: 'Энерг.'),
                const SizedBox(width: 10),
                _Legend(color: colors.productivity, label: 'Прод.'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final day in days) Expanded(child: _DayColumn(day: day)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({required this.day});

  final WeekDayScores day;

  static const _maxBarHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final ink = Theme.of(context).colorScheme.onSurface;

    Widget bar(int? value, Color color) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 7,
          // No check-in: a short grey stub, so the day doesn't look broken.
          height: value == null ? 4 : value * _maxBarHeight / 10,
          decoration: BoxDecoration(
            color: value == null ? colors.track : color,
            borderRadius: BorderRadius.circular(3),
          ),
        );

    return Column(
      children: [
        SizedBox(
          height: _maxBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              bar(day.mood, colors.mood),
              const SizedBox(width: 3),
              bar(day.energy, colors.energy),
              const SizedBox(width: 3),
              bar(day.productivity, colors.productivity),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: day.isToday ? FontWeight.w700 : FontWeight.w500,
            color: day.isToday ? ink : colors.muted,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.of(context).muted),
        ),
      ],
    );
  }
}