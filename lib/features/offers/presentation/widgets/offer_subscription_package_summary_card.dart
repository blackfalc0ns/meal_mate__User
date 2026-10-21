import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';

class OfferSubscriptionPackageSummaryCard extends StatelessWidget {
  const OfferSubscriptionPackageSummaryCard({
    super.key,
    required this.option,
    this.onChangePackage,
  });

  final OfferPurchaseOptionEntity option;
  final VoidCallback? onChangePackage;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final bundleName = lang == 'ar'
        ? (option.bundleNameAr ?? option.bundleNameEn ?? '')
        : (option.bundleNameEn ?? option.bundleNameAr ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.6),
          width: Spacing.border,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Meal box thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: Container(
              width: 60,
              height: 60,
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

          // Package details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bundleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${option.durationDays} ${locale.billing_uncompleted_days} · ${option.mealsPerDay ?? 4} ${locale.family_restaurants_summary_daily_meals_label}',
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 10,
                      color: color.onSurfaceVariant,
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

          // Change package button
          if (onChangePackage != null)
            TextButton(
              onPressed: onChangePackage,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                'تغيير',
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
