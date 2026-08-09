import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_programs/data/subscriptions_fake_data_source.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_package_choice_card.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_package_selector.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_selected_program_card.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_family_package_banner.dart';

class SubscriptionPackageSelectionScreen extends StatefulWidget {
  const SubscriptionPackageSelectionScreen({super.key, this.programIndex = 0});

  final int programIndex;

  @override
  State<SubscriptionPackageSelectionScreen> createState() =>
      _SubscriptionPackageSelectionScreenState();
}

class _SubscriptionPackageSelectionScreenState
    extends State<SubscriptionPackageSelectionScreen> {
  static const _dataSource = SubscriptionsFakeDataSource();

  int _selectedPackageIndex = 0;
  bool _isFamilyPackageSelected = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final packages = _dataSource.getPackageChoices().take(3).toList();

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
              itemCount: _isFamilyPackageSelected ? 3 : packages.length + 2,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SubscriptionSelectedProgramCard();
                }

                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: Spacing.xs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          locale.subscription_choose_plan_title,

                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                        ),
                     
                      ],
                    ),
                  );
                }

                if (_isFamilyPackageSelected) {
                  return SubscriptionFamilyPackageBanner(
                    onTap: () => context.pushNamed(AppRoutes.familyPlanDetails),
                  );
                }

                final packageIndex = index - 2;
                final package = packages[packageIndex];

                return SubscriptionPackageChoiceCard(
                  title: _packageTitle(locale, packageIndex),
                  subtitle: _packageSubtitle(locale, packageIndex),
                  price: package.price,
                  currency: package.currency,
                  isSelected: packageIndex == _selectedPackageIndex,
                  isPopular: package.isPopular,
                  onTap: () =>
                      _selectPackage(packageIndex, package.planDetailsIndex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _packageTitle(dynamic locale, int index) {
    return switch (index) {
      0 => locale.subscription_four_meals_package,
      1 => locale.subscription_three_meals_package,
      _ => locale.subscription_two_meals_package,
    };
  }

  String _packageSubtitle(dynamic locale, int index) {
    return switch (index) {
      0 => locale.subscription_four_meals_details,
      1 => locale.subscription_three_meals_details,
      _ => locale.subscription_two_meals_details,
    };
  }

  void _selectPackage(int index, int planDetailsIndex) {
    setState(() => _selectedPackageIndex = index);
    context.pushNamed(
      AppRoutes.subscriptionPlanDetails,
      arguments: planDetailsIndex,
    );
  }
}
