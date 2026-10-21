import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';

class RedeemPackageCard extends StatelessWidget {
  const RedeemPackageCard({
    super.key,
    required this.option,
    required this.isSelected,
    this.discountPercent = 0,
    required this.onTap,
  });

  final OfferPurchaseOptionEntity option;
  final bool isSelected;
  final int discountPercent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final bundleName = lang == 'ar'
        ? (option.bundleNameAr ?? option.bundleNameEn ?? '')
        : (option.bundleNameEn ?? option.bundleNameAr ?? '');

    final canTap = option.canCheckout && onTap != null;
    final currency = option.currencyCode ?? locale.currency;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canTap ? onTap : null,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: Spacing.md),
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? color.primary.withValues(alpha: 0.03)
                : color.surface,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(
              color: isSelected
                  ? color.primary
                  : color.outlineVariant.withValues(alpha: 0.6),
              width: isSelected ? 1.6 : Spacing.border,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(
                  alpha: isSelected ? 0.06 : 0.03,
                ),
                blurRadius: Spacing.sm,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Radio checkmark (Right side in RTL)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? color.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? color.primary : color.outline,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: color.onPrimary,
                            size: 15,
                          )
                        : null,
                  ),
                  const SizedBox(width: Spacing.sm),

                  // 2. Meal box thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    child: Container(
                      width: 68,
                      height: 68,
                      color: color.surfaceContainerHighest.withValues(alpha: 0.25),
                      child: option.imageUrl?.startsWith('http') == true
                          ? Image.network(
                              option.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Image.asset(
                                'assets/images/fake/offers/meal_boxes.png',
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              'assets/images/fake/offers/meal_boxes.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),

                  // 3. Center Info (Package name, Green duration, Meals, Dates)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package Title
                        Text(
                          bundleName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Green Duration text (Figma 12.04 style)
                        Text(
                          '${option.durationDays} ${locale.billing_uncompleted_days}',
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.primary,
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Daily Meals
                        Text(
                          '${option.mealsPerDay ?? 4} ${locale.family_restaurants_summary_daily_meals_label}',
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Date range
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 10,
                              color: color.primary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'من ${option.startDate} إلى ${option.endDate ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),

                  // 4. Left side (Prices & Discount badge)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Base strikethrough price
                      if (option.basePrice != null &&
                          option.finalPrice != null &&
                          option.basePrice! > option.finalPrice!)
                        Text(
                          '${option.basePrice!.toStringAsFixed(3)} $currency',
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.outline,
                          ).copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                      // Final Price (Bold green or prominent)
                      Text(
                        '${(option.finalPrice ?? option.basePrice ?? 0).toStringAsFixed(3)} $currency',
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: isSelected ? color.primary : color.onSurface,
                        ),
                      ),

                      // Discount badge
                      if (discountPercent > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.primaryContainer.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusXs,
                            ),
                          ),
                          child: Text(
                            locale.family_package_discount_badge(
                              '$discountPercent%',
                            ),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              // Blocking reasons if any
              if (!option.canCheckout && option.blockingReasons.isNotEmpty) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  option.blockingReasons.first.messageAr ??
                      option.blockingReasons.first.messageEn ??
                      '',
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
