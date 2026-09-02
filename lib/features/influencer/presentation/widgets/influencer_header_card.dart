import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerHeaderCard extends StatelessWidget {
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

    return SizedBox(
      height: Spacing.influencerHeaderHeight,
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.notificationBold,
            width: Spacing.influencerNotificationSize,
            height: Spacing.influencerNotificationSize,
          ),
          const Spacer(),
          SvgPicture.asset(
            logoAsset,
            width: Spacing.influencerHeaderLogoWidth,
            height: Spacing.influencerHeaderLogoHeight,
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
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
                    textAlign: TextAlign.end,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.sm),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: Image.asset(
                      avatarAsset,
                      width: Spacing.influencerAvatarSize,
                      height: Spacing.influencerAvatarSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  PositionedDirectional(
                    end: Spacing.zero,
                    bottom: Spacing.zero,
                    child: Icon(
                      Icons.verified_rounded,
                      color: color.primary,
                      size: Spacing.influencerVerifiedSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
