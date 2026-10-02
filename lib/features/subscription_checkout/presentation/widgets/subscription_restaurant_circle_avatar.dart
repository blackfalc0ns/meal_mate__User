import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class SubscriptionRestaurantCircleAvatar extends StatelessWidget {
  const SubscriptionRestaurantCircleAvatar({
    super.key,
    required this.logoUrl,
  });

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final hasLogo = logoUrl != null && logoUrl!.trim().isNotEmpty;

    return Container(
      width: Spacing.avatarMd,
      height: Spacing.avatarMd,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.hairline,
        ),
      ),
      padding: const EdgeInsets.all(Spacing.xs),
      child: ClipOval(
        child: hasLogo
            ? AppCachedNetworkImage(
                imageUrl: logoUrl!,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.restaurant_rounded,
                color: color.primary,
                size: Spacing.iconSm,
              ),
      ),
    );
  }
}
