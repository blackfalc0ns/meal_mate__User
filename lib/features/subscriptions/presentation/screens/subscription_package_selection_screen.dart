import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_package_choice_card.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_selected_program_card.dart';

class SubscriptionPackageSelectionScreen extends StatefulWidget {
  const SubscriptionPackageSelectionScreen({super.key, this.programIndex = 0});

  final int programIndex;

  @override
  State<SubscriptionPackageSelectionScreen> createState() =>
      _SubscriptionPackageSelectionScreenState();
}

class _SubscriptionPackageSelectionScreenState
    extends State<SubscriptionPackageSelectionScreen> {
  int _selectedPackageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final packages = [
      (
        title: locale.subscription_four_meals_package,
        subtitle: locale.subscription_four_meals_details,
        price: null,
        currency: null,
      ),
      (
        title: locale.subscription_three_meals_package,
        subtitle: locale.subscription_three_meals_details,
        price: null,
        currency: null,
      ),
      (
        title: locale.subscription_two_meals_package,
        subtitle: locale.subscription_two_meals_details,
        price: null,
        currency: null,
      ),
      (
        title: locale.subscription_week_plan_title,
        subtitle: locale.subscription_week_duration,
        price: locale.subscription_week_plan_price,
        currency: locale.currency,
      ),
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: const AppLogo(alignment: CrossAxisAlignment.center),
        backgroundColor: color.surface,
        onBackPressed: () => Navigator.maybePop(context),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.xl,
            ),
            sliver: SliverList.separated(
              itemCount: packages.length + 2,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SubscriptionSelectedProgramCard();
                }

                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: Spacing.sm),
                    child: Text(
                      locale.subscription_choose_plan_title,
                      textAlign: TextAlign.right,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size17,
                        color: color.onSurface,
                      ),
                    ),
                  );
                }

                final packageIndex = index - 2;
                final package = packages[packageIndex];

                return SubscriptionPackageChoiceCard(
                  title: package.title,
                  subtitle: package.subtitle,
                  price: package.price,
                  currency: package.currency,
                  isSelected: packageIndex == _selectedPackageIndex,
                  isPopular: packageIndex == 0,
                  onTap: () => _selectPackage(packageIndex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectPackage(int index) =>
      setState(() => _selectedPackageIndex = index);
}
