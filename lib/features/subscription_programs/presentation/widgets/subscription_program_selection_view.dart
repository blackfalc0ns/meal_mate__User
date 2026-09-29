import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: Spacing.base,
                        start: Spacing.subscriptionProgramsHorizontalPadding,
                        end: Spacing.subscriptionProgramsHorizontalPadding,
                      ),
                      child: const SubscriptionProgramHeader()
                          .animate()
                          .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            duration: 350.ms,
                            curve: Curves.easeOut,
                          ),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsetsDirectional.only(
                              top: Spacing.base,
                              start:
                                  Spacing.subscriptionProgramsHorizontalPadding,
                              end:
                                  Spacing.subscriptionProgramsHorizontalPadding,
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
                                final keywords = program.keywords(
                                  locale.localeName,
                                );

                                return SubscriptionProgramGoalCard(
                                  key: ValueKey(program.programId),
                                  title: program.name(locale.localeName),
                                  description: program.description(
                                    locale.localeName,
                                  ),
                                  imageUrl: program.imageUrl,
                                  primaryFeature: _featureAt(keywords, 0),
                                  secondaryFeature: _featureAt(keywords, 1),
                                  isSelected: index == selectedProgramIndex,
                                  onTap: () => onProgramSelected(index),
                                )
                                    .animate()
                                    .fadeIn(
                                      duration: 350.ms,
                                      delay: (index * 70).ms,
                                      curve: Curves.easeOut,
                                    )
                                    .slideY(
                                      begin: 0.1,
                                      end: 0,
                                      duration: 350.ms,
                                      delay: (index * 70).ms,
                                      curve: Curves.easeOutCubic,
                                    );
                              },
                            ),
                          ),
                        ],
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
}
