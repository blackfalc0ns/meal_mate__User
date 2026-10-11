import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSaveButton extends StatelessWidget {
  const CalendarMealSaveButton({
    super.key,
    this.isLoading,
    this.enabled,
    this.selectedCount,
    this.requiredCount,
    this.onPressed,
    this.controller,
    this.height,
  });

  final bool? isLoading;
  final bool? enabled;
  final int? selectedCount;
  final int? requiredCount;
  final VoidCallback? onPressed;
  final RoundedLoadingButtonController? controller;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (isLoading != null && enabled != null) {
      return _buildButton(
        context,
        isLoading: isLoading!,
        enabled: enabled!,
        selectedCount: selectedCount ?? 0,
        requiredCount: requiredCount ?? 0,
        onPressed: onPressed,
      );
    }

    return BlocSelector<
      MealSelectionViewModel,
      MealSelectionState,
      ({bool loading, bool enabled, int selectedCount, int requiredCount})
    >(
      selector: (state) => (
        loading: state.isSaving || state.isConfirming,
        enabled: state.canSaveMeals && !state.isSaving && !state.isConfirming,
        selectedCount: state.selectedMealIds.length,
        requiredCount: state.requiredMealsCount,
      ),
      builder: (context, buttonState) {
        return _buildButton(
          context,
          isLoading: buttonState.loading,
          enabled: buttonState.enabled,
          selectedCount: buttonState.selectedCount,
          requiredCount: buttonState.requiredCount,
          onPressed:
              onPressed ??
              () {
                final locale = context.localization;
                try {
                  unawaited(
                    context.read<CalendarFlowViewModel>().confirmMeals(
                      localeName: locale.localeName,
                    ),
                  );
                } catch (_) {
                  unawaited(
                    context.read<MealSelectionViewModel>().confirm(
                      localeName: locale.localeName,
                    ),
                  );
                }
              },
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required bool isLoading,
    required bool enabled,
    required int selectedCount,
    required int requiredCount,
    VoidCallback? onPressed,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    final countText = requiredCount > 0
        ? ' \u200E($selectedCount/$requiredCount)\u200E'
        : '';
    final buttonText = '${locale.calendar_confirm_meals}$countText';

    final progress =
        (requiredCount > 0
                ? (selectedCount / requiredCount)
                : (enabled ? 1.0 : 0.0))
            .clamp(0.0, 1.0);

    final effectiveHeight = height ?? Spacing.buttonSmallHeight;
    final fontSize = effectiveHeight <= Spacing.buttonSmallHeight
        ? FontSize.size14
        : FontSize.size16;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: effectiveHeight,
          width: width,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, animatedProgress, _) {
              return Material(
                type: MaterialType.transparency,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                  child: Stack(
                    children: [
                      // Base inactive background
                      Positioned.fill(
                        child: Container(
                          color: color.outlineVariant,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                          ),
                          child: Text(
                            buttonText,
                            locale: Locale(locale.localeName),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: fontSize,
                              color: color.onSurfaceVariant,
                            ).copyWith(decoration: TextDecoration.none),
                          ),
                        ),
                      ),

                      // Active progress fill overlay
                      if (animatedProgress > 0)
                        PositionedDirectional(
                          start: 0,
                          top: 0,
                          bottom: 0,
                          width: (width * animatedProgress).clamp(0.0, width),
                          child: ClipRect(
                            child: OverflowBox(
                              alignment: AlignmentDirectional.centerStart,
                              minWidth: width,
                              maxWidth: width,
                              minHeight: effectiveHeight,
                              maxHeight: effectiveHeight,
                              child: Container(
                                color: color.primary,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                ),
                                child: Text(
                                  buttonText,
                                  locale: Locale(locale.localeName),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: fontSize,
                                    color: color.onPrimary,
                                  ).copyWith(decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Material ink ripple & tap handler
                      Positioned.fill(
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: enabled && !isLoading ? onPressed : null,
                            borderRadius: BorderRadius.circular(
                              Spacing.buttonRadius,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
