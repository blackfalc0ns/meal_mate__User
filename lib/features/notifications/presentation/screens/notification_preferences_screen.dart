import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_preference_card.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_preferences_info_banner.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _allowAll = true;
  bool _meals = true;
  bool _delivery = true;
  bool _subscription = true;
  bool _offers = true;
  bool _family = true;
  bool _account = true;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        backgroundColor: color.surface,
        showShadow: false,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: color.onSurface,
            size: Spacing.iconMd,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: locale.notifications_prefs_title,
        titleColor: color.primary,
        titleFontSize: FontSize.size16,
        subtitle: locale.notifications_prefs_subtitle,
        subtitleColor: color.onSurfaceVariant,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Spacing.xs, bottom: Spacing.xxxl),
          child: Column(
            children: [
              NotificationPreferenceCard(
                title: locale.notifications_prefs_allow_all,
                subtitle: locale.notifications_prefs_allow_all_subtitle,
                icon: Icons.notifications_rounded,
                isEnabled: _allowAll,
                onChanged: (val) {
                  setState(() {
                    _allowAll = val;
                    if (!val) {
                      _meals = false;
                      _delivery = false;
                      _subscription = false;
                      _offers = false;
                      _family = false;
                      _account = false;
                    }
                  });
                },
              ),
              NotificationPreferenceCard(
                title: locale.notifications_prefs_meals,
                subtitle: locale.notifications_prefs_meals_subtitle,
                icon: Icons.restaurant_rounded,
                isEnabled: _meals && _allowAll,
                onChanged: _allowAll
                    ? (val) => setState(() => _meals = val)
                    : (val) {},
              ),
              NotificationPreferenceCard(
                title: locale.notifications_prefs_delivery,
                subtitle: locale.notifications_prefs_delivery_subtitle,
                icon: Icons.local_shipping_rounded,
                isEnabled: _delivery && _allowAll,
                onChanged: _allowAll
                    ? (val) => setState(() => _delivery = val)
                    : (val) {},
              ),
              NotificationPreferenceCard(
                title: locale.notifications_prefs_subscription,
                subtitle: locale.notifications_prefs_subscription_subtitle,
                icon: Icons.credit_card_rounded,
                isEnabled: _subscription && _allowAll,
                onChanged: _allowAll
                    ? (val) => setState(() => _subscription = val)
                    : (val) {},
              ),
              NotificationPreferenceCard(
                title: locale.notifications_prefs_offers,
                subtitle: locale.notifications_prefs_offers_subtitle,
                icon: Icons.card_giftcard_rounded,
                isEnabled: _offers && _allowAll,
                onChanged: _allowAll
                    ? (val) => setState(() => _offers = val)
                    : (val) {},
              ),
              NotificationPreferenceCard(
                title: locale.notifications_prefs_family,
                subtitle: locale.notifications_prefs_family_subtitle,
                icon: Icons.groups_rounded,
                tagBadge: locale.notifications_prefs_family_badge,
                isEnabled: _family && _allowAll,
                onChanged: _allowAll
                    ? (val) => setState(() => _family = val)
                    : (val) {},
              ),
              NotificationPreferenceCard(
                title: locale.notifications_prefs_account,
                subtitle: locale.notifications_prefs_account_subtitle,
                icon: Icons.shield_rounded,
                isEnabled: _account && _allowAll,
                onChanged: _allowAll
                    ? (val) => setState(() => _account = val)
                    : (val) {},
              ),
              const SizedBox(height: Spacing.xs),
              const NotificationPreferencesInfoBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
