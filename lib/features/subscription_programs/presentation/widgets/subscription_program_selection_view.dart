import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_goal_card.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_header.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_hero.dart';

import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/network/failures.dart';

class SubscriptionProgramSelectionView extends StatelessWidget {
  const SubscriptionProgramSelectionView({
    super.key,
    required this.showBottomSpace,
    required this.programs,
    required this.selectedProgramNotifier,
    required this.onProgramSelected,
    this.isLoadingMore = false,
    this.loadMoreFailure,
    this.onLoadMore,
    this.onRetryLoadMore,
    this.onAddressRequired,
  });

  final bool showBottomSpace;
  final List<SubscriptionProgramEntity> programs;
  final ValueListenable<int?> selectedProgramNotifier;
  final ValueChanged<int> onProgramSelected;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRetryLoadMore;
  final VoidCallback? onAddressRequired;

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
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 200 &&
                              !isLoadingMore) {
                            onLoadMore?.call();
                          }
                          return false;
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsetsDirectional.only(
                                top: Spacing.base,
                                start: Spacing
                                    .subscriptionProgramsHorizontalPadding,
                                end: Spacing
                                    .subscriptionProgramsHorizontalPadding,
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

                                  return ValueListenableBuilder<int?>(
                                        valueListenable:
                                            selectedProgramNotifier,
                                        builder:
                                            (context, selectedProgramIndex, _) {
                                              final isSelected =
                                                  index == selectedProgramIndex;

                                              final isAddressRequired =
                                                  !program.canSelect &&
                                                  (program.availability
                                                              ?.isAddressRequired ==
                                                          true ||
                                                      program.availability
                                                              ?.status ==
                                                          'address_required');

                                              return SubscriptionProgramGoalCard(
                                                key: ValueKey(
                                                  program.programId,
                                                ),
                                                title: program.name(
                                                  locale.localeName,
                                                ),
                                                description: program
                                                    .description(
                                                      locale.localeName,
                                                    ),
                                                imageUrl: program.imageUrl,
                                                primaryFeature: _featureAt(
                                                  keywords,
                                                  0,
                                                ),
                                                secondaryFeature: _featureAt(
                                                  keywords,
                                                  1,
                                                ),
                                                isSelected: isSelected,
                                                canSelect: program.canSelect,
                                                disabledNotice: program.canSelect
                                                    ? null
                                                    : isAddressRequired
                                                        ? locale
                                                            .subscription_program_address_required_badge
                                                        : locale
                                                            .subscription_program_no_restaurants_in_area,
                                                onTap: () {
                                                  if (program.canSelect) {
                                                    onProgramSelected(index);
                                                  } else if (isAddressRequired) {
                                                    onAddressRequired?.call();
                                                  } else {
                                                    final messenger =
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        );
                                                    messenger
                                                        .hideCurrentSnackBar();
                                                    messenger.showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          _disabledProgramMessage(
                                                            context,
                                                            program,
                                                          ),
                                                          style:
                                                              getRegularStyle(
                                                                fontFamily:
                                                                    FontConstant
                                                                        .alexandria,
                                                                fontSize:
                                                                    FontSize
                                                                        .size12,
                                                                color: color
                                                                    .onError,
                                                              ),
                                                        ),
                                                        backgroundColor:
                                                            color.error,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        duration:
                                                            const Duration(
                                                              seconds: 3,
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            },
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
                            if (isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(Spacing.md),
                                  child: Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                ),
                              ),
                            if (loadMoreFailure != null)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing
                                        .subscriptionProgramsHorizontalPadding,
                                    vertical: Spacing.sm,
                                  ),
                                  child: InlineApiErrorWidget(
                                    failure: loadMoreFailure!,
                                    onRetry: onRetryLoadMore,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
  String _disabledProgramMessage(
    BuildContext context,
    SubscriptionProgramEntity program,
  ) {
    final locale = context.localization;
    final code = program.availability?.messageCode ?? program.disabledReason;
    if (code != null && code.isNotEmpty) {
      if (code == 'subscription_flow.no_prepared_restaurants' ||
          code == 'no_prepared_restaurants' ||
          code == 'subscription_flow.no_restaurants_for_selection' ||
          code == 'no_restaurants_for_selection' ||
          code == 'no_restaurants_for_address') {
        return locale.subscription_program_no_prepared_restaurants_notice;
      }
      return mapFailureMessage(context, code);
    }
    return locale.subscription_program_no_prepared_restaurants_notice;
  }
}
