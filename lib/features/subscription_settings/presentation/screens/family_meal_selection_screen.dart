import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_meal_selection_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_review_member_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_bottom_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_category_chips.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_macros_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_meal_selection_stepper.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/staggered_slide_item.dart';

class FamilyMealSelectionScreen extends StatefulWidget {
  const FamilyMealSelectionScreen({super.key, this.args});

  final FamilyMealSelectionArgs? args;

  @override
  State<FamilyMealSelectionScreen> createState() =>
      _FamilyMealSelectionScreenState();
}

class _FamilyMealSelectionScreenState extends State<FamilyMealSelectionScreen> {
  FamilyCalendarViewModel? _viewModel;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.args?.viewModel != null) {
      _viewModel = widget.args!.viewModel;
    } else if (getIt.isRegistered<FamilyCalendarViewModel>()) {
      _viewModel = getIt<FamilyCalendarViewModel>();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    if (_viewModel != null) {
      final locale = context.localization;
      final restaurant = widget.args?.restaurant;
      if (restaurant != null &&
          _viewModel!.state.selectedRestaurant?.id != restaurant.id) {
        _viewModel!.doIntent(
          SelectFamilyRestaurantEvent(
            restaurant: restaurant,
            localeName: locale.localeName,
          ),
        );
      } else {
        _viewModel!.doIntent(
          LoadFamilyAvailableMealsEvent(
            slot: widget.args?.slot,
            localeName: locale.localeName,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (_viewModel == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.calendar_empty_meals_title,
          description: locale.calendar_empty_meals_description,
          icon: Icons.restaurant_menu_rounded,
        ),
      );
    }

    return BlocProvider<FamilyCalendarViewModel>.value(
      value: _viewModel!,
      child: BlocBuilder<FamilyCalendarViewModel, FamilyCalendarState>(
        builder: (context, state) {
          final activeMemberName = state.displayName.isNotEmpty
              ? state.displayName
              : (widget.args?.memberName ?? '');

          final restaurantName =
              state.selectedRestaurant?.name.isNotEmpty == true
              ? state.selectedRestaurant!.name
              : (state.availableMeals?.restaurant?.name.isNotEmpty == true
                    ? state.availableMeals!.restaurant!.name
                    : (widget.args?.restaurantName ?? ''));

          final slotName = widget.args?.slot.isNotEmpty == true
              ? widget.args!.slot
              : '';

          final selectedDate =
              state.selectedDate ?? widget.args?.date ?? DateTime.now();
          final formattedShortDate = intl.DateFormat.MMMMd(
            locale.localeName,
          ).format(selectedDate);

          final availableMeals = state.availableMeals?.meals ?? const [];
          final slotRequirements =
              state.selectedDay?.slotRequirements.isNotEmpty == true
              ? state.selectedDay!.slotRequirements
              : (state.availableMeals?.slotRequirements ?? const []);
          final availableSlots = slotRequirements
              .map((requirement) => requirement.slot.trim().toLowerCase())
              .where((slot) => slot.isNotEmpty)
              .toSet();
          final requiredCount = state.availableMeals?.requiredMealsCount ?? 0;
          final selectedCount = state.selectedMealsForDay.length;

          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              titleWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.family_meal_selection_title(activeMemberName),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size16,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs / 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (restaurantName.isNotEmpty) ...[
                        Text(
                          restaurantName,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.primary,
                          ),
                        ),
                        if (slotName.isNotEmpty) ...[
                          const SizedBox(width: Spacing.xs / 2),
                          Container(
                            width: 3.0,
                            height: 3.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.primary,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs / 2),
                        ],
                      ],
                      if (slotName.isNotEmpty)
                        Text(
                          slotName,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onSurface,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              onBackPressed: () => Navigator.maybePop(context),
            ),
            bottomNavigationBar: FamilyMealSelectionBottomBar(
              selectedCount: selectedCount,
              totalCount: requiredCount,
              slotAndDateLabel: '$slotName • $formattedShortDate',
              onContinue: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.familyReviewMemberMeals,
                  arguments: FamilyReviewMemberMealsArgs(
                    subscriptionId:
                        state.activeSubscriptionId ??
                        widget.args?.subscriptionId ??
                        '',
                    date: selectedDate,
                    memberName: activeMemberName,
                    memberId: state.currentMember?.memberId,
                    viewModel: _viewModel,
                  ),
                );
              },
            ),
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                  vertical: Spacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FamilyMealSelectionStepper(currentStep: 2),
                    const SizedBox(height: Spacing.md),
                    FamilyMealSelectionMacrosCard(
                      macros: state.selectedNutritionTotals,
                    ),
                    const SizedBox(height: Spacing.base),
                    FamilyMealSelectionCategoryChips(
                      selectedIndex: state.selectedCategoryIndex,
                      availableSlots: availableSlots,
                      onSelected: (index) {
                        _viewModel!.doIntent(
                          SelectFamilyMealCategoryEvent(
                            index: index,
                            localeName: locale.localeName,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Spacing.base),
                    if (state.isLoadingAvailableMeals && availableMeals.isEmpty)
                      const FamilyMealSelectionLoadingSkeleton()
                    else if (state.availableMealsFailure != null &&
                        availableMeals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.lg,
                        ),
                        child: ApiErrorWidget(
                          exception: state.availableMealsFailure!.exception,
                          onRetry: () {
                            _viewModel!.doIntent(
                              LoadFamilyAvailableMealsEvent(
                                slot: _slotForCategory(
                                  state.selectedCategoryIndex,
                                ),
                                localeName: locale.localeName,
                              ),
                            );
                          },
                        ),
                      )
                    else if (availableMeals.isNotEmpty)
                      for (int i = 0; i < availableMeals.length; i++)
                        StaggeredSlideItem(
                          key: ValueKey('meal-${availableMeals[i].id}-$i'),
                          index: i,
                          child: FamilyMealSelectionCard(
                            meal: availableMeals[i].copyWith(
                              selected:
                                  availableMeals[i].selected ||
                                  state.selectedMealsForDay.any(
                                    (selectedMeal) =>
                                        selectedMeal.id == availableMeals[i].id,
                                  ),
                            ),
                            onSelect: () {
                              _viewModel!.doIntent(
                                SelectMealForSlotEvent(
                                  meal: availableMeals[i],
                                  slot: availableMeals[i].slot,
                                ),
                              );
                            },
                          ),
                        )
                    else
                      EmptyStateWidget(
                        title: locale.calendar_empty_meals_title,
                        description: locale.calendar_empty_meals_description,
                        icon: Icons.restaurant_menu_rounded,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? _slotForCategory(int index) {
    return switch (index) {
      1 => 'breakfast',
      2 => 'lunch',
      3 => 'dinner',
      4 => 'snack',
      _ => null,
    };
  }
}
