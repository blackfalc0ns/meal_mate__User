import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMealSelectionBottomBar extends StatelessWidget {
  const FamilyMealSelectionBottomBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.slotAndDateLabel,
    required this.onContinue,
  });

  final int selectedCount;
  final int totalCount;
  final String slotAndDateLabel;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final parts = slotAndDateLabel.split(' • ');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(top: BorderSide(color: color.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(color: color.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.06),
                offset: const Offset(0, 2),
                blurRadius: Spacing.xs,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: Spacing.xl * 1.4,
                          height: Spacing.xl * 1.4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.surfaceContainerHighest.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.assignment_outlined,
                              size: Spacing.iconSm,
                              color: color.primary,
                            ),
                          ),
                        ),
                        PositionedDirectional(
                          top: -2,
                          start: -2,
                          child: Container(
                            padding: const EdgeInsets.all(Spacing.xxs),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.primary,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14.0,
                              minHeight: 14.0,
                            ),
                            child: Center(
                              child: Text(
                                '$selectedCount',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size8,
                                  color: color.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.family_meal_selected_counter(
                              selectedCount,
                              totalCount,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs / 2),
                          if (parts.length == 2)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  parts[0],
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size9,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: Spacing.xs / 2),
                                Container(
                                  width: 3.0,
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color.primary,
                                  ),
                                ),
                                const SizedBox(width: Spacing.xs / 2),
                                Flexible(
                                  child: Text(
                                    parts[1],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size9,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              slotAndDateLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size9,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              FilledButton(
                onPressed: onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: color.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
                child: Text(
                  locale.family_meal_continue_review,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
