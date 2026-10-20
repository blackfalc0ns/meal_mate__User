import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersFilterStrip extends StatelessWidget {
  const OffersFilterStrip({super.key, required this.filters, this.onTap});

  final List<OfferFilterEntity> filters;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_offers,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.offersHorizontalPadding,
        ),
        child: Row(
          children: List.generate(filters.length, (index) {
            final filter = filters[index];
            final selected = filter.isSelected;
            return Padding(
              padding: EdgeInsetsDirectional.only(
                end: index == filters.length - 1 ? 0 : Spacing.sm,
              ),
              child: Material(
                color: color.surface.withValues(alpha: 0),
                child: InkWell(
                  onTap: onTap == null ? null : () => onTap!(index),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  child: Ink(
                    height: Spacing.offersFilterHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.offersFilterHorizontalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? color.primary : color.surface,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      border: Border.all(
                        color: selected ? color.primary : color.outlineVariant,
                        width: Spacing.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          filter.icon,
                          size: Spacing.offersFilterIconSize,
                          color: selected ? color.onPrimary : color.onSurfaceVariant,
                          semanticLabel: filter.label,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          filter.label,
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: selected ? color.onPrimary : color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
