import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
      ),
      (
        title: locale.subscription_three_meals_package,
        subtitle: locale.subscription_three_meals_details,
      ),
      (
        title: locale.subscription_two_meals_package,
        subtitle: locale.subscription_two_meals_details,
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: Spacing.lg),
                  child: Center(child: AppLogo()),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.xl,
                ),
                sliver: SliverList.separated(
                  itemCount: packages.length + 2,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: Spacing.md),
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
                      isSelected: packageIndex == _selectedPackageIndex,
                      isPopular: packageIndex == 0,
                      onTap: () => _selectPackage(packageIndex),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectPackage(int index) {
    setState(() => _selectedPackageIndex = index);
    context.pushNamed(AppRoutes.subscriptionPlanDetails, arguments: index);
  }
}
