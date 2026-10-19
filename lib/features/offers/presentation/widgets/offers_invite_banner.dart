import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OffersInviteBanner extends StatelessWidget {
  const OffersInviteBanner({
    super.key,
    this.onTap,
    this.code,
    this.rewardRate,
  });

  final VoidCallback? onTap;
  final String? code;
  final double? rewardRate;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isAr = locale.localeName == 'ar';

    final percent = rewardRate != null && rewardRate! > 0
        ? (rewardRate! <= 1.0 ? (rewardRate! * 100).toInt() : rewardRate!.toInt())
        : 30;

    final title = isAr
        ? 'ادع أصدقائك واحصل على خصم $percent%'
        : 'Invite friends & get $percent% discount';

    final subtitle = code != null && code!.isNotEmpty
        ? (isAr
            ? 'شارك كود الإحالة ($code) مع أصدقائك واكسب رصيداً'
            : 'Share referral code ($code) with friends and earn rewards')
        : (isAr
            ? 'شارك كود الإحالة مع أصدقائك واكسب خصم عند أول اشتراك'
            : 'Share your referral code with friends and earn rewards');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.offersInviteBannerRadius),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Spacing.offersHorizontalPadding,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: color.secondaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(Spacing.offersInviteBannerRadius),
          border: Border.all(color: color.secondary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.secondary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_add_outlined,
                color: color.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.secondary,
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
              child: Text(
                isAr ? 'دعوة' : 'Invite',
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
