import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// App colour palette — MealMate
/// Based on the official MealMate Color Palette.
/// ─────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Primary (Green - Row 1) ──
  static const Color primary = Color(0xFF04B94E);
  static const Color primaryLight = Color(0xFF0BF07E);
  static const Color primaryVariant = Color(0xFF1B8E2F);
  static const Color primaryMedium = Color(0xFF07CA66);
  static const Color primaryDark = Color(0xFF027038);
  static const Color primaryDarker = Color(0xFF014A23);
  static const Color primarySurface = Color(0xFFC2FFD3);

  // ── Primary Extended (Darker Green - Row 2) ──
  static const Color primaryDeep = Color(0xFF0BFBB8);
  static const Color primaryDeepMedium = Color(0xFF04A356);
  static const Color primaryDeepDark = Color(0xFF015329);
  static const Color primaryDeepDarker = Color(0xFF002F15);
  static const Color primaryDeepDarkest = Color(0xFF001506);

  static const LinearGradient primarygradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Secondary / Accent (Orange - Row 3) ──
  static const Color secondary = Color(0xFFF67E15);
  static const Color secondaryLight = Color(0xFFFEB597);
  static const Color secondarySurface = Color(0xFFFFE9E3);
  static const Color secondaryDark = Color(0xFF894407);
  static const Color secondaryDarker = Color(0xFF582903);
  static const Color secondaryDarkest = Color(0xFF2B1101);

  // ── Neutral (Grey - Row 4) ──
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFDDDDDD);
  static const Color disabled = Color(0xFFB6B6B6);
  static const Color border = Color(0xFFDDDDDD);
  static const Color inputBackground = Color(0xFFF2F2F2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF494949);
  static const Color greyLight = Color(0xFF909090);
  static const Color greyDark = Color(0xFF262929);

  // ── Neutral (Dark mode - Row 5) ──
  static const Color backgroundDark = Color(0xFF1F2120);
  static const Color surfaceDark = Color(0xFF3D403E);
  static const Color cardDark = Color(0xFF5E625F);
  static const Color dividerDark = Color(0xFF494949);

  // ── Text ──
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFF909090);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFEEF1EF);
  static const Color textSecondaryDark = Color(0xFFABACA7);
  static const Color lightGrey = Color(0xFFCCD3CD);

  // ── Semantic ──
  static const Color success = Color(0xFF027038);
  static const Color successLight = Color(0xFFC2FFD3);
  static const Color warning = Color(0xFFBE600D);
  static const Color warningLight = Color(0xFFFFE9E3);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ── Rating ──
  static const Color starFilled = Color(0xFFF67E15);
  static const Color starEmpty = Color(0xFFDDDDDD);

  // ── Shimmer ──
  static const Color shimmerBase = Color(0xFFDDDDDD);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF494949);
  static const Color shimmerHighlightDark = Color(0xFF6B6B6B);

  // ── Shadow ──
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // Calendar
  static const Color calendarBackground = Color(0xFFF8FCF9);
  static const Color calendarTextPrimary = Color(0xFF191C1D);
  static const Color calendarTextMuted = Color(0xFF5D5E68);
  static const Color calendarAccent = Color(0xFF00864D);
  static const Color calendarAccentDark = Color(0xFF006D40);
  static const Color calendarCurrent = Color(0xFFFF6B57);
  static const Color calendarCurrentDark = Color(0xFFAE3123);
  static const Color calendarError = Color(0xFFD52A20);
  static const Color calendarBorder = Color(0xFFE1E3E4);
  static const Color calendarSoftBorder = Color(0xFFE8E9EA);
  static const Color calendarCardBorder = Color(0xFFE8E8E8);
  static const Color calendarIndicatorBorder = Color(0xFFF8F9FA);
  static const Color calendarSurface = Color(0xFFFDFDFD);
  static const Color calendarTextSecondary = Color(0xFF777982);
  static const Color calendarTextBrown = Color(0xFF59413D);
  static const Color calendarActionBrown = Color(0xFF7A605C);
  static const Color calendarDayText = Color(0xFF242729);
  static const Color calendarDateText = Color(0xFF303337);
  static const Color calendarProgress = Color(0xFF007A49);
  static const Color calendarProgressTrack = Color(0xFFE1EEE7);
  static const Color calendarProgressText = Color(0xFF686873);
  static const Color calendarProgressBadge = Color(0xFFCDEADE);
  static const Color calendarTimelineInactive = Color(0x4D48AD75);
  static const Color calendarTimelineDivider = Color(0xFFE7E8E9);
  static const Color calendarShadow = Color(0x0D000000);
  static const Color calendarLightShadow = Color(0x08000000);
  static const Color calendarCardShadow = Color(0x1A000000);
  static const Color calendarCurrentShadow = Color(0x66FF6B57);
}
