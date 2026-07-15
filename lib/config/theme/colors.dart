import 'package:flutter/material.dart';

/// Centralized MealMate color tokens from the Figma color palette.
class AppColors {
  AppColors._();

  // Brand primary scale.
  static const Color primary100 = Color(0xFFC2FFD3);
  static const Color primary200 = Color(0xFF0BF07E);
  static const Color primary300 = Color(0xFF07C466);
  static const Color primary400 = Color(0xFF04994E);
  static const Color primary500 = Color(0xFF027038);
  static const Color primary600 = Color(0xFF014A23);
  static const Color primary700 = Color(0xFF00270F);

  // Brand secondary green scale.
  static const Color secondary100 = Color(0xFF0BFB88);
  static const Color secondary200 = Color(0xFF07CE6F);
  static const Color secondary300 = Color(0xFF04A356);
  static const Color secondary400 = Color(0xFF027A3F);
  static const Color secondary500 = Color(0xFF015329);
  static const Color secondary600 = Color(0xFF002F15);
  static const Color secondary700 = Color(0xFF001506);

  // Brand tertiary orange scale.
  static const Color tertiary100 = Color(0xFFFFE9E3);
  static const Color tertiary200 = Color(0xFFFEB597);
  static const Color tertiary300 = Color(0xFFF67E15);
  static const Color tertiary400 = Color(0xFFBE600D);
  static const Color tertiary500 = Color(0xFF894407);
  static const Color tertiary600 = Color(0xFF582903);
  static const Color tertiary700 = Color(0xFF2B1101);

  // Neutral scale from the Figma palette.
  static const Color quaternary100 = Color(0xFFDDDDDD);
  static const Color quaternary200 = Color(0xFFB6B6B6);
  static const Color quaternary300 = Color(0xFF909090);
  static const Color quaternary400 = Color(0xFF6B6B6B);
  static const Color quaternary500 = Color(0xFF494949);
  static const Color quaternary600 = Color(0xFF292929);
  static const Color quaternary700 = Color(0xFF111111);

  static const Color grey100 = Color(0xFFEEF1EF);
  static const Color grey200 = Color(0xFFCCD3CD);
  static const Color grey300 = Color(0xFFA6ACA7);
  static const Color grey400 = Color(0xFF818682);
  static const Color grey500 = Color(0xFF5E625F);
  static const Color grey600 = Color(0xFF3D403E);
  static const Color grey700 = Color(0xFF1F2120);

  // Core aliases used across the app.
  static const Color primary = Color(0xFF137A43);
  static const Color primaryLight = primary200;
  static const Color primaryMedium = primary300;
  static const Color primaryDark = primary500;
  static const Color primaryDarker = primary600;
  static const Color primaryDarkest = primary700;
  static const Color primarySurface = primary100;
  static const Color primaryVariant = Color(0xFF1B8E2F);

  static const Color primaryDeep = secondary100;
  static const Color primaryDeepMedium = secondary300;
  static const Color primaryDeepDark = secondary500;
  static const Color primaryDeepDarker = secondary600;
  static const Color primaryDeepDarkest = secondary700;

  // Kept as the app accent alias for existing widgets.
  static const Color secondary = tertiary300;
  static const Color secondaryLight = tertiary200;
  static const Color secondarySurface = tertiary100;
  static const Color secondaryDark = tertiary500;
  static const Color secondaryDarker = tertiary600;
  static const Color secondaryDarkest = tertiary700;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [secondary200, primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primarygradient = primaryGradient;

  // Surfaces and content.
  static const Color transparent = Color(0x00000000);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = quaternary100;
  static const Color disabled = quaternary200;
  static const Color border = quaternary100;
  static const Color inputBackground = Color(0xFFF2F2F2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = quaternary500;
  static const Color greyLight = quaternary300;
  static const Color greyDark = quaternary600;
  static const Color lightGrey = grey200;

  static const Color backgroundDark = grey700;
  static const Color surfaceDark = grey600;
  static const Color cardDark = grey500;
  static const Color dividerDark = quaternary500;

  static const Color textPrimary = quaternary700;
  static const Color textSecondary = quaternary400;
  static const Color textHint = quaternary300;
  static const Color textOnPrimary = white;
  static const Color textPrimaryDark = grey100;
  static const Color textSecondaryDark = grey300;

  // Semantic colors.
  static const Color success = primary500;
  static const Color successLight = primary100;
  static const Color warning = tertiary400;
  static const Color warningLight = tertiary100;
  static const Color error = Color(0xFFE00606);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF0C6C3F);
  static const Color infoLight = Color(0xFFEAF0EA);

  static const Color starFilled = tertiary300;
  static const Color starEmpty = quaternary100;

  static const Color shimmerBase = quaternary100;
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = quaternary500;
  static const Color shimmerHighlightDark = quaternary400;

  static const Color shadow = Color(0x1A000000);
  static const Color shadowSoft = Color(0x0A000000);
  static const Color shadowDark = Color(0x33000000);
  static const Color scrim = Color(0x916E6868);

  // Screen-specific tokens promoted from the Figma designs.
  static const Color appText = Color(0xFF24252C);
  static const Color appTextStrong = Color(0xFF242731);
  static const Color appTextMuted = Color(0xFF5A5C62);
  static const Color appSurface = Color(0xFFFEFEFE);
  static const Color appSurfaceSoft = Color(0xFFF6F7F6);
  static const Color appSurfaceMuted = Color(0xFFF2F4EF);
  static const Color profileIconBackground = Color(0xFFECF4ED);
  static const Color appBorder = Color(0xFFECEEED);
  static const Color appDivider = Color(0xFFEAEBEB);
  static const Color brandDeepGreen = Color(0xFF0C6C3F);
  static const Color brandSuccessGreen = Color(0xFF09763B);
  static const Color subscriptionHeroBackground = Color(0xFFF3F5F0);
  static const Color subscriptionHeroBorder = Color(0xFFECF1EC);
  static const Color subscriptionHeroTitle = Color(0xFF418B46);
  static const Color subscriptionPlanText = Color(0xFF555558);
  static const Color subscriptionPlanMuted = Color(0xFF818583);
  static const Color subscriptionDivider = Color(0x36C0B8B8);
  static const Color subscriptionSelectedOverlay = Color(0x08000000);
  static const Color subscriptionDotInactive = Color(0x330C6C3F);
  static const Color drawerBackground = Color(0xFF0C7946);

  // Calendar.
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
