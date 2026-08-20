import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tiers_section.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_browse_restaurants_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_package_days_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_package_options_grid.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_package_options_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_note_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_restaurant_grid_card.dart';

class FamilyPackageDaysSetupScreen extends StatefulWidget {
  const FamilyPackageDaysSetupScreen({super.key, this.programId});

  final String? programId;

  @override
  State<FamilyPackageDaysSetupScreen> createState() =>
      _FamilyPackageDaysSetupScreenState();
}

class _FamilyPackageDaysSetupScreenState
    extends State<FamilyPackageDaysSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyPlanViewModel>(
      create: (_) {
        final vm = getIt<FamilyPlanViewModel>();
        vm.doIntent(const GetFamilySubscriptionCurrentEvent());
        if (widget.programId != null && widget.programId!.isNotEmpty) {
          vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
        } else {
          vm.doIntent(const GetFamilyProgramsEvent());
        }
        return vm;
      },
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          showBackButton: true,
          titleWidget: Column(
            children: [
              Text(
                locale.family_setup_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              Text(
                locale.family_setup_subtitle,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<FamilyPlanViewModel, FamilyPlanState>(
            builder: (context, state) {
              if ((state.isLoading || state.isCurrentFlowLoading) &&
                  state.bundles.isEmpty &&
                  state.members.isEmpty) {
                return const FamilyPackageDaysSetupLoadingSkeleton();
              }

              final members = state.members;
              final selectedMember = state.selectedMember;

              final displayedMembers = members.asMap().entries.map((entry) {
                final index = entry.key;
                final m = entry.value;
                final isSelected = index == state.selectedMemberIndex;
                return FamilyProgramMemberUiModel(
                  name: m.displayName,
                  imageAsset: '',
                  status: m.isReady
                      ? locale.family_member_completed
                      : locale.family_member_in_progress,
                  isSelected: isSelected,
                  isInProgress: !m.isReady,
                );
              }).toList();

              final activeMemberDetails = selectedMember != null
                  ? FamilyProgramMemberDetailsUiModel(
                      name: selectedMember.displayName,
                      imageAsset: '',
                      age: '${selectedMember.ageYears} ${locale.family_year}',
                      gender: selectedMember.gender == 2
                          ? locale.family_gender_female
                          : locale.family_gender_male,
                      roleLabel:
                          selectedMember.isManager ? locale.family_owner : '',
                    )
                  : (members.isNotEmpty
                        ? FamilyProgramMemberDetailsUiModel(
                            name: members.first.displayName,
                            imageAsset: '',
                            age:
                                '${members.first.ageYears} ${locale.family_year}',
                            gender: members.first.gender == 2
                                ? locale.family_gender_female
                                : locale.family_gender_male,
                            roleLabel: members.first.isManager
                                ? locale.family_owner
                                : '',
                          )
                        : null);

              final displayedPackages = state.bundles
                  .map(
                    (b) => FamilyPackageOptionUiModel(
                      title: b.name(locale.localeName),
                      description: b.description(locale.localeName),
                      imageUrl: b.imageUrl,
                    ),
                  )
                  .toList();

              final selectedPackageOptions =
                  List<FamilyPackageOptionUiModel>.generate(
                    displayedPackages.length,
                    (index) => FamilyPackageOptionUiModel(
                      title: displayedPackages[index].title,
                      description: displayedPackages[index].description,
                      imageUrl: displayedPackages[index].imageUrl,
                      imageAsset: displayedPackages[index].imageAsset,
                      isSelected: index == state.selectedBundleIndex,
                    ),
                  );

              final displayedTiers = state.tiers
                  .map(
                    (t) => RestaurantPackageTierUiModel(
                      id: t.tier,
                      title: t.name(locale.localeName),
                      iconName: t.tier.toLowerCase().contains('max')
                          ? 'diamond'
                          : t.tier.toLowerCase().contains('plus')
                          ? 'crown'
                          : 'heart',
                      restaurantCount: t.restaurantCount,
                      restaurantLogoUrls: t.restaurants
                          .map((r) => r.logoUrl)
                          .where((url) => url != null && url.isNotEmpty)
                          .toList(),
                    ),
                  )
                  .toList();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.familySetupHorizontalPadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        const FamilySetupHeaderBadge(),
                        const SizedBox(
                          height: Spacing.familyProgramProgressTopGap,
                        ),
                        const FamilyProgramStepper(
                          currentStep: 2,
                          includeFamilyCreationStep: true,
                        ),
                        const SizedBox(
                          height: Spacing.familyProgramMemberTopGap,
                        ),

                        // Scrollable Member Strip
                        if (displayedMembers.isNotEmpty) ...[
                          FamilyProgramMemberStrip(
                            members: displayedMembers,
                            onSelectMember: (index) {
                              context.read<FamilyPlanViewModel>().doIntent(
                                SelectFamilyMemberEvent(index),
                              );
                            },
                          ),
                          const SizedBox(
                            height: Spacing.familyProgramSummaryTopGap,
                          ),
                        ],

                        // Active Member Summary Card
                        if (activeMemberDetails != null) ...[
                          FamilyProgramSummaryCard(member: activeMemberDetails),
                          const SizedBox(
                            height: Spacing.familyPackageTitleTopGap,
                          ),
                        ],

                        Text(
                          locale.family_package_choose_title,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          locale.family_package_choose_subtitle,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(
                          height: Spacing.familyPackageOptionsTopGap,
                        ),

                        if (state.isBundlesLoading && state.bundles.isEmpty)
                          const FamilyPackageOptionsLoadingSkeleton()
                        else if (selectedPackageOptions.isNotEmpty)
                          FamilyPackageOptionsGrid(
                            options: selectedPackageOptions,
                            onOptionSelected: (index) {
                              context.read<FamilyPlanViewModel>().doIntent(
                                SelectFamilyBundleEvent(index),
                              );
                            },
                          ),

                        const SizedBox(height: Spacing.md),

                        if (state.isDurationsLoading && state.durations.isEmpty)
                          const SubscriptionDurationSelectorSkeleton()
                        else if (state.durations.isNotEmpty)
                          SubscriptionDurationSelector(
                            selectedIndex: state.selectedDurationIndex,
                            onSelected: (index) {
                              context.read<FamilyPlanViewModel>().doIntent(
                                SelectFamilyDurationEvent(index),
                              );
                            },
                            includesFriday: state.includeFriday,
                            onFridayChanged: (include) {
                              context.read<FamilyPlanViewModel>().doIntent(
                                ToggleFamilyFridayEvent(include),
                              );
                            },
                            customDurationDays: state.customDurationDays,
                            onCustomDurationChanged: (days) {
                              context.read<FamilyPlanViewModel>().doIntent(
                                UpdateFamilyCustomDurationEvent(days),
                              );
                            },
                            durations: state.durations,
                            isFridayEnabled: true,
                            isLoading: state.isDurationsLoading,
                          ),

                        const SizedBox(height: Spacing.md),

                        if (state.isRestaurantsView)
                          ..._buildBrowseRestaurantsView(context, state)
                        else ...[
                          RestaurantPackageTiersSection(
                            packages: displayedTiers,
                            selectedIndex: state.selectedTierIndex,
                            onSelected: (index) => context
                                .read<FamilyPlanViewModel>()
                                .doIntent(SelectFamilyTierEvent(index)),
                            onBrowseRestaurants: (index) =>
                                context.read<FamilyPlanViewModel>().doIntent(
                                  BrowseFamilyTierRestaurantsEvent(index),
                                ),
                          ),
                          const SizedBox(height: Spacing.lg),
                          const FamilyPaymentNoteCard(),
                          const SizedBox(height: Spacing.md),
                          FamilyProgramActions(
                            nextText: locale.family_next_payment,
                            nextIcon: Icons.credit_card_rounded,
                            onNextPressed: () {
                              _savePlanAndProceed(context, state);
                            },
                          ),
                        ],
                        const SizedBox(height: Spacing.xxxl),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _savePlanAndProceed(BuildContext context, FamilyPlanState state) {
    final member =
        state.selectedMember ??
        (state.members.isNotEmpty ? state.members.first : null);
    final programId =
        widget.programId ??
        state.selectedProgram?.programId ??
        (state.programs.isNotEmpty ? state.programs.first.programId : '');
    final bundle = state.selectedBundle;
    final duration = state.selectedDuration;
    final tier = state.selectedTier;

    if (member != null &&
        programId.isNotEmpty &&
        bundle != null &&
        duration != null &&
        tier != null) {
      final tierInt = int.tryParse(tier.tier) ?? 1;
      context.read<FamilyPlanViewModel>().doIntent(
        SaveFamilyMemberPlanEvent(
          memberId: member.memberId,
          programId: programId,
          bundleId: bundle.bundleId,
          tier: tierInt,
          durationDays: duration.durationDays ?? 0,
          includeFriday: state.includeFriday,
        ),
      );
    }

    final hasUnreadyMembers = state.members.any(
      (m) => m.memberId != member?.memberId && !m.isReady,
    );

    if (hasUnreadyMembers) {
      final nextIndex = state.members.indexWhere(
        (m) => m.memberId != member?.memberId && !m.isReady,
      );
      if (nextIndex != -1) {
        context.read<FamilyPlanViewModel>().doIntent(
          SelectFamilyMemberEvent(nextIndex),
        );
      }
      Navigator.maybePop(context);
    } else {
      context.pushNamed(AppRoutes.familyPaymentSetup);
    }
  }

  List<Widget> _buildBrowseRestaurantsView(
    BuildContext context,
    FamilyPlanState state,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final bundle = state.selectedBundle;

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locale.calendar_browse_restaurants,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.read<FamilyPlanViewModel>().doIntent(
              const CloseFamilyBrowseRestaurantsEvent(),
            ),
          ),
        ],
      ),
      const SizedBox(height: Spacing.md),
      if (state.isBrowseRestaurantsLoading)
        const FamilyBrowseRestaurantsLoadingSkeleton()
      else if (state.browseRestaurants.isEmpty)
        EmptyStateWidget(
          title: locale.family_packages_empty,
          description: '',
          icon: Icons.storefront_rounded,
        )
      else
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
            childAspectRatio: 0.8,
          ),
          itemCount: state.browseRestaurants.length,
          itemBuilder: (context, index) {
            final restaurant = state.browseRestaurants[index];
            final programId =
                widget.programId ??
                state.selectedProgram?.programId ??
                bundle?.programId ??
                '';
            final planEntity = restaurant.toRestaurantPlan(
              programId: programId,
              bundleId: bundle?.bundleId ?? '',
              localeName: locale.localeName,
              brandColor: color.primary,
            );
            return MonthlyRestaurantGridCard(restaurant: planEntity);
          },
        ),
      const SizedBox(height: Spacing.lg),
    ];
  }
}
