import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_package_icon.dart';

class MonthlyPlanPackageCard extends StatelessWidget {
  const MonthlyPlanPackageCard({
    super.key,
    required this.package,
    required this.width,
    required this.isSelected,
    required this.onTap,
    required this.onBrowseRestaurants,
  });

  final MonthlyPackageTierEntity package;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isFeatured = package.isPopular;
    final cardHeight = width * (isFeatured ? 1.72 : 1.5);

    return Semantics(
      button: true,
      selected: isSelected,
      label: package.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: cardHeight,
              margin: EdgeInsets.only(
                top: isFeatured ? Spacing.md : Spacing.lg,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xs,
                vertical: Spacing.md,
              ),
              decoration: BoxDecoration(
                color: isFeatured ? color.primary : color.surface,
                borderRadius: BorderRadius.circular(Spacing.radiusLg),
                border: Border.all(
                  color: isFeatured ? color.primary : color.outlineVariant,
                  width: isSelected ? Spacing.border : Spacing.hairline,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.08),
                    blurRadius: Spacing.md,
                    offset: const Offset(0, Spacing.xs),
                  ),
                ],
              ),
              child: Column(
                children: [
                  MonthlyPlanPackageIcon(
                    iconName: package.iconName,
                    isFeatured: isFeatured,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    package.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size20,
                      color: isFeatured ? color.onPrimary : color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    package.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size7,
                      color: isFeatured
                          ? color.onPrimary.withValues(alpha: 0.82)
                          : color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  for (final bullet in package.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: FontSize.size7,
                            color: isFeatured
                                ? color.onPrimary.withValues(alpha: 0.76)
                                : color.primary,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Flexible(
                            child: Text(
                              bullet,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size7,
                                color: isFeatured
                                    ? color.onPrimary.withValues(alpha: 0.76)
                                    : color.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: onBrowseRestaurants,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(Spacing.xl),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                      ),
                      side: BorderSide(color: color.primary),
                      backgroundColor: isFeatured
                          ? color.surface
                          : color.primary,
                      foregroundColor: isFeatured
                          ? color.primary
                          : color.onPrimary,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      locale.calendar_browse_restaurants,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size8,
                        color: isFeatured ? color.primary : color.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: Spacing.xxl,
                height: Spacing.xxl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? color.primary : color.outlineVariant,
                    width: Spacing.border,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: Spacing.iconSm,
                        color: color.primary,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
