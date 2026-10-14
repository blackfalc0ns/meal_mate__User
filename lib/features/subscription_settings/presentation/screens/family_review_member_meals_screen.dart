import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_review_member_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_actions_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_cutoff_banner.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_header_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_instructions_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_macros_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_meal_slot_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/staggered_slide_item.dart';

class FamilyReviewMemberMealsScreen extends StatefulWidget {
  const FamilyReviewMemberMealsScreen({super.key, this.args});

  final FamilyReviewMemberMealsArgs? args;

  @override
  State<FamilyReviewMemberMealsScreen> createState() =>
      _FamilyReviewMemberMealsScreenState();
}

class _FamilyReviewMemberMealsScreenState
    extends State<FamilyReviewMemberMealsScreen> {
  FamilyCalendarViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.args?.viewModel;
  }

  void _onConfirm(BuildContext context, String localeName) {
    _viewModel?.doIntent(SaveFamilyDayMealsEvent(localeName: localeName));
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel != null) {
      return BlocProvider<FamilyCalendarViewModel>.value(
        value: _viewModel!,
        child: BlocConsumer<FamilyCalendarViewModel, FamilyCalendarState>(
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
    required FamilyCalendarState state,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;
    final memberName = state.displayName.isNotEmpty
        ? state.displayName
        : (widget.args?.memberName.isNotEmpty == true
              ? widget.args!.memberName
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

    final defaultInstructions = locale.localeName == 'ar'
        ? const ['لا طعام حار', 'يفضل الأرز البني', 'بدون مكسرات']
        : const ['No spicy food', 'Prefers brown rice', 'Nut-free'];

    final editDeadlineUtc = state.selectedDay?.editDeadlineUtc;
    final String remainingTime;
    if (editDeadlineUtc != null) {
      final diff = editDeadlineUtc.difference(DateTime.now().toUtc());
      if (!diff.isNegative) {
        remainingTime = locale.localeName == 'ar'
            ? '${diff.inHours} ساعة و ${diff.inMinutes % 60} دقيقة'
            : '${diff.inHours}h ${diff.inMinutes % 60}m';
      } else {
        remainingTime = locale.localeName == 'ar'
            ? '22 ساعة و 18 دقيقة'
            : '22 hours and 18 minutes';
      }
    } else {
      remainingTime = locale.localeName == 'ar'
          ? '22 ساعة و 18 دقيقة'
          : '22 hours and 18 minutes';
    }

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
            onEdit: () => Navigator.maybePop(context),
            onConfirm: () => _onConfirm(context, locale.localeName),
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
                          instructions: defaultInstructions,
                          note: locale.family_review_preferences_note,
                        ),
                        const SizedBox(height: Spacing.md),
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
