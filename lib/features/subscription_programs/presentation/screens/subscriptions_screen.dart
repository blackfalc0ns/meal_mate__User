import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/subscription_programs/data/subscriptions_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_type_card.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_type_notice.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  static const _dataSource = SubscriptionsFakeDataSource();
  int? _selectedTypeIndex;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final types = _dataSource.getSubscriptionTypes();

    return Semantics(
      label: locale.nav_subscription,
      child: Scaffold(
        backgroundColor: color.surface,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.subscriptionTypeBackground,
                  fit: BoxFit.cover,
                  semanticLabel: locale.nav_subscription,
                ),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: Spacing.screenH,
                      right: Spacing.screenH,
                      top: Spacing.lg,
                      bottom: widget.showBottomSpace
                          ? Spacing.subscriptionProgramsBottomSpace
                          : Spacing.xl,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        const Center(
                          child: AppLogo(
                            size: Spacing.subscriptionTypeLogoHeight,
                            alignment: CrossAxisAlignment.center,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Spacing.subscriptionProgramCardRadius,
                          ),
                          child: AspectRatio(
                            aspectRatio:
                                Spacing.subscriptionTypeHeroWidth /
                                Spacing.subscriptionTypeHeroHeight,
                            child: Image.asset(
                              Assets.subscriptionTypeHero,
                              fit: BoxFit.cover,
                              semanticLabel:
                                  locale.subscription_type_hero_label,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          locale.subscription_type_title,
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size20,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          locale.subscription_type_subtitle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        SubscriptionTypeCard(
                          type: types[0],
                          title: locale.subscription_type_individual_label,
                          description:
                              locale.subscription_type_individual_description,
                          features: [
                            locale.subscription_type_individual_customization,
                            locale
                                .subscription_type_individual_meal_flexibility,
                            locale.subscription_type_individual_restaurants,
                          ],
                          icons: const [
                            Icons.track_changes_rounded,
                            Icons.calendar_month_rounded,
                            Icons.store_rounded,
                          ],
                          isSelected: _selectedTypeIndex == 0,
                          onTap: () => _selectSubscriptionType(0),
                        ),
                        const SizedBox(height: Spacing.sm),
                        SubscriptionTypeCard(
                          type: types[1],
                          title: locale.subscription_type_family_label,
                          description:
                              locale.subscription_type_family_description,
                          features: [
                            locale.subscription_type_family_management,
                            locale.subscription_type_family_customization,
                            locale.subscription_type_family_members,
                          ],
                          icons: const [
                            Icons.groups_2_rounded,
                            Icons.person_rounded,
                            Icons.groups_rounded,
                          ],
                          isSelected: _selectedTypeIndex == 1,
                          onTap: () => _selectSubscriptionType(1),
                        ),
                        const SizedBox(height: Spacing.base),
                        SubscriptionTypeNotice(
                          message: locale.subscription_type_notice_label,
                        ),
                        const SizedBox(height: Spacing.md),
                        AppButton.filled(
                          text: locale.family_next_program,
                          onPressed: _selectedTypeIndex == null
                              ? null
                              : _openSelectedSubscription,
                          borderRadius: Spacing.radiusPill,
                          textColor: color.onPrimary,
                          fontSize: FontSize.size12,
                          iconWidget: Icon(
                            Icons.chevron_right_rounded,
                            color: color.onPrimary,
                            size: Spacing.iconMd,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectSubscriptionType(int index) {
    setState(() => _selectedTypeIndex = index);
  }

  void _openSelectedSubscription() {
    if (_selectedTypeIndex == 0) {
      context.pushNamed(AppRoutes.subscriptionProgramSelection);
      return;
    }

    context.pushNamed(AppRoutes.familyPlanDetails);
  }
}
