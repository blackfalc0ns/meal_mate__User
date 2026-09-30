import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_package_choice_card.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_selected_program_card.dart';

class SubscriptionPackageSelectionView extends StatelessWidget {
  const SubscriptionPackageSelectionView({
    super.key,
    required this.selectedProgram,
    required this.bundles,
    required this.selectedPackageNotifier,
    required this.onPackageSelected,
  });

  final SubscriptionProgramEntity selectedProgram;
  final List<SubscriptionBundleEntity> bundles;
  final ValueNotifier<int?> selectedPackageNotifier;
  final ValueChanged<int> onPackageSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.only(
            top: Spacing.xl,
            start: Spacing.lg,
            end: Spacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: SubscriptionSelectedProgramCard(
              program: selectedProgram,
            )
                .animate()
                .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0.1,
                  end: 0,
                  duration: 350.ms,
                  curve: Curves.easeOut,
                ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsetsDirectional.only(
            top: Spacing.md,
            bottom: Spacing.sm,
            start: Spacing.lg,
            end: Spacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              locale.subscription_choose_plan_title,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            )
                .animate()
                .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0.1,
                  end: 0,
                  duration: 350.ms,
                  curve: Curves.easeOut,
                ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.sm,
          ),
          sliver: SliverList.separated(
            itemCount: bundles.length,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, packageIndex) {
              final bundle = bundles[packageIndex];

              return ValueListenableBuilder<int?>(
                valueListenable: selectedPackageNotifier,
                builder: (context, selectedIndex, _) {
                  final isSelected = packageIndex == selectedIndex;

                  return SubscriptionPackageChoiceCard(
                    key: ValueKey(bundle.bundleId),
                    title: bundle.name(locale.localeName),
                    subtitle: bundle.formattedSubtitle(locale.localeName),
                    imageUrl: selectedProgram.imageUrl,
                    fallbackImageAsset: selectedProgram.fallbackImageAsset,
                    restaurantLogoUrls: bundle.restaurantLogoUrls,
                    badgeLabel: bundle.badge?.name(locale.localeName),
                    isSelected: isSelected,
                    isPopular: bundle.isMostSelected,
                    onTap: () => onPackageSelected(packageIndex),
                  );
                },
              )
                  .animate()
                  .fadeIn(
                    duration: 350.ms,
                    delay: (packageIndex * 70).ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 350.ms,
                    delay: (packageIndex * 70).ms,
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: Spacing.xl),
        ),
      ],
    );
  }
}
