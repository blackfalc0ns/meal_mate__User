import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_benefits_section.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_hero_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';

class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key});

  static const routeName = '/offer-details';
  static const _dataSource = OfferDetailsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final details = _dataSource.getOfferDetails();

    return Scaffold(
      backgroundColor: color.surface,
      extendBody: true,
      appBar: CustomAppBar(
        title: locale.offer_details_title,
        actions: [NotificationButton(onTap: () {})],
      ),

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.offerDetailsHorizontalPadding,
            end: Spacing.offerDetailsHorizontalPadding,
            top: Spacing.offerDetailsHeaderTopGap,
            bottom: Spacing.offerDetailsBottomNavGap,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OfferDetailsHeroCard(details: details),
              const SizedBox(height: Spacing.base),
              OfferDetailsInfoCard(details: details),
              const SizedBox(height: Spacing.md),
              OfferDetailsBenefitsSection(details: details),
              const SizedBox(height: Spacing.xl),
              AppButton(
                text: locale.offer_details_plan_section_title,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.subscriptions),
                height: Spacing.offerDetailsBottomButtonHeight,
                borderRadius: Spacing.offerDetailsBottomButtonRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.primary, color.tertiary],
                ),
                textColor: color.onPrimary,
                fontSize: FontSize.size15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
