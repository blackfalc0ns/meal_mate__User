import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_event.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_assurance_card.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_grid.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_header.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_search_field.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_restaurants_summary_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/staggered_slide_item.dart';

class FamilyRestaurantsScreen extends StatefulWidget {
  const FamilyRestaurantsScreen({super.key, this.args});
  final FamilyRestaurantsArgs? args;

  @override
  State<FamilyRestaurantsScreen> createState() =>
      _FamilyRestaurantsScreenState();
}

class _FamilyRestaurantsScreenState extends State<FamilyRestaurantsScreen> {
  FamilyMealSelectionViewModel? _viewModel;
  bool _initialized = false;
  String? _lastSearchQuery;

  @override
  void initState() {
    super.initState();
    final calendar = widget.args?.viewModel ?? getIt<FamilyCalendarViewModel>();
    _viewModel = getIt<FamilyMealSelectionViewModel>(
      param1: calendar,
      param2: FamilyMealSelectionState.fromCalendar(
        calendar.state,
        subscriptionId: widget.args?.subscriptionId,
        date: widget.args?.date,
        memberName: widget.args?.memberName,
        members: widget.args?.members,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _loadRestaurants(context.localization.localeName);
  }

  @override
  void dispose() {
    if (_viewModel != null) unawaited(_viewModel!.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    if (_viewModel == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: const SafeArea(child: FamilyRestaurantsLoadingSkeleton()),
      );
    }
    return BlocProvider<FamilyMealSelectionViewModel>.value(
      value: _viewModel!,
      child:
          BlocConsumer<FamilyMealSelectionViewModel, FamilyMealSelectionState>(
            listenWhen: (previous, current) =>
                previous.selectedMemberIndex != current.selectedMemberIndex,
            listener: (context, state) {
              _loadRestaurants(context.localization.localeName);
            },
            builder: _buildContent,
          ),
    );
  }

  Widget _buildContent(BuildContext context, FamilyMealSelectionState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    final memberName = state.displayName.isNotEmpty
        ? state.displayName
        : (widget.args?.memberName ?? '');
    final date = state.selectedDate ?? widget.args?.date ?? DateTime.now();
    final day = state.selectedDay;
    final selectedCount = day?.meals.length ?? 0;
    final requiredCount = day?.slotRequirements.length ?? 0;
    final members = state.members
        .map(
          (member) => FamilyRestaurantsMemberData(
            name: member.displayName,
            isSelected: member.memberId == state.currentMember?.memberId,
          ),
        )
        .toList();
    final summary = FamilyRestaurantsSummaryData(
      selectedMeals: '$selectedCount',
      selectedMealsTotal: '/$requiredCount',
      selectedMealsLabel:
          locale.family_restaurants_summary_selected_meals_label,
      dailyMeals: '$requiredCount',
      dailyMealsLabel: locale.family_restaurants_summary_daily_meals_label,
      calories: '${day?.nutritionTotals.calories ?? 0}',
      caloriesLabel: locale.family_restaurants_summary_calories_label,
      programLabel: state.currentMember?.programName ?? '',
    );
    final restaurants = state.filteredRestaurants
        .map(
          (restaurant) => FamilyRestaurantCardData(
            id: restaurant.id,
            name: restaurant.name,
            subtitle: restaurant.description,
            imageUrl: _resolveRestaurantMealImage(restaurant),
            logoUrl: restaurant.logoUrl,
            rating: restaurant.rating ?? '',
            tags: _resolveRestaurantTags(restaurant, state, locale, color),
            buttonLabel: locale.family_restaurants_browse_meals,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.familyRestaurantsHorizontalPadding,
            end: Spacing.familyRestaurantsHorizontalPadding,
            bottom: Spacing.familyRestaurantsBottomSpace,
          ),
          child: Column(
            children: [
              StaggeredSlideItem(
                index: 0,
                child: FamilyRestaurantsHeader(
                  title: locale.family_restaurants_title(memberName),
                  dateLabel: intl.DateFormat.yMMMMEEEEd(
                    locale.localeName,
                  ).format(date),
                  members: members,
                  onMemberSelected: (index) {
                    _viewModel!.doIntent(
                      SelectMealSelectionMemberEvent(
                        index: index,
                        localeName: locale.localeName,
                      ),
                    );
                  },
                  onBackPressed: () => Navigator.maybePop(context),
                ),
              ),
              const SizedBox(height: Spacing.md),
              StaggeredSlideItem(
                index: 1,
                child: FamilyRestaurantsSummaryCard(
                  memberName: memberName,
                  summary: summary,
                ),
              ),
              const SizedBox(height: Spacing.familyRestaurantsSearchTopGap),
              StaggeredSlideItem(
                index: 2,
                child: FamilyRestaurantsSearchField(
                  hint: locale.family_restaurants_search_hint,
                  onChanged: (query) =>
                      _loadRestaurants(locale.localeName, query),
                ),
              ),
              const SizedBox(height: Spacing.familyRestaurantsGridTopGap),
              if (state.restaurantsFailure != null && restaurants.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.md),
                  child: InlineApiErrorWidget(
                    failure: state.restaurantsFailure!,
                    onRetry: () =>
                        _loadRestaurants(locale.localeName, _lastSearchQuery),
                  ),
                ),
              if (state.isLoadingRestaurants && restaurants.isEmpty)
                const FamilyRestaurantsLoadingSkeleton()
              else if (state.restaurantsFailure != null && restaurants.isEmpty)
                ApiErrorWidget(
                  exception: state.restaurantsFailure!.exception,
                  onRetry: () =>
                      _loadRestaurants(locale.localeName, _lastSearchQuery),
                )
              else if (restaurants.isEmpty)
                EmptyStateWidget(
                  title: locale.subscription_no_restaurants_for_area,
                  description: locale.family_restaurants_subtitle,
                  icon: Icons.restaurant_rounded,
                )
              else
                FamilyRestaurantsGrid(
                  restaurants: restaurants,
                  onRestaurantSelected: (card) => _selectRestaurant(
                    context,
                    state,
                    card,
                    date,
                    memberName,
                    locale.localeName,
                  ),
                ),
              const SizedBox(height: Spacing.familyRestaurantsAssuranceTopGap),
              StaggeredSlideItem(
                index: 3,
                child: FamilyRestaurantsAssuranceCard(
                  title: locale.family_restaurants_assurance_title,
                  subtitle: locale.family_restaurants_assurance_subtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadRestaurants(String localeName, [String? query]) {
    _lastSearchQuery = query;
    _viewModel?.doIntent(
      LoadFamilyRestaurantsEvent(query: query, localeName: localeName),
    );
  }

  void _selectRestaurant(
    BuildContext context,
    FamilyMealSelectionState state,
    FamilyRestaurantCardData card,
    DateTime date,
    String memberName,
    String localeName,
  ) {
    final restaurant = state.restaurants.firstWhere(
      (item) => item.id == card.id,
      orElse: () => CalendarRestaurantOptionEntity(
        id: card.id,
        name: card.name,
        description: card.subtitle,
        mealCount: 0,
        rating: card.rating,
        logoType: CalendarRestaurantLogoType.healthyBowl,
      ),
    );
    _viewModel!.doIntent(
      SelectFamilyRestaurantEvent(
        restaurant: restaurant,
        localeName: localeName,
      ),
    );
    Navigator.of(context).pushNamed(
      AppRoutes.familyMealSelection,
      arguments: FamilyMealSelectionArgs(
        subscriptionId:
            state.activeSubscriptionId ?? widget.args?.subscriptionId ?? '',
        date: date,
        memberName: memberName,
        slot: widget.args?.slot ?? '',
        restaurant: restaurant,
        restaurantName: restaurant.name,
        viewModel: _viewModel?.calendar,
        selectionViewModel: _viewModel,
      ),
    );
  }

  String? _resolveRestaurantMealImage(
    CalendarRestaurantOptionEntity restaurant,
  ) {
    if (restaurant.logoUrl != null &&
        restaurant.logoUrl!.isNotEmpty &&
        (restaurant.logoUrl!.startsWith('http://') ||
            restaurant.logoUrl!.startsWith('https://'))) {
      return restaurant.logoUrl;
    }
    return restaurant.logoUrl;
  }

  List<FamilyRestaurantsFilterData> _resolveRestaurantTags(
    CalendarRestaurantOptionEntity restaurant,
    FamilyMealSelectionState state,
    dynamic locale,
    ColorScheme color,
  ) {
    final tags = <FamilyRestaurantsFilterData>[];

    final programName = state.currentMember?.programName.isNotEmpty == true
        ? state.currentMember!.programName
        : (restaurant.tierName.isNotEmpty
              ? restaurant.tierName
              : locale.family_restaurants_filter_balanced);
    tags.add(
      FamilyRestaurantsFilterData(
        label: programName,
        icon: Icons.balance_rounded,
        iconColor: color.primary,
      ),
    );

    final slotReqs = state.selectedDay?.slotRequirements ?? const [];
    if (slotReqs.isNotEmpty) {
      for (final req in slotReqs) {
        tags.add(
          FamilyRestaurantsFilterData(
            label: req.slot,
            icon: Icons.wb_sunny_rounded,
            iconColor: color.secondary,
          ),
        );
      }
    } else {
      tags.add(
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_breakfast,
          icon: Icons.wb_sunny_rounded,
          iconColor: color.secondary,
        ),
      );
      tags.add(
        FamilyRestaurantsFilterData(
          label: locale.family_restaurants_filter_lunch,
          icon: Icons.wb_sunny_rounded,
          iconColor: color.secondary,
        ),
      );
    }

    return tags;
  }
}
