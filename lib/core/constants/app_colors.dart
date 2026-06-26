import 'package:flutter/material.dart';

/// SinhaX Design System — Color Tokens
/// Light and Dark palettes share the same token names.
/// Use [AppColors.of(context)] to get the correct set for the current theme.
class AppColors {
  const AppColors._();

  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF4F6EF7); // electric indigo
  static const Color primaryLight   = Color(0xFF7B96FF);
  static const Color primaryDark    = Color(0xFF3251E0);
  static const Color primarySurface = Color(0xFFEEF2FF); // light bg tint

  static const Color accent         = Color(0xFF00D4AA); // teal/cyan
  static const Color accentDark     = Color(0xFF00A887);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const List<Color> primaryGradient = [
    Color(0xFF4F6EF7),
    Color(0xFF7B96FF),
  ];

  static const List<Color> heroGradientLight = [
    Color(0xFF0D1B6E),
    Color(0xFF1A33C8),
    Color(0xFF4F6EF7),
  ];

  static const List<Color> heroGradientDark = [
    Color(0xFF070D38),
    Color(0xFF0F1E80),
    Color(0xFF2B44CC),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00D4AA),
    Color(0xFF4F6EF7),
  ];

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color profit         = Color(0xFF16C784); // green for gains
  static const Color profitSurface  = Color(0xFFE9FBF3);
  static const Color loss           = Color(0xFFEA3943); // red for losses
  static const Color lossSurface    = Color(0xFFFEECED);
  static const Color warning        = Color(0xFFF5A623);
  static const Color warningSurface = Color(0xFFFFF4E0);
  static const Color info           = Color(0xFF3D9CF5);
  static const Color infoSurface    = Color(0xFFE8F4FF);

  // Aliases for backward-compat with existing widgets
  static const Color success        = profit;
  static const Color successSurface = profitSurface;
  static const Color error          = loss;
  static const Color errorSurface   = lossSurface;

  // ─── Light Palette ────────────────────────────────────────────────────────
  static const Color background     = Color(0xFFF5F7FF);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceAlt     = Color(0xFFEDF0FF);
  static const Color white          = Color(0xFFFFFFFF);
  static const Color border         = Color(0xFFE4E8F7);
  static const Color divider        = Color(0xFFEDF0FF);

  static const Color textPrimary    = Color(0xFF0C1240);
  static const Color textSecondary  = Color(0xFF5A6483);
  static const Color textTertiary   = Color(0xFF9AA3C2);
  static const Color textOnPrimary  = Color(0xFFFFFFFF);

  // ─── Dark Palette ─────────────────────────────────────────────────────────
  static const Color darkBackground   = Color(0xFF0A0D1F);
  static const Color darkSurface      = Color(0xFF111428);
  static const Color darkSurfaceAlt   = Color(0xFF1A1E38);
  static const Color darkSurfaceCard  = Color(0xFF161A30);
  static const Color darkBorder       = Color(0xFF252A47);
  static const Color darkDivider      = Color(0xFF1E2340);

  static const Color darkTextPrimary  = Color(0xFFE8EAFF);
  static const Color darkTextSecondary= Color(0xFF8892C0);
  static const Color darkTextTertiary = Color(0xFF4D5580);

  static const Color darkPrimarySurface = Color(0xFF1A2060);

  static const Color darkProfit        = Color(0xFF1AD98F);
  static const Color darkProfitSurface = Color(0xFF0D2920);
  static const Color darkLoss          = Color(0xFFFF4D56);
  static const Color darkLossSurface   = Color(0xFF2A0F10);

  // ─── Chart ────────────────────────────────────────────────────────────────
  static const Color chartLine     = Color(0xFF4F6EF7);
  static const Color chartFill     = Color(0x264F6EF7);
  static const Color chartPositive = Color(0xFF16C784);
  static const Color chartNegative = Color(0xFFEA3943);

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Returns true if the current theme is dark.
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Adaptive getters — use these in widgets that need to respond to the theme

  static Color bg(BuildContext context) =>
      isDark(context) ? darkBackground : background;

  static Color card(BuildContext context) =>
      isDark(context) ? darkSurfaceCard : surface;

  static Color cardAlt(BuildContext context) =>
      isDark(context) ? darkSurfaceAlt : surfaceAlt;

  static Color borderColor(BuildContext context) =>
      isDark(context) ? darkBorder : border;

  static Color text1(BuildContext context) =>
      isDark(context) ? darkTextPrimary : textPrimary;

  static Color text2(BuildContext context) =>
      isDark(context) ? darkTextSecondary : textSecondary;

  static Color text3(BuildContext context) =>
      isDark(context) ? darkTextTertiary : textTertiary;

  static Color gainColor(BuildContext context) =>
      isDark(context) ? darkProfit : profit;

  static Color gainSurface(BuildContext context) =>
      isDark(context) ? darkProfitSurface : profitSurface;

  static Color lossColor(BuildContext context) =>
      isDark(context) ? darkLoss : loss;

  static Color lossSurfaceColor(BuildContext context) =>
      isDark(context) ? darkLossSurface : lossSurface;

  static Color primarySurfaceColor(BuildContext context) =>
      isDark(context) ? darkPrimarySurface : primarySurface;

  static List<Color> heroGradient(BuildContext context) =>
      isDark(context) ? heroGradientDark : heroGradientLight;
}
