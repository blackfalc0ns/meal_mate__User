import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.semanticsLabel});

  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        height: Spacing.profileHeaderHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              right: Spacing.xs,
              top: Spacing.profileAvatarTop,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: Spacing.profileAvatarSize / 2,
                    backgroundImage: const AssetImage(Assets.profileAvatar),
                    backgroundColor: color.surfaceContainerHighest,
                  ),
                  Positioned(
                    bottom: -Spacing.xs,
                    right: -Spacing.xs,
                    child: Container(
                      width: Spacing.profileAvatarEditSize,
                      height: Spacing.profileAvatarEditSize,
                      decoration: BoxDecoration(
                        color: color.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.shadow.withValues(alpha: 0.1),
                            blurRadius: Spacing.xs,
                            offset: const Offset(0, Spacing.xs),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: color.onSurface,
                        size: Spacing.lg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: Spacing.profileIdentityTop,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.profile_user_name,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: Spacing.profileTitleFontSize,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),

                      Icon(
                        Icons.verified_rounded,
                        color: color.primary,
                        size: Spacing.lg,
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xss),
                  Text(
                    locale.profile_user_email,
                    textDirection: TextDirection.ltr,
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: Spacing.profileBodyFontSize,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.xss,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.secondaryContainer,
                      borderRadius: BorderRadius.circular(Spacing.xss),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          color: color.primary,
                          size: Spacing.md,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.profile_premium_member,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: Spacing.profileBodyFontSize,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
