import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_event.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_state.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_actions_bar.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_cutoff_banner.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_header_card.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_instructions_card.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_macros_card.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_review_meal_slot_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/staggered_slide_item.dart';

class FamilyReviewMemberMealsScreen extends StatefulWidget {
  const FamilyReviewMemberMealsScreen({super.key, this.args});

  final FamilyReviewMemberMealsArgs? args;

  @override
  State<FamilyReviewMemberMealsScreen> createState() =>
      _FamilyReviewMemberMealsScreenState();
}

class _FamilyReviewMemberMealsScreenState
    extends State<FamilyReviewMemberMealsScreen> {
  FamilyMealSelectionViewModel? _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.args?.selectionViewModel;
    if (_viewModel == null && widget.args?.viewModel != null) {
      _viewModel = getIt<FamilyMealSelectionViewModel>(
        param1: widget.args!.viewModel!,
        param2: FamilyMealSelectionState.fromCalendar(
          widget.args!.viewModel!.state,
          subscriptionId: widget.args?.subscriptionId,
          date: widget.args?.date,
          memberName: widget.args?.memberName,
          members: widget.args?.members,
        ),
      );
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel && _viewModel != null) {
      unawaited(_viewModel!.close());
    }
    super.dispose();
  }

  void _onConfirm(BuildContext context, String localeName) {
    _viewModel?.doIntent(ConfirmFamilyDayMealsEvent(localeName: localeName));
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel != null) {
      return BlocProvider<FamilyMealSelectionViewModel>.value(
        value: _viewModel!,
        child:
            BlocConsumer<
              FamilyMealSelectionViewModel,
              FamilyMealSelectionState
            >(
              listenWhen: (previous, current) =>
                  previous.saveMealsSuccess != current.saveMealsSuccess ||
                  previous.saveMealsFailure != current.saveMealsFailure,
              listener: (context, state) {
                final locale = context.localization;

                if (state.saveMealsSuccess) {
                  CustomSnackbar.showSuccess(
                    context: context,
                    message: locale.family_review_success_message,
                  );
                  Navigator.of(context).popUntil((route) {
                    return route.settings.name ==
                            AppRoutes.familyMemberDailyMeals ||
                        route.isFirst;
                  });
                } else if (state.saveMealsFailure != null) {
                  CustomSnackbar.showError(
                    context: context,
                    message: ErrorMessagePresenter.fromFailure(
                      context,
                      state.saveMealsFailure!,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return _buildContent(context, state: state);
              },
            ),
      );
    }

    final color = context.colorScheme;
    final locale = context.localization;
    return Scaffold(
      backgroundColor: color.surface,
      body: EmptyStateWidget(
        title: locale.calendar_empty_meals_title,
        description: locale.calendar_empty_meals_description,
        icon: Icons.restaurant_menu_rounded,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required FamilyMealSelectionState state,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;
    final argsMemberName = widget.args?.memberName;
    final String memberName = state.displayName.isNotEmpty
        ? state.displayName
        : ((argsMemberName != null && argsMemberName.isNotEmpty)
              ? argsMemberName
              : '');

    final restaurantName = state.selectedRestaurant?.name.isNotEmpty == true
        ? state.selectedRestaurant!.name
        : (state.selectedDay?.restaurant?.name ?? '');
    final meals = state.selectedMealsForDay;
    final nutrition = state.selectedNutritionTotals;

    final isSaving = state.isSavingMeals;
    final isLoading =
        state.isLoadingDay ||
        (meals.isEmpty &&
            (state.isLoadingAvailableMeals || state.isLoadingRestaurants));

    DateTime? parsedServiceDate;
    if (state.availableMeals?.serviceDate != null) {
      parsedServiceDate = DateTime.tryParse(state.availableMeals!.serviceDate!);
    }
    final selectedDate =
        state.selectedDate ?? state.selectedDay?.date ?? parsedServiceDate;
    final dateLabel = selectedDate != null
        ? intl.DateFormat.MMMMEEEEd(locale.localeName).format(selectedDate)
        : (state.selectedDay != null
              ? '${state.selectedDay!.weekday} ${state.selectedDay!.dayNumber}'
              : '');

    final programFromApi =
        state.availableMeals?.restaurant?.category.isNotEmpty == true
        ? state.availableMeals!.restaurant!.category
        : (state.selectedDay?.restaurant?.category.isNotEmpty == true
              ? state.selectedDay!.restaurant!.category
              : (state.currentMember?.programName.isNotEmpty == true
                    ? state.currentMember!.programName
                    : ''));

    final goalLabel = programFromApi.isNotEmpty
        ? programFromApi
        : locale.family_review_goal_balanced;

    final editDeadlineUtc = state.selectedDay?.editDeadlineUtc;
    final remaining = editDeadlineUtc?.difference(DateTime.now().toUtc());
    final remainingTime = remaining != null && remaining > Duration.zero
        ? locale.family_review_duration_hours_minutes(
            remaining.inHours,
            remaining.inMinutes % 60,
          )
        : null;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: color.surface,
          appBar: CustomAppBar(
            titleWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.family_review_title(memberName),
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size16,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs / 2),
                Text(
                  locale.family_review_subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            onBackPressed: () => Navigator.maybePop(context),
          ),
          bottomNavigationBar: FamilyReviewActionsBar(
            memberName: memberName,
            isLoading: isSaving,
            onEdit:
                (state.selectedDay?.isEditable == true && state.canUnitExchange)
                ? () => Navigator.maybePop(context)
                : null,
            onConfirm:
                (state.selectedDay?.isEditable == true &&
                    state.canConfirmMeals &&
                    meals.isNotEmpty)
                ? () => _onConfirm(context, locale.localeName)
                : null,
          ),
          body: isLoading
              ? const FamilyReviewLoadingSkeleton()
              : SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.screenH,
                      vertical: Spacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FamilyReviewHeaderCard(
                          memberName: memberName,
                          dateLabel: dateLabel,
                          statusLabel: locale.family_review_status_ready,
                          goalLabel: goalLabel,
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              size: Spacing.iconMd,
                              color: color.primary,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              locale.family_review_selected_meals_section,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.sm),
                        for (var i = 0; i < meals.length; i++) ...[
                          StaggeredSlideItem(
                            index: i,
                            child: FamilyReviewMealSlotCard(
                              meal: meals[i],
                              restaurantName: restaurantName,
                              onEdit: () => Navigator.maybePop(context),
                            ),
                          ),
                          if (i < meals.length - 1)
                            const SizedBox(height: Spacing.xs),
                        ],
                        if (meals.isEmpty)
                          EmptyStateWidget(
                            title: locale.calendar_empty_meals_title,
                            description:
                                locale.calendar_empty_meals_description,
                            icon: Icons.restaurant_menu_rounded,
                          ),
                        const SizedBox(height: Spacing.md),
                        FamilyReviewMacrosCard(nutrition: nutrition),
                        const SizedBox(height: Spacing.md),
                        FamilyReviewInstructionsCard(
                          instructions: const [],
                          note: locale.family_review_preferences_note,
                        ),
                        const SizedBox(height: Spacing.md),
                        if (remainingTime != null)
                          FamilyReviewCutoffBanner(
                            title: locale.family_review_cutoff_title,
                            description: locale.family_review_cutoff_desc,
                            remainingTime: remainingTime,
                            disclaimer: locale.family_review_cutoff_disclaimer,
                          ),
                        const SizedBox(height: Spacing.xl),
                      ],
                    ),
                  ),
                ),
        ),
        if (isSaving)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.35),
                child: const Center(child: CustomProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }
}
