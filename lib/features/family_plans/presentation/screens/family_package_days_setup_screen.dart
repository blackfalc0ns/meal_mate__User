import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tiers_section.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_package_options_grid.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_note_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';

class FamilyPackageDaysSetupScreen extends StatefulWidget {
  const FamilyPackageDaysSetupScreen({
    super.key,
    this.programId,
    this.members = const [],
    this.selectedMember,
  });

  final String? programId;
  final List<FamilyProgramMemberUiModel> members;
  final FamilyProgramMemberDetailsUiModel? selectedMember;

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

    final displayedMembers =
        widget.members.isNotEmpty
            ? widget.members
            : [
              const FamilyProgramMemberUiModel(
                name: 'Yahya',
                imageAsset: '',
                status: '',
                isSelected: true,
                isInProgress: true,
              ),
            ];

    final activeMember =
        widget.selectedMember ??
        (displayedMembers.isNotEmpty
            ? FamilyProgramMemberDetailsUiModel(
              name: displayedMembers.first.name,
              imageAsset: '',
              age: '28',
              gender: '',
              goal: '',
              activityLevel: '',
            )
            : null);

    final tierOptions = [
      RestaurantPackageTierUiModel(
        id: 'select',
        title: locale.localeName == 'ar' ? 'سيلكت' : 'Select',
        iconName: 'heart',
        restaurantCount: 25,
        restaurantLogoUrls: const [],
      ),
      RestaurantPackageTierUiModel(
        id: 'plus',
        title: locale.localeName == 'ar' ? 'بلس' : 'Plus',
        iconName: 'crown',
        restaurantCount: 50,
        restaurantLogoUrls: const [],
      ),
      RestaurantPackageTierUiModel(
        id: 'max',
        title: locale.localeName == 'ar' ? 'ماكس' : 'Max',
        iconName: 'diamond',
        restaurantCount: 100,
        restaurantLogoUrls: const [],
      ),
    ];

    return BlocProvider<FamilyPlanViewModel>(
      create: (_) {
        final vm = getIt<FamilyPlanViewModel>();
        if (widget.programId != null && widget.programId!.isNotEmpty) {
          vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
        } else {
          vm.doIntent(const GetFamilyProgramsEvent());
        }
        return vm;
      },
      child: Scaffold(
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
              final displayedPackages =
                  state.bundles
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
                        if (displayedMembers.isNotEmpty)
                          FamilyProgramMemberStrip(members: displayedMembers),
                        const SizedBox(
                          height: Spacing.familyProgramSummaryTopGap,
                        ),
                        if (activeMember != null)
                          FamilyProgramSummaryCard(member: activeMember),
                        const SizedBox(
                          height: Spacing.familyPackageTitleTopGap,
                        ),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Spacing.lg,
                            ),
                            child: Center(child: LoadingWidget()),
                          )
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
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Spacing.lg,
                            ),
                            child: Center(child: LoadingWidget()),
                          )
                        else if (state.durations.isNotEmpty)
                          SubscriptionDurationSelector(
                            selectedIndex: state.selectedDurationIndex,
                            onSelected: (index) => context
                                .read<FamilyPlanViewModel>()
                                .doIntent(
                                  SelectFamilyDurationEvent(index),
                                ),
                            includesFriday: state.includeFriday,
                            onFridayChanged: (value) => context
                                .read<FamilyPlanViewModel>()
                                .doIntent(
                                  ToggleFamilyFridayEvent(value),
                                ),
                            customDurationDays: state.customDurationDays,
                            onCustomDurationChanged: (value) => context
                                .read<FamilyPlanViewModel>()
                                .doIntent(
                                  UpdateFamilyCustomDurationEvent(value),
                                ),
                            durations: state.durations,
                            isFridayEnabled: true,
                            isLoading: state.isDurationsLoading,
                          ),
                        const SizedBox(height: Spacing.lg),
                        RestaurantPackageTiersSection(
                          packages: tierOptions,
                          selectedIndex: state.selectedTierIndex,
                          onSelected: (index) => context
                              .read<FamilyPlanViewModel>()
                              .doIntent(
                                SelectFamilyTierEvent(index),
                              ),
                          onBrowseRestaurants: (index) {},
                        ),
                        const SizedBox(height: Spacing.lg),
                        const FamilyPaymentNoteCard(),
                        const SizedBox(height: Spacing.md),
                        FamilyProgramActions(
                          nextText: locale.family_next_payment,
                          nextIcon: Icons.credit_card_rounded,
                          onNextPressed:
                              () => context.pushNamed(
                                AppRoutes.familyPaymentSetup,
                              ),
                        ),
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
}
