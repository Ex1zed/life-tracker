import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';

/// A word for the score, shown under its name.
String scoreHint(int value) {
  if (value <= 3) return 'тяжёлый день';
  if (value <= 6) return 'нормально';
  if (value <= 8) return 'хорошо';
  return 'отлично';
}

/// One score: big number, name, −/+ buttons and a 10-segment bar.
class ScoreRow extends StatelessWidget {
  const ScoreRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;

  /// Wide enough for "10" plus a gap, so the label never moves or touches it.
  static const _numberWidth = 56.0;

  /// Every way of changing the value goes through here:
  /// ignores repeats (a drag reports the same segment many times)
  /// and gives a light tap of haptic feedback on each real change.
  void _set(int newValue) {
    if (newValue == value) return;
    HapticFeedback.selectionClick();
    onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: _numberWidth,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      scoreHint(value),
                      style: TextStyle(fontSize: 13, color: colors.muted),
                    ),
                  ],
                ),
              ),
              _RoundButton(
                icon: Icons.remove,
                tooltip: '$label: меньше',
                onPressed: value > 1 ? () => _set(value - 1) : null,
              ),
              const SizedBox(width: 8),
              _RoundButton(
                icon: Icons.add,
                tooltip: '$label: больше',
                onPressed: value < 10 ? () => _set(value + 1) : null,
              ),
            ],
          ),
          const SizedBox(height: 6),
          ScoreBar(value: value, color: color, label: label, onChanged: _set),
        ],
      ),
    );
  }
}

/// Ten segments; tap or drag across to pick 1..10.
class ScoreBar extends StatelessWidget {
  const ScoreBar({
    super.key,
    required this.value,
    required this.color,
    required this.label,
    required this.onChanged,
  });

  final int value;
  final Color color;
  final String label;
  final ValueChanged<int> onChanged;

  /// Touch area is taller than the 8 px bar, so it's easy to hit.
  static const _touchHeight = 32.0;

  /// x = 0..width maps to segments 1..10.
  static int valueAt(double dx, double width) =>
      (dx / width * 10).ceil().clamp(1, 10);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        void pick(Offset position) =>
            onChanged(valueAt(position.dx, constraints.maxWidth));

        return Semantics(
          label: label,
          value: '$value из 10',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, // the gaps react to taps too
            onTapDown: (details) => pick(details.localPosition),
            onHorizontalDragUpdate: (details) => pick(details.localPosition),
            child: SizedBox(
              height: _touchHeight,
              child: Row(
                children: [
                  for (var n = 1; n <= 10; n++) ...[
                    if (n > 1) const SizedBox(width: 4),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 8,
                        decoration: BoxDecoration(
                          color: n <= value ? color : colors.track,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Round 44 px −/+ button; greyed out at the ends of the range.
class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final ink = Theme.of(context).colorScheme.onSurface;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        fixedSize: const Size(44, 44),
        backgroundColor: colors.control,
        foregroundColor: ink,
        disabledBackgroundColor: colors.control,
        disabledForegroundColor: colors.muted.withValues(alpha: 0.4),
      ),
    );
  }
}