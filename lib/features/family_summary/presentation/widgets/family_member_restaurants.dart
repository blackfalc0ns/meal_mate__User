import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';

class FamilyMemberRestaurants extends StatelessWidget {
  const FamilyMemberRestaurants({super.key, required this.restaurants});

  final List<FamilyMemberRestaurantEntity> restaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final languageCode = Localizations.localeOf(context).languageCode;

    if (restaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Text(
          locale.family_member_no_restaurants,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurfaceVariant,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int i = 0; i < restaurants.length; i++) ...[
            if (i > 0) const SizedBox(width: Spacing.sm),
            _buildRestaurantLogo(context, restaurants[i], languageCode),
          ],
        ],
      ),
    );
  }

  Widget _buildRestaurantLogo(
    BuildContext context,
    FamilyMemberRestaurantEntity restaurant,
    String languageCode,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final name = restaurant.displayName(languageCode);
    final count = restaurant.occurrenceCount > 0
        ? restaurant.occurrenceCount
        : 1;
    final countText = locale.family_restaurant_occurrence_count(count);
    final semanticsLabel = name.isNotEmpty ? '$name, $countText' : countText;
    final hasLogo =
        restaurant.logoUrl != null && restaurant.logoUrl!.trim().isNotEmpty;

    return Semantics(
      label: semanticsLabel,
      image: true,
      child: Container(
        key: ValueKey('restaurant-${restaurant.restaurantId}'),
        width: Spacing.avatarMd,
        height: Spacing.avatarMd,
        decoration: BoxDecoration(
          color: color.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.border,
          ),
        ),
        padding: const EdgeInsets.all(Spacing.xs),
        child: ClipOval(
          child: hasLogo
              ? Image.network(
                  restaurant.logoUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: Spacing.iconXs,
                        height: Spacing.iconXs,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackLogo(color),
                )
              : _buildFallbackLogo(color),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo(ColorScheme color) {
    return Container(
      color: color.surfaceContainerLow,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant_rounded,
        size: Spacing.iconSm,
        color: color.primary,
      ),
    );
  }
}
