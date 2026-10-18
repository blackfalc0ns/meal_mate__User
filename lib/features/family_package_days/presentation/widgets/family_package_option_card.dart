import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPackageOptionCard extends StatelessWidget {
  const FamilyPackageOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  final FamilyPackageOptionUiModel option;
  final VoidCallback onTap;

  void _handleTap(BuildContext context) {
    if (option.canSelect) {
      onTap();
    } else {
      final reasonCode =
          option.disabledReason ?? 'subscription_flow.no_prepared_restaurants';
      final message = mapFailureMessage(context, reasonCode);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: context.colorScheme.onError,
              ),
            ),
            backgroundColor: context.colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selected = option.isSelected;
    final canSelect = option.canSelect;
    final cardBorderRadius = BorderRadius.circular(
      Spacing.familyProgramCardRadius,
    );

    return Opacity(
      opacity: canSelect ? 1.0 : 0.45,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: cardBorderRadius,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: Spacing.familyPackageOptionHeight,
              decoration: BoxDecoration(
                color: color.surface,
                border: Border.all(
                  color: selected ? color.primary : color.outlineVariant,
                  width: selected
                      ? Spacing.familySelectedBorderWidth
                      : Spacing.border,
                ),
                borderRadius: cardBorderRadius,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Spacing.familyProgramCardRadius - 1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 72,
                      child: AppCachedNetworkImage(
                        imageUrl: option.imageUrl,
                        width: double.infinity,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xs,
                          vertical: Spacing.xs,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              option.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.onSurface,
                              ),
                            ),
                            const SizedBox(height: Spacing.xss),
                            Text(
                              option.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size8,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selected)
              PositionedDirectional(
                top: -Spacing.sm,
                start: -Spacing.xs,
                child: CircleAvatar(
                  radius: Spacing.sm,
                  backgroundColor: color.primary,
                  child: Icon(
                    Icons.check_rounded,
                    size: Spacing.iconSm,
                    color: color.onPrimary,
                  ),
                ),
              ),
            if (!canSelect)
              PositionedDirectional(
                top: Spacing.xs,
                end: Spacing.xs,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: color.error,
                    borderRadius: BorderRadius.circular(Spacing.xs),
                  ),
                  child: Text(
                    locale.package_unavailable_badge,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.onError,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
