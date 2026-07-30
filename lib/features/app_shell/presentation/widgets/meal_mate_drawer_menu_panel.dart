import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class MealMateDrawerMenuPanel extends StatelessWidget {
  const MealMateDrawerMenuPanel({
    super.key,
    required this.l10n,
    required this.unitX,
    required this.unitY,
    required this.animationValue,
  });

  final AppLocalizations l10n;
  final double unitX;
  final double unitY;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    final curved = Curves.easeOutCubic.transform(
      animationValue.clamp(0.0, 1.0),
    );

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 180 * unitY, right: 30 * unitX),
        child: Transform.translate(
          offset: Offset((1 - curved) * 42 * unitX, 0),
          child: Opacity(
            opacity: (animationValue * 1.6).clamp(0.0, 1.0),
            child: SizedBox(
              width: 134.0 * unitX,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 28),
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: MealMateDrawerSectionsList(l10n: l10n),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MealMateDrawerSectionsList extends StatelessWidget {
  const MealMateDrawerSectionsList({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MealMateDrawerSection(
          title: l10n.drawer_account,
          items: [
            MealMateDrawerItemData(
              icon: Icons.person_outline_rounded,
              label: l10n.drawer_my_account,
            ),
            MealMateDrawerItemData(
              icon: Icons.credit_card_rounded,
              label: l10n.drawer_payment_methods,
            ),
            MealMateDrawerItemData(
              icon: Icons.notifications_none_rounded,
              label: l10n.drawer_notifications,
            ),
          ],
        ),
        MealMateDrawerSection(
          title: l10n.drawer_subscription,
          items: [
            MealMateDrawerItemData(
              icon: Icons.inventory_2_outlined,
              label: l10n.drawer_current_subscription,
            ),
            MealMateDrawerItemData(
              icon: Icons.groups_2_outlined,
              label: l10n.drawer_family_members,
            ),
          ],
        ),
        MealMateDrawerSection(
          title: l10n.drawer_orders,
          items: [
            MealMateDrawerItemData(
              icon: Icons.assignment_outlined,
              label: l10n.drawer_previous_orders,
            ),
            MealMateDrawerItemData(
              icon: Icons.delivery_dining_rounded,
              label: l10n.drawer_track_current_order,
            ),
          ],
        ),
        MealMateDrawerSection(
          title: l10n.drawer_rewards_offers,
          items: [
            MealMateDrawerItemData(
              icon: Icons.card_giftcard_rounded,
              label: l10n.drawer_points_rewards,
            ),
            MealMateDrawerItemData(
              icon: Icons.person_add_alt_1_rounded,
              label: l10n.drawer_invite_friends,
            ),
            MealMateDrawerItemData(
              icon: Icons.local_offer_outlined,
              label: l10n.drawer_special_offers,
            ),
          ],
        ),
        MealMateDrawerSection(
          title: l10n.drawer_support_help,
          items: [
            MealMateDrawerItemData(
              icon: Icons.support_agent_rounded,
              label: l10n.drawer_technical_support,
            ),
            MealMateDrawerItemData(
              icon: Icons.help_outline_rounded,
              label: l10n.drawer_faq,
            ),
            MealMateDrawerItemData(
              icon: Icons.chat_bubble_outline_rounded,
              label: l10n.drawer_contact_us,
            ),
          ],
        ),
        MealMateDrawerSection(
          title: l10n.drawer_settings,
          items: [
            MealMateDrawerItemData(
              icon: Icons.language_rounded,
              label: l10n.drawer_language,
            ),
            MealMateDrawerItemData(
              icon: Icons.settings_outlined,
              label: l10n.drawer_settings,
            ),
          ],
          showDivider: false,
        ),
        const SizedBox(height: 9),
        MealMateDrawerLogoutButton(label: l10n.drawer_logout),
      ],
    );
  }
}

class MealMateDrawerSection extends StatelessWidget {
  const MealMateDrawerSection({
    super.key,
    required this.title,
    required this.items,
    this.showDivider = true,
  });

  final String title;
  final List<MealMateDrawerItemData> items;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onPrimary,
          ),
        ),
        const SizedBox(height: 6),
        for (final item in items) MealMateDrawerItem(item: item),
        if (showDivider) ...[
          const SizedBox(height: 6),
          Divider(
            color: color.onPrimary.withValues(alpha: 0.28),
            thickness: 0.7,
            height: 12,
          ),
        ],
      ],
    );
  }
}

class MealMateDrawerItem extends StatelessWidget {
  const MealMateDrawerItem({super.key, required this.item});

  final MealMateDrawerItemData item;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(Spacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          textDirection: ui.TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(item.icon, color: color.onPrimary, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealMateDrawerLogoutButton extends StatelessWidget {
  const MealMateDrawerLogoutButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 25,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color.secondary,
          foregroundColor: color.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSecondary,
          ),
        ),
      ),
    );
  }
}

class MealMateDrawerItemData {
  const MealMateDrawerItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
