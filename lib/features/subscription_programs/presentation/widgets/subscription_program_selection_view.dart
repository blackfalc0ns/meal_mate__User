import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_programs/data/subscriptions_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_goal_card.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_header.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_hero.dart';

class SubscriptionProgramSelectionView extends StatefulWidget {
  const SubscriptionProgramSelectionView({
    super.key,
    required this.showBottomSpace,
    required this.onProgramSelected,
  });

  final bool showBottomSpace;
  final ValueChanged<int> onProgramSelected;

  @override
  State<SubscriptionProgramSelectionView> createState() =>
      _SubscriptionProgramSelectionViewState();
}

class _SubscriptionProgramSelectionViewState
    extends State<SubscriptionProgramSelectionView> {
  static const _dataSource = SubscriptionsFakeDataSource();
  int? _selectedProgramIndex;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final programs = _dataSource.getPrograms();

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
                        bottom: widget.showBottomSpace
                            ? Spacing.subscriptionProgramsBottomSpace
                            : Spacing.xl,
                      ),
                      sliver: SliverList.separated(
                        itemCount: programs.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: Spacing.sm),
                        itemBuilder: (context, index) {
                          final program = programs[index];

                          return SubscriptionProgramGoalCard(
                            title: program.title,
                            description: program.description,
                            imageAsset: program.imageAsset,
                            primaryFeature: program.primaryFeature,
                            secondaryFeature: program.secondaryFeature,
                            badgeIcon: program.badgeIcon,
                            primaryFeatureIcon: program.primaryFeatureIcon,
                            secondaryFeatureIcon: program.secondaryFeatureIcon,
                            isSelected: index == _selectedProgramIndex,
                            onTap: () => _selectProgram(index),
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

  void _selectProgram(int index) {
    setState(() => _selectedProgramIndex = index);
    widget.onProgramSelected(index);
  }
}
