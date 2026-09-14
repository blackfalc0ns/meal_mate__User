import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerHeaderCard extends StatelessWidget
    implements PreferredSizeWidget {
  const InfluencerHeaderCard({
    super.key,
    required this.userName,
    required this.partnerLabel,
    required this.avatarAsset,
    required this.logoAsset,
  });

  final String userName;
  final String partnerLabel;
  final String avatarAsset;
  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: color.surface,
      elevation: Spacing.zero,
      scrolledUnderElevation: Spacing.zero,
      toolbarHeight: Spacing.influencerHeaderHeight,
      titleSpacing: Spacing.zero,
      title: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Spacing.screenH,
        ),
        child: Row(
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    avatarAsset,
                    width: Spacing.influencerAvatarSize,
                    height: Spacing.influencerAvatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xss),
                    Text(
                      partnerLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(
              logoAsset,
              width: Spacing.influencerHeaderLogoWidth,
              height: Spacing.influencerHeaderLogoHeight,
            ),
            const Spacer(),
            SvgPicture.asset(
              Assets.notificationBold,
              width: Spacing.influencerNotificationSize,
              height: Spacing.influencerNotificationSize,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(Spacing.influencerHeaderHeight);
}
