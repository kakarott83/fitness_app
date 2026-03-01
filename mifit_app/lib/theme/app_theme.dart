import 'package:flutter/material.dart';

// ─── Farb-Palette ─────────────────────────────────────────────────────────────
// Alle App-Farben an einem Ort. Beim Hinzufügen eines neuen Themes nur hier
// neue Konstanten definieren und ein ThemeData in AppTheme anlegen.
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Akzentfarben (theme-unabhängig / semantisch)
  static const Color primary    = Color(0xFF4361EE);
  static const Color secondary  = Color(0xFF4CC9F0);
  static const Color success    = Color(0xFF2ECC71);
  static const Color warning    = Color(0xFFFF9F43);
  static const Color error      = Color(0xFFE74C3C);
  static const Color orange     = Color(0xFFFF9F43);
  static const Color green      = Color(0xFF2ECC71);

  // ── Dark Navy Theme ──────────────────────────────────────────────────────
  static const Color darkScaffold            = Color(0xFF0D1117);
  static const Color darkSurface             = Color(0xFF161B27);
  static const Color darkCard                = Color(0xFF1C2135);
  static const Color darkOutline             = Color(0xFF2D3145);
  static const Color darkOnSurface           = Color(0xFFE6EAF5);
  static const Color darkOnSurfaceVariant    = Color(0xFF8892B0);
  static const Color darkPrimaryContainer    = Color(0xFF2D3D9E);

  // ── Light Theme ──────────────────────────────────────────────────────────
  static const Color lightScaffold           = Color(0xFFF4F6FB);
  static const Color lightSurface            = Color(0xFFFFFFFF);
  static const Color lightCard               = Color(0xFFFFFFFF);
  static const Color lightOutline            = Color(0xFFE2E8F0);
  static const Color lightOnSurface         = Color(0xFF1A1D2E);
  static const Color lightOnSurfaceVariant  = Color(0xFF64748B);
  static const Color lightPrimaryContainer   = Color(0xFFE8EAFF);
}

// ─── ThemeNotifier ────────────────────────────────────────────────────────────
// Hält den aktuellen ThemeMode. Kann von jedem Widget via
// AppTheme.themeNotifier.value = ThemeMode.X gesetzt werden.
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  // ── Dark ─────────────────────────────────────────────────────────────────

  static ThemeData get dark {
    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary:              AppColors.primary,
      onPrimary:            Colors.white,
      primaryContainer:     AppColors.darkPrimaryContainer,
      onPrimaryContainer:   Colors.white,
      secondary:            AppColors.secondary,
      onSecondary:          Colors.white,
      secondaryContainer:   Color(0xFF1A3A47),
      onSecondaryContainer: Colors.white,
      tertiary:             AppColors.success,
      onTertiary:           Colors.white,
      error:                AppColors.error,
      onError:              Colors.white,
      surface:              AppColors.darkSurface,
      onSurface:            AppColors.darkOnSurface,
      onSurfaceVariant:     AppColors.darkOnSurfaceVariant,
      outline:              AppColors.darkOutline,
      shadow:               Colors.black,
      scrim:                Colors.black,
      inverseSurface:       AppColors.darkOnSurface,
      onInverseSurface:     AppColors.darkScaffold,
      inversePrimary:       AppColors.primary,
      surfaceContainerHighest: AppColors.darkCard,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkScaffold,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.darkOnSurface),
        actionsIconTheme: IconThemeData(color: AppColors.darkOnSurfaceVariant),
      ),
      // Cards
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.darkOutline, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        labelStyle: const TextStyle(color: AppColors.darkOnSurfaceVariant),
        hintStyle: const TextStyle(color: AppColors.darkOnSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 0.5,
      ),
      // ListTile
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.darkOnSurfaceVariant,
      ),
      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.darkOnSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.4);
          }
          return AppColors.darkOutline;
        }),
      ),
      // SegmentedButton
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.2);
            }
            return AppColors.darkCard;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.darkOnSurfaceVariant;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.darkOutline),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkOnSurfaceVariant),
    );
  }

  // ── Light ────────────────────────────────────────────────────────────────

  static ThemeData get light {
    const cs = ColorScheme(
      brightness: Brightness.light,
      primary:              AppColors.primary,
      onPrimary:            Colors.white,
      primaryContainer:     AppColors.lightPrimaryContainer,
      onPrimaryContainer:   AppColors.primary,
      secondary:            AppColors.secondary,
      onSecondary:          Colors.white,
      secondaryContainer:   Color(0xFFCCF2FF),
      onSecondaryContainer: Color(0xFF003B4D),
      tertiary:             AppColors.success,
      onTertiary:           Colors.white,
      error:                AppColors.error,
      onError:              Colors.white,
      surface:              AppColors.lightSurface,
      onSurface:            AppColors.lightOnSurface,
      onSurfaceVariant:     AppColors.lightOnSurfaceVariant,
      outline:              AppColors.lightOutline,
      shadow:               Colors.black,
      scrim:                Colors.black,
      inverseSurface:       AppColors.lightOnSurface,
      onInverseSurface:     Colors.white,
      inversePrimary:       Color(0xFF9BA8F8),
      surfaceContainerHighest: Color(0xFFF1F5F9),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.lightScaffold,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightScaffold,
        foregroundColor: AppColors.lightOnSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.lightOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.lightOnSurface),
        actionsIconTheme: IconThemeData(color: AppColors.lightOnSurfaceVariant),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.lightOutline, width: 0.8),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        labelStyle: const TextStyle(color: AppColors.lightOnSurfaceVariant),
        hintStyle: const TextStyle(color: AppColors.lightOnSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightOutline,
        thickness: 0.8,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.lightOnSurfaceVariant,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.lightOutline;
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.1);
            }
            return AppColors.lightSurface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.lightOnSurfaceVariant;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.lightOutline),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.lightOnSurfaceVariant),
    );
  }
}
