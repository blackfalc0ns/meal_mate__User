import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_goal_card.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_header.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_hero.dart';

class SubscriptionProgramSelectionView extends StatelessWidget {
  const SubscriptionProgramSelectionView({
    super.key,
    required this.showBottomSpace,
    required this.programs,
    required this.selectedProgramIndex,
    required this.onProgramSelected,
  });

  final bool showBottomSpace;
  final List<SubscriptionProgramEntity> programs;
  final int? selectedProgramIndex;
  final ValueChanged<int> onProgramSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: ColoredBox(
        color: color.surface,
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Spacing.subscriptionProgramsHeroHeight,
              child: SubscriptionProgramHero(),
            ),
            Positioned.fill(
              top: Spacing.subscriptionProgramsContentTop,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Spacing.radiusXl),
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: Spacing.base,
                          left: Spacing.subscriptionProgramsHorizontalPadding,
                          right: Spacing.subscriptionProgramsHorizontalPadding,
                        ),
                        child: SubscriptionProgramHeader(),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: Spacing.base,
                        left: Spacing.subscriptionProgramsHorizontalPadding,
                        right: Spacing.subscriptionProgramsHorizontalPadding,
                        bottom: showBottomSpace
                            ? Spacing.subscriptionProgramsBottomSpace
                            : Spacing.xl,
                      ),
                      sliver: SliverList.separated(
                        itemCount: programs.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: Spacing.sm),
                        itemBuilder: (context, index) {
                          final program = programs[index];
                          final keywords = program.keywords(locale.localeName);

                          return SubscriptionProgramGoalCard(
                            title: program.name(locale.localeName),
                            description: program.description(locale.localeName),
                            imageUrl: program.imageUrl,
                            fallbackImageAsset: program.fallbackImageAsset,
                            primaryFeature: _featureAt(keywords, 0),
                            secondaryFeature: _featureAt(keywords, 1),
                            badgeIcon: _badgeIconForProgram(program),
                            primaryFeatureIcon: _primaryFeatureIconForProgram(
                              program,
                            ),
                            secondaryFeatureIcon:
                                _secondaryFeatureIconForProgram(program),
                            isSelected: index == selectedProgramIndex,
                            onTap: () => onProgramSelected(index),
                          );
                        },
                      ),
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

  String _featureAt(List<String> keywords, int index) {
    if (index >= keywords.length) return '';
    return keywords[index];
  }

  IconData _badgeIconForProgram(SubscriptionProgramEntity program) {
    return switch (program.code) {
      'PROG_WEIGHT_LOSS' => Icons.monitor_weight_outlined,
      'PROG_MUSCLE_GAIN' => Icons.fitness_center_rounded,
      'PROG_ATHLETE' => Icons.directions_run_rounded,
      'PROG_KETO' => Icons.water_drop_rounded,
      'PROG_BALANCED' => Icons.favorite_border_rounded,
      'PROG_LOW_CARB' => Icons.eco_rounded,
      _ => Icons.restaurant_menu_rounded,
    };
  }

  IconData _primaryFeatureIconForProgram(SubscriptionProgramEntity program) {
    return switch (program.code) {
      'PROG_WEIGHT_LOSS' => Icons.bar_chart_rounded,
      'PROG_BALANCED' => Icons.eco_rounded,
      'PROG_ATHLETE' => Icons.bolt_rounded,
      _ => Icons.bolt_rounded,
    };
  }

  IconData _secondaryFeatureIconForProgram(SubscriptionProgramEntity program) {
    return switch (program.code) {
      'PROG_MUSCLE_GAIN' => Icons.sync_rounded,
      'PROG_ATHLETE' => Icons.sync_rounded,
      'PROG_LOW_CARB' => Icons.tune_rounded,
      _ => Icons.my_location_rounded,
    };
  }
}
