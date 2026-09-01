import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerShareCard extends StatelessWidget {
  const InfluencerShareCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.imageAsset,
    this.qrAsset,
  });

  final String title;
  final String subtitle;
  final String code;
  final String imageAsset;
  final String? qrAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: AspectRatio(
              aspectRatio: 359 / 138.42,
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              if (qrAsset != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  child: Image.asset(
                    qrAsset!,
                    width: Spacing.iconXl,
                    height: Spacing.iconXl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Spacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: Text(
              code,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
