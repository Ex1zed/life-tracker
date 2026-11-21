import 'package:material_ui/material_ui.dart';

/// Colors from the design (variant B) that ColorScheme has no slot for.
/// In widgets: `final c = AppColors.of(context);` then `c.mood`, `c.card`...
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.mood,
    required this.energy,
    required this.productivity,
    required this.card,
    required this.muted,
    required this.track,
    required this.control,
    required this.divider,
  });

  /// One color per score, used for bars, dots and charts.
  final Color mood;
  final Color energy;
  final Color productivity;

  /// Background of cards.
  final Color card;

  /// Secondary text and inactive icons.
  final Color muted;

  /// Empty segments of a score bar.
  final Color track;

  /// Background of round −/+ buttons.
  final Color control;

  final Color divider;

  static const light = AppColors(
    mood: Color(0xFFF59E0B),
    energy: Color(0xFF14B8A6),
    productivity: Color(0xFF4F46E5),
    card: Color(0xFFFFFFFF),
    muted: Color(0xFF5B6070),
    track: Color(0xFFE9EAF0),
    control: Color(0xFFF1F2F6),
    divider: Color(0xFFEEF0F4),
  );

  static const dark = AppColors(
    mood: Color(0xFFFBBF24),
    energy: Color(0xFF2DD4BF),
    productivity: Color(0xFFA5B4FC),
    card: Color(0xFF181B24),
    muted: Color(0xFF9AA0B2),
    track: Color(0xFF262A36),
    control: Color(0xFF262A36),
    divider: Color(0xFF1E222C),
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? mood,
    Color? energy,
    Color? productivity,
    Color? card,
    Color? muted,
    Color? track,
    Color? control,
    Color? divider,
  }) {
    return AppColors(
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      productivity: productivity ?? this.productivity,
      card: card ?? this.card,
      muted: muted ?? this.muted,
      track: track ?? this.track,
      control: control ?? this.control,
      divider: divider ?? this.divider,
    );
  }

  /// Smooth transition when the theme switches between light and dark.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      mood: Color.lerp(mood, other.mood, t)!,
      energy: Color.lerp(energy, other.energy, t)!,
      productivity: Color.lerp(productivity, other.productivity, t)!,
      card: Color.lerp(card, other.card, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      track: Color.lerp(track, other.track, t)!,
      control: Color.lerp(control, other.control, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

/// Built once; MaterialApp switches between them by themeMode.
final ThemeData lightTheme = buildTheme(Brightness.light);
final ThemeData darkTheme = buildTheme(Brightness.dark);

ThemeData buildTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final colors = isLight ? AppColors.light : AppColors.dark;

  final background = isLight ? const Color(0xFFF5F6FA) : const Color(0xFF0E1016);
  final ink = isLight ? const Color(0xFF151823) : const Color(0xFFF2F3F7);
  final accent = isLight ? const Color(0xFF4F46E5) : const Color(0xFFA5B4FC);
  final onAccent = isLight ? Colors.white : const Color(0xFF0E1016);
  final accentSoft = isLight ? const Color(0xFFE8E7FD) : const Color(0xFF2A2F45);

  // Start from a generated scheme (dialogs, pickers, etc. need all slots),
  // then pin the colors the design defines.
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4F46E5),
    brightness: brightness,
  ).copyWith(
    primary: accent,
    onPrimary: onAccent,
    secondaryContainer: accentSoft,
    onSecondaryContainer: ink,
    surface: background,
    onSurface: ink,
    onSurfaceVariant: colors.muted,
    outlineVariant: colors.divider,
  );

  final selected = WidgetState.selected;

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    extensions: [colors],
    appBarTheme: AppBarThemeData(
      backgroundColor: background,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: ink,
      ),
    ),
    cardTheme: CardThemeData(
      color: colors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: colors.card,
      hintStyle: TextStyle(color: colors.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.card,
      indicatorColor: accentSoft,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight:
              states.contains(selected) ? FontWeight.w600 : FontWeight.w500,
          color: states.contains(selected) ? accent : colors.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(selected) ? accent : colors.muted,
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(iconColor: colors.muted),
    dividerTheme: DividerThemeData(color: colors.divider, space: 1, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}