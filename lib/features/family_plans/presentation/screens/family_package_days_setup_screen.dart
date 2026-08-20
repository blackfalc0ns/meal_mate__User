import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tiers_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_day_options_row.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_friday_delivery_card.dart';
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
    this.members = const [],
    this.selectedMember,
    this.packageOptions = const [],
    this.dayOptions = const [],
    this.summary,
  });

  final List<FamilyProgramMemberUiModel> members;
  final FamilyProgramMemberDetailsUiModel? selectedMember;
  final List<FamilyPackageOptionUiModel> packageOptions;
  final List<FamilyDayOptionUiModel> dayOptions;
  final FamilySelectionSummaryData? summary;

  @override
  State<FamilyPackageDaysSetupScreen> createState() =>
      _FamilyPackageDaysSetupScreenState();
}

class _FamilyPackageDaysSetupScreenState
    extends State<FamilyPackageDaysSetupScreen> {
  int _selectedPackageIndex = 0;
  int _selectedDayIndex = 0;
  int _selectedTierIndex = 1;
  bool _fridayDeliverySelected = true;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayedMembers =
        widget.members.isNotEmpty
            ? widget.members
            : [
              FamilyProgramMemberUiModel(
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

    final packageOptions =
        widget.packageOptions.isNotEmpty
            ? widget.packageOptions
            : [
              FamilyPackageOptionUiModel(
                title: locale.family_subscription_package_value,
                description: locale.subscription_summary_daily_meals,
                icon: FamilyPackageOptionIcon.appleCutlery,
              ),
              FamilyPackageOptionUiModel(
                title: locale.family_package_three_meals_title,
                description: locale.family_package_three_meals_description,
                icon: FamilyPackageOptionIcon.cutlery,
              ),
              FamilyPackageOptionUiModel(
                title: locale.family_package_two_meals_title,
                description: locale.family_package_two_meals_description,
                icon: FamilyPackageOptionIcon.cutlery,
              ),
            ];

    final selectedPackageOptions = List<FamilyPackageOptionUiModel>.generate(
      packageOptions.length,
      (index) => FamilyPackageOptionUiModel(
        title: packageOptions[index].title,
        description: packageOptions[index].description,
        icon: packageOptions[index].icon,
        isSelected: index == _selectedPackageIndex,
      ),
    );

    final effectiveDayOptions =
        widget.dayOptions.isNotEmpty
            ? widget.dayOptions
            : [
              FamilyDayOptionUiModel(label: locale.family_days_7),
              FamilyDayOptionUiModel(label: locale.family_days_14),
              FamilyDayOptionUiModel(label: locale.family_days_30),
            ];

    final selectedDayOptions = List<FamilyDayOptionUiModel>.generate(
      effectiveDayOptions.length,
      (index) => FamilyDayOptionUiModel(
        label: effectiveDayOptions[index].label,
        isSelected: index == _selectedDayIndex,
      ),
    );

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

    return Scaffold(
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.familySetupHorizontalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  FamilySetupHeaderBadge(),
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
                  const SizedBox(height: Spacing.familyPackageTitleTopGap),
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
                  FamilyPackageOptionsGrid(
                    options: selectedPackageOptions,
                    onOptionSelected:
                        (index) => setState(
                          () => _selectedPackageIndex = index,
                        ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    locale.family_days_choose_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.base),
                  FamilyDayOptionsRow(
                    options: selectedDayOptions,
                    onOptionSelected:
                        (index) => setState(
                          () => _selectedDayIndex = index,
                        ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  FamilyFridayDeliveryCard(
                    selected: _fridayDeliverySelected,
                    onChanged:
                        (selected) => setState(
                          () => _fridayDeliverySelected = selected,
                        ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  RestaurantPackageTiersSection(
                    packages: tierOptions,
                    selectedIndex: _selectedTierIndex,
                    onSelected: (index) => setState(
                      () => _selectedTierIndex = index,
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
        ),
      ),
    );
  }
}

