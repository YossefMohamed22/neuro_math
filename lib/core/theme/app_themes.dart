import 'package:flutter/material.dart';

class AppThemes {
  // Define consistent colors for reuse
  static const Color primaryLight = Color(0xFF6A82FB); // Example primary color
  static const Color primaryDark =
      Color(0xFF8A9EFF); // Lighter primary for dark mode
  static const Color accentLight = Color(0xFFB477F8); // Example accent color
  static const Color accentDark =
      Color(0xFFC997FF); // Lighter accent for dark mode

  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark =
      Color(0xFF121212); // Standard dark background
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark =
      Color(0xFF1E1E1E); // Slightly lighter dark surface

  static const Color textLight = Colors.black87;
  static const Color textDark = Colors.white;
  static const Color textSecondaryLight = Colors.black54;
  static const Color textSecondaryDark = Colors.white60;

  static const Color buttonTextLight = Colors.white;
  static const Color buttonTextDark = Colors.black87;

  static const Color gradientStartLight = Color(0xFF6A82FB); // Blueish
  static const Color gradientEndLight = Color(0xFFB477F8); // Purpleish

  static const Color gradientStartDark = Color(0xFF1F2544); // Dark Blue
  static const Color gradientEndDark = Color(0xFF474F7A); // Dark Purple/Grey

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.light(
      primary: primaryLight,
      secondary: accentLight,
      surface: surfaceLight,
      onPrimary: buttonTextLight,
      onSecondary: buttonTextLight,
      onSurface: textLight,
    ),
    appBarTheme: const AppBarTheme(
      color: primaryLight,
      iconTheme: IconThemeData(color: buttonTextLight),
      titleTextStyle: TextStyle(
          color: buttonTextLight, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: buttonTextLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
    ),
    // Define custom extension for gradient colors
    extensions: <ThemeExtension<dynamic>>[
      AppGradients(start: gradientStartLight, end: gradientEndLight),
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: accentDark,
      surface: surfaceDark,
      onPrimary: buttonTextDark,
      onSecondary: buttonTextDark,
      onSurface: textDark,
    ),
    appBarTheme: const AppBarTheme(
      color: surfaceDark, // Use surface color for dark app bars
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle:
          TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: buttonTextDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      fillColor: surfaceDark, // Fill input fields in dark mode
      filled: true,
    ),
    // Define custom extension for gradient colors
    extensions: <ThemeExtension<dynamic>>[
      AppGradients(start: gradientStartDark, end: gradientEndDark),
    ],
  );
}

// Custom Theme Extension for Gradients
@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.start,
    required this.end,
  });

  final Color start;
  final Color end;

  @override
  AppGradients copyWith({Color? start, Color? end}) {
    return AppGradients(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) {
      return this;
    }
    return AppGradients(
      start: Color.lerp(start, other.start, t)!,
      end: Color.lerp(end, other.end, t)!,
    );
  }

  // Optional: Override toString, hashCode, == if needed
}
