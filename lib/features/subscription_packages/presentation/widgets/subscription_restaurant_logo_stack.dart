import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class SubscriptionRestaurantLogoStack extends StatelessWidget {
  const SubscriptionRestaurantLogoStack({super.key, required this.logoUrls});

  final List<String?> logoUrls;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final validLogos = logoUrls
        .where((url) => url != null && url.isNotEmpty)
        .toList(growable: false);

    if (validLogos.isEmpty) {
      return const SizedBox.shrink();
    }

    final count = validLogos.length > 3 ? 3 : validLogos.length;
    const logoSize = Spacing.xl;
    final double stackWidth = switch (count) {
      1 => Spacing.xl,
      2 => Spacing.buttonSmallHeight,
      _ => Spacing.appBarHeight,
    };

    return SizedBox(
      width: stackWidth,
      height: logoSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < count; i++)
            PositionedDirectional(
              start: switch (i) {
                1 => Spacing.base,
                2 => Spacing.xxl,
                _ => Spacing.zero,
              },
              child: Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.surface,
                    width: Spacing.border,
                  ),
                ),
                child: AppCachedNetworkImage(
                  imageUrl: validLogos[i],
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
