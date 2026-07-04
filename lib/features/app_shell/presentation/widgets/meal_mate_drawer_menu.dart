import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealMateDrawerMenu extends StatelessWidget {
  const MealMateDrawerMenu({
    super.key,
    required this.animationValue,
    required this.controller,
    required this.userName,
    required this.greeting,
    required this.avatarAsset,
  });

  final double animationValue;
  final ZoomDrawerController controller;
  final String userName;
  final String greeting;
  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final size = MediaQuery.sizeOf(context);
    final unitX = size.width / 393;
    final unitY = size.height / 852;
    final menuWidth = 134.0 * unitX;

    return Material(
      color: const Color(0xFF0C7946),
      child: Stack(
        children: [
          Positioned(
            top: 204 * unitY,
            left: -14 * unitX,
            child: Container(
              width: 218 * unitX,
              height: 493 * unitY,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(38),
              ),
            ),
          ),
          Positioned(
            top: 27 * unitY,
            left: 0,
            right: 0,
            child: const Center(child: _MealMateDrawerLogo()),
          ),
          Positioned(
            top: 24 * unitY,
            right: 30 * unitX,
            child: IconButton(
              onPressed: () => controller.close?.call(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 30, height: 30),
              icon: const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.white,
                child: Icon(
                  Icons.close_rounded,
                  color: Color(0xFF0C7946),
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 102 * unitY,
            right: 36 * unitX,
            child: _AnimatedProfileHeader(
              animationValue: animationValue,
              userName: userName,
              greeting: '',
              avatarAsset: avatarAsset,
              planLabel: l10n.drawer_weight_loss_program,
              packageLabel: l10n.drawer_month_package,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 180 * unitY, right: 30 * unitX),
              child: SizedBox(
                width: menuWidth,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DrawerSection(
                          title: l10n.drawer_account,
                          items: [
                            _DrawerItemData(
                              icon: Icons.person_outline_rounded,
                              label: l10n.drawer_my_account,
                            ),
                            _DrawerItemData(
                              icon: Icons.credit_card_rounded,
                              label: l10n.drawer_payment_methods,
                            ),
                            _DrawerItemData(
                              icon: Icons.notifications_none_rounded,
                              label: l10n.drawer_notifications,
                            ),
                          ],
                        ),
                        _DrawerSection(
                          title: l10n.drawer_subscription,
                          items: [
                            _DrawerItemData(
                              icon: Icons.inventory_2_outlined,
                              label: l10n.drawer_current_subscription,
                            ),
                            _DrawerItemData(
                              icon: Icons.groups_2_outlined,
                              label: l10n.drawer_family_members,
                            ),
                          ],
                        ),
                        _DrawerSection(
                          title: l10n.drawer_orders,
                          items: [
                            _DrawerItemData(
                              icon: Icons.assignment_outlined,
                              label: l10n.drawer_previous_orders,
                            ),
                            _DrawerItemData(
                              icon: Icons.delivery_dining_rounded,
                              label: l10n.drawer_track_current_order,
                            ),
                          ],
                        ),
                        _DrawerSection(
                          title: l10n.drawer_rewards_offers,
                          items: [
                            _DrawerItemData(
                              icon: Icons.card_giftcard_rounded,
                              label: l10n.drawer_points_rewards,
                            ),
                            _DrawerItemData(
                              icon: Icons.person_add_alt_1_rounded,
                              label: l10n.drawer_invite_friends,
                            ),
                            _DrawerItemData(
                              icon: Icons.local_offer_outlined,
                              label: l10n.drawer_special_offers,
                            ),
                          ],
                        ),
                        _DrawerSection(
                          title: l10n.drawer_support_help,
                          items: [
                            _DrawerItemData(
                              icon: Icons.support_agent_rounded,
                              label: l10n.drawer_technical_support,
                            ),
                            _DrawerItemData(
                              icon: Icons.help_outline_rounded,
                              label: l10n.drawer_faq,
                            ),
                            _DrawerItemData(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: l10n.drawer_contact_us,
                            ),
                          ],
                        ),
                        _DrawerSection(
                          title: l10n.drawer_settings,
                          items: [
                            _DrawerItemData(
                              icon: Icons.language_rounded,
                              label: l10n.drawer_language,
                            ),
                            _DrawerItemData(
                              icon: Icons.settings_outlined,
                              label: l10n.drawer_settings,
                            ),
                          ],
                          showDivider: false,
                        ),
                        const SizedBox(height: 9),
                        _LogoutButton(label: l10n.drawer_logout),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealMateDrawerLogo extends StatelessWidget {
  const _MealMateDrawerLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 61,
      height: 58,
      child: SvgPicture.asset(Assets.logoWhite, fit: BoxFit.contain),
    );
  }
}

class _AnimatedProfileHeader extends StatelessWidget {
  const _AnimatedProfileHeader({
    required this.animationValue,
    required this.userName,
    required this.greeting,
    required this.avatarAsset,
    required this.planLabel,
    required this.packageLabel,
  });

  final double animationValue;
  final String userName;
  final String greeting;
  final String avatarAsset;
  final String planLabel;
  final String packageLabel;

  @override
  Widget build(BuildContext context) {
    final curved = Curves.easeOutBack.transform(animationValue.clamp(0.0, 1.0));
    final textSlide = (1 - animationValue) * 22;
    final avatarSlide = (1 - animationValue) * 18;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Opacity(
        opacity: animationValue.clamp(0.0, 1.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: Offset(avatarSlide, 0),
              child: Transform.scale(
                scale: 0.82 + (0.18 * curved),
                child: _DrawerAvatar(asset: avatarAsset, size: 63),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 94,
              child: Transform.translate(
                offset: Offset(textSlide, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (greeting.isNotEmpty) ...[
                      Text(
                        greeting,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: const Color(0xFFF4F4F4),
                        ),
                      ),
                      const SizedBox(height: 1),
                    ],
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size14,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _ProfileMetaRow(
                      icon: Icons.eco_rounded,
                      label: planLabel,
                      iconSize: 12,
                    ),
                    const SizedBox(height: 3),
                    _ProfileMetaRow(
                      icon: Icons.workspace_premium_rounded,
                      label: packageLabel,
                      iconSize: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerAvatar extends StatelessWidget {
  const _DrawerAvatar({required this.asset, this.size = 67});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return const ColoredBox(
              color: AppColors.white,
              child: Icon(Icons.person, color: AppColors.primary, size: 42),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileMetaRow extends StatelessWidget {
  const _ProfileMetaRow({
    required this.icon,
    required this.label,
    required this.iconSize,
  });

  final IconData icon;
  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: ui.TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF54CF4E), size: iconSize),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size10,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _DrawerSection extends StatelessWidget {
  const _DrawerSection({
    required this.title,
    required this.items,
    this.showDivider = true,
  });

  final String title;
  final List<_DrawerItemData> items;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size10,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 6),
        for (final item in items) _DrawerItem(item: item),
        if (showDivider) ...[
          const SizedBox(height: 6),
          Divider(
            color: const Color(0xFF499B74).withValues(alpha: 0.95),
            thickness: 0.7,
            height: 12,
          ),
        ],
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.item});

  final _DrawerItemData item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(Spacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          textDirection: ui.TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(item.icon, color: AppColors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size11,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size12,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _DrawerItemData {
  const _DrawerItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
