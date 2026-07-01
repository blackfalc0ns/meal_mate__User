import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';

class AppTheme {
  const AppTheme._();

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.primarySurface,
    onPrimaryContainer: AppColors.primaryDarker,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textOnPrimary,
    secondaryContainer: AppColors.secondarySurface,
    onSecondaryContainer: AppColors.secondaryDarkest,
    tertiary: AppColors.primaryVariant,
    onTertiary: AppColors.textOnPrimary,
    tertiaryContainer: AppColors.infoLight,
    onTertiaryContainer: AppColors.brandDeepGreen,
    error: AppColors.error,
    onError: AppColors.textOnPrimary,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.error,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.grey100,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.appBorder,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.surfaceDark,
    onInverseSurface: AppColors.textPrimaryDark,
    inversePrimary: AppColors.primaryLight,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.primaryDeepDarkest,
    primaryContainer: AppColors.primaryDarker,
    onPrimaryContainer: AppColors.primarySurface,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.secondaryDarkest,
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.secondarySurface,
    tertiary: AppColors.primaryMedium,
    onTertiary: AppColors.primaryDeepDarkest,
    tertiaryContainer: AppColors.primaryDeepDark,
    onTertiaryContainer: AppColors.infoLight,
    error: AppColors.error,
    onError: AppColors.textOnPrimary,
    errorContainer: AppColors.error,
    onErrorContainer: AppColors.errorLight,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.cardDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: AppColors.dividerDark,
    outlineVariant: AppColors.grey500,
    shadow: AppColors.shadowDark,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.surface,
    onInverseSurface: AppColors.textPrimary,
    inversePrimary: AppColors.primary,
  );

  static ThemeData get lightTheme {
    return _buildTheme(_lightColorScheme);
  }

  static ThemeData get darkTheme {
    return _buildTheme(_darkColorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      fontFamily: FontConstant.ibmPlexSansArabic,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.transparent,
        foregroundColor: isDark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h4.copyWith(color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.textHint,
          minimumSize: const Size(double.infinity, Spacing.buttonHeight),
          elevation: 0,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, Spacing.buttonHeight),
          textStyle: AppTextStyles.button.copyWith(color: colorScheme.primary),
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.base,
          vertical: Spacing.sm,
        ),
        border: _inputBorder(colorScheme.outline),
        enabledBorder: _inputBorder(colorScheme.outline),
        focusedBorder: _inputBorder(colorScheme.primary, width: 1.5),
        errorBorder: _inputBorder(colorScheme.error),
        focusedErrorBorder: _inputBorder(colorScheme.error, width: 1.5),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        hintStyle: AppTextStyles.inputHint.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTextStyles.inputError,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.cardDark : AppColors.card,
        elevation: Spacing.cardElevation,
        shadowColor: colorScheme.shadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primaryContainer,
        selectedColor: colorScheme.primary,
        disabledColor: AppColors.disabled,
        labelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        secondaryLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.lg),
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Spacing.inputRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
