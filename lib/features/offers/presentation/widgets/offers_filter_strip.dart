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
          vertical: Spacing.sm,
        ),
        child: Row(
          children: List.generate(filters.length, (index) {
            final filter = filters[index];
            final selected = filter.isSelected;
            return Padding(
              padding: EdgeInsetsDirectional.only(
                end: index == filters.length - 1 ? 0 : Spacing.offersFilterGap,
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
                      color: selected
                          ? color.onTertiaryContainer
                          : color.surface,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      border: selected
                          ? null
                          : Border.all(
                              color: color.outlineVariant,
                              width: Spacing.border,
                            ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          filter.icon,
                          size: selected
                              ? Spacing.iconSm + Spacing.xs
                              : Spacing.offersFilterIconSize,
                          color: selected ? color.onPrimary : color.onSurface,
                          semanticLabel: filter.label,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          filter.label,
                          textAlign: TextAlign.center,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: selected
                                ? FontSize.size13
                                : FontSize.size13,
                            color: selected ? color.onPrimary : color.onSurface,
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
