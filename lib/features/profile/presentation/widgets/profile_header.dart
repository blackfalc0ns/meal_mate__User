import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.semanticsLabel,
    this.profile,
    this.onEditImagePressed,
    this.isImageActionLoading = false,
  });

  final String semanticsLabel;
  final CustomerProfileEntity? profile;
  final VoidCallback? onEditImagePressed;
  final bool isImageActionLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final imageUrl = _buildProfileImageUrl(profile?.profileImageStorageKey);

    return SizedBox(
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
                AppCachedNetworkImage(
                  imageUrl: imageUrl,
                  width: Spacing.profileAvatarSize,
                  height: Spacing.profileAvatarSize,
                  shape: BoxShape.circle,
                  semanticLabel: semanticsLabel,
                  errorWidget: Image.asset(
                    Assets.profileAvatar,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: -Spacing.xs,
                  right: -Spacing.xs,
                  child: Semantics(
                    label: locale.profile_change_photo,
                    button: true,
                    child: InkWell(
                      onTap: isImageActionLoading ? null : onEditImagePressed,
                      customBorder: const CircleBorder(),
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
                        child: isImageActionLoading
                            ? Padding(
                                padding: const EdgeInsets.all(Spacing.sm),
                                child: CircularProgressIndicator(
                                  strokeWidth: Spacing.border,
                                  color: color.primary,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt_rounded,
                                color: color.onSurface,
                                size: Spacing.lg,
                              ),
                      ),
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
                      profile?.fullName.isNotEmpty == true
                          ? profile!.fullName
                          : locale.profile_user_name,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
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
                  profile?.displayContact.isNotEmpty == true
                      ? profile!.displayContact
                      : locale.profile_user_email,
                  textDirection: TextDirection.ltr,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
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
                          fontFamily: FontConstant.alexandria,
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
    );
  }

  String? _buildProfileImageUrl(String? storageKey) {
    if (storageKey == null || storageKey.isEmpty) return null;

    final query = Uri(queryParameters: {'key': storageKey}).query;
    return '${NetworkConstants.baseUrl}${EndPoints.uploadContent}?$query';
  }
}
