import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SearchQuickCategoryTile extends StatelessWidget {
  const SearchQuickCategoryTile({
    super.key,
    required this.imageAsset,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.width,
    required this.height,
  });

  final String imageAsset;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusMd),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(Spacing.xss),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(color: color.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: .06),
              blurRadius: Spacing.xs,
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox.square(
              dimension: Spacing.searchPopularImageSize,
              child: ClipOval(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  semanticLabel: locale.search_categories,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size9,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
