import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_event.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_state.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_view_model.dart';
import 'package:meal_meat_user/features/meal_details/presentation/mapper/subscription_meal_details_presentation_mapper.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_content.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_header_image.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_rating_badge.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, this.meal, this.args})
    : assert(meal != null || args != null);

  final MealDetailsEntity? meal;
  final SubscriptionMealDetailsArgs? args;

  @override
  Widget build(BuildContext context) {
    final detailsArgs = args;

    if (detailsArgs != null) {
      return BlocProvider(
        create: (_) => getIt<MealDetailsViewModel>()
          ..doIntent(
            GetMealDetailsEvent(
              programId: detailsArgs.programId,
              bundleId: detailsArgs.bundleId,
              restaurantId: detailsArgs.restaurantId,
              mealId: detailsArgs.mealId,
            ),
          ),
        child: BlocBuilder<MealDetailsViewModel, MealDetailsState>(
          builder: (context, state) {
            return _buildApiState(context, state, detailsArgs);
          },
        ),
      );
    }

    return _buildDetails(context, meal!);
  }

  Widget _buildApiState(
    BuildContext context,
    MealDetailsState state,
    SubscriptionMealDetailsArgs detailsArgs,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textDirection = locale.localeName == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    if (state.isLoading && state.meal == null) {
      return Directionality(
        textDirection: textDirection,
        child: Scaffold(
          backgroundColor: color.surface,
          body: Stack(
            children: [
              const LoadingWidget.fullScreen(),
              CustomBackButton(onPressed: () => Navigator.maybePop(context)),
            ],
          ),
        ),
      );
    }

    if (state.failure != null && state.meal == null) {
      return Directionality(
        textDirection: textDirection,
        child: Scaffold(
          backgroundColor: color.surface,
          body: ApiErrorWidget(
            exception: state.failure!.exception,
            onRetry: () {
              context.read<MealDetailsViewModel>().doIntent(
                GetMealDetailsEvent(
                  programId: detailsArgs.programId,
                  bundleId: detailsArgs.bundleId,
                  restaurantId: detailsArgs.restaurantId,
                  mealId: detailsArgs.mealId,
                ),
              );
            },
          ),
        ),
      );
    }

    final mealDetails = state.meal;
    if (mealDetails == null) {
      return Directionality(
        textDirection: textDirection,
        child: Scaffold(
          backgroundColor: color.surface,
          body: EmptyStateWidget(
            title: locale.calendar_ingredients,
            description: locale.subscription_packages_empty_description,
            icon: Icons.restaurant_menu_rounded,
          ),
        ),
      );
    }

    return _buildDetails(
      context,
      SubscriptionMealDetailsPresentationMapper.map(
        meal: mealDetails,
        locale: locale,
        restaurantInitials: detailsArgs.restaurantInitials,
        fallbackRating: detailsArgs.restaurantRating,
      ),
    );
  }

  Widget _buildDetails(BuildContext context, MealDetailsEntity details) {
    final color = context.colorScheme;
    const overlap =
        Spacing.restaurantDetailsHeroHeight - Spacing.restaurantDetailsSheetTop;
    const imageHeight = Spacing.xxxl * 4 + Spacing.xxl;
    return Scaffold(
      backgroundColor: color.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: Spacing.zero,
                  left: Spacing.zero,
                  right: Spacing.zero,
                  child: Stack(
                    children: [
                      MealDetailsHeaderImage(
                        label: details.title,
                        imageUrl: details.headerImageUrl,
                      ),
                      Positioned(
                        left: Spacing.xl,
                        bottom: Spacing.xxl + overlap,
                        child: MealDetailsRatingBadge(
                          title: details.ratingTitle,
                          value: details.ratingValue,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: imageHeight - overlap),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                        Spacing.restaurantDetailsSheetRadius,
                      ),
                    ),
                    child: ColoredBox(
                      color: color.surface,
                      child: MealDetailsContent(meal: details),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomBackButton(onPressed: () => Navigator.maybePop(context)),
        ],
      ),
    );
  }
}
