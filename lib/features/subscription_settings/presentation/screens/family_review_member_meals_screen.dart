import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_review_member_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_actions_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_macros_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_meal_slot_card.dart';

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
            final color = context.colorScheme;
            final locale = context.localization;

            if (state.saveMealsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    locale.family_review_success_message,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onPrimary,
                    ),
                  ),
                  backgroundColor: color.primary,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.of(context).popUntil((route) {
                return route.settings.name ==
                        AppRoutes.familyMemberDayDetails ||
                    route.isFirst;
              });
            } else if (state.saveMealsFailure != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ErrorMessagePresenter.fromFailure(
                      context,
                      state.saveMealsFailure!,
                    ),
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onError,
                    ),
                  ),
                  backgroundColor: color.error,
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

    return Scaffold(
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
      body: SafeArea(
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
              for (final meal in meals)
                FamilyReviewMealSlotCard(
                  meal: meal,
                  restaurantName: restaurantName,
                  onEdit: () => Navigator.maybePop(context),
                ),
              if (meals.isEmpty)
                EmptyStateWidget(
                  title: locale.calendar_empty_meals_title,
                  description: locale.calendar_empty_meals_description,
                  icon: Icons.restaurant_menu_rounded,
                ),
              const SizedBox(height: Spacing.base),
              FamilyReviewMacrosCard(nutrition: nutrition),
              const SizedBox(height: Spacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
