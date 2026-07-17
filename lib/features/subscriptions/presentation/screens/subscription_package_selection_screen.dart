import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscriptions/data/subscriptions_fake_data_source.dart';
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
  static const _dataSource = SubscriptionsFakeDataSource();

  int _selectedPackageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final packages = _dataSource.getPackageChoices();

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

  void _selectPackage(int index, int planDetailsIndex) {
    setState(() => _selectedPackageIndex = index);
    context.pushNamed(
      AppRoutes.subscriptionPlanDetails,
      arguments: planDetailsIndex,
    );
  }
}
