import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/meal_details/data/meal_details_fake_data_source.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_event.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_state.dart';
import 'package:meal_meat_user/features/meal_details/presentation/manager/meal_details_view_model.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_content.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_header_image.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_rating_badge.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, this.meal, this.args});

  static const _dataSource = MealDetailsFakeDataSource();

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

    return _buildDetails(context, meal ?? _dataSource.getMeal());
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
      _toPresentationEntity(
        mealDetails,
        locale,
        detailsArgs.restaurantInitials,
        detailsArgs.restaurantRating,
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

  MealDetailsEntity _toPresentationEntity(
    SubscriptionMealDetailsEntity meal,
    AppLocalizations locale,
    String? restaurantInitials,
    String? fallbackRating,
  ) {
    final localeName = locale.localeName;
    final restaurantName = meal.restaurantName(localeName);
    final ratingValue =
        _ratingValue(meal.restaurantRating, meal.restaurantRatingCount) ??
        fallbackRating ??
        '';
    final nutrition = meal.nutrition;

    return MealDetailsEntity(
      title: meal.name(localeName),
      description: meal.description(localeName),
      restaurantName: restaurantName,
      restaurantLogo: restaurantInitials ?? _initials(restaurantName),
      restaurantLogoUrl: meal.restaurantLogoUrl,
      headerImageUrl: meal.imageUrl,
      ratingTitle: localeName == 'ar' ? 'تقييم المطعم' : 'Restaurant rating',
      ratingValue: ratingValue,
      programLabel: localeName == 'ar' ? 'نوع الوجبة' : 'Meal type',
      programValue: meal.slotName(localeName),
      deliveryLabel: localeName == 'ar' ? 'وقت التوصيل' : 'Delivery time',
      deliveryValue: _deliveryWindow(
        meal.deliveryWindowStart,
        meal.deliveryWindowEnd,
      ),
      ingredientsTitle: locale.calendar_ingredients,
      ingredients: meal.ingredients
          .map(
            (ingredient) => MealDetailsIngredientEntity(
              label: ingredient.name(localeName),
              asset: _ingredientAsset(ingredient.category),
              iconUrl: ingredient.iconUrl,
            ),
          )
          .where((ingredient) => ingredient.label.isNotEmpty)
          .toList(),
      nutritionTitle: localeName == 'ar' ? 'القيم الغذائية' : 'Nutrition facts',
      nutritionItems: [
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.fiberG, localeName),
          label: localeName == 'ar' ? 'ألياف' : 'Fiber',
          type: MealDetailsNutritionType.fiber,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.proteinG, localeName),
          label: locale.calendar_protein,
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.carbsG, localeName),
          label: locale.calendar_carbs,
          type: MealDetailsNutritionType.carbs,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.fatG, localeName),
          label: locale.calendar_fat,
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsNutritionEntity(
          value: _plainNumber(nutrition.calories),
          label: locale.calendar_calories,
          type: MealDetailsNutritionType.calories,
        ),
      ],
      macroDistributionTitle: localeName == 'ar'
          ? 'توزيع العناصر الغذائية'
          : 'Macro distribution',
      macroItems: [
        MealDetailsMacroEntity(
          percent: _percent(nutrition.fatPercent, localeName),
          label: locale.calendar_fat,
          value: _gramValue(nutrition.fatG, localeName),
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsMacroEntity(
          percent: _percent(nutrition.proteinPercent, localeName),
          label: locale.calendar_protein,
          value: _gramValue(nutrition.proteinG, localeName),
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsMacroEntity(
          percent: _percent(nutrition.carbsPercent, localeName),
          label: locale.calendar_carbs,
          value: _gramValue(nutrition.carbsG, localeName),
          type: MealDetailsNutritionType.carbs,
        ),
      ],
      allergensTitle: localeName == 'ar' ? 'مسببات الحساسية' : 'Allergens',
      allergens: meal.allergens
          .map(
            (allergen) => MealDetailsAllergenEntity(
              label: allergen.name(localeName),
              type: _allergenType(allergen.type),
            ),
          )
          .where((allergen) => allergen.label.isNotEmpty)
          .toList(),
    );
  }

  String? _ratingValue(double? rating, int ratingCount) {
    if (rating == null) return null;
    final value = _plainNumber(rating);
    return ratingCount > 0 ? '$value ($ratingCount)' : value;
  }

  String _deliveryWindow(String? start, String? end) {
    if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) {
      return '';
    }
    if (start == null || start.isEmpty) return end ?? '';
    if (end == null || end.isEmpty) return start;
    return '$start - $end';
  }

  String _gramValue(double? value, String localeName) {
    if (value == null) return '-';
    return localeName == 'ar'
        ? '${_plainNumber(value)} جم'
        : '${_plainNumber(value)}g';
  }

  String _percent(int? value, String localeName) {
    if (value == null) return '-';
    return localeName == 'ar' ? '%$value' : '$value%';
  }

  String _plainNumber(num? value) {
    if (value == null) return '-';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  String _ingredientAsset(String category) {
    return switch (category.toLowerCase()) {
      'poultry' => AssetsFake.ingredientChicken,
      'grains' => AssetsFake.ingredientRice,
      'produce' => AssetsFake.ingredientBroccoli,
      _ => AssetsFake.ingredientBroccoli,
    };
  }

  MealDetailsAllergenType _allergenType(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('lactose') || normalized.contains('milk')) {
      return MealDetailsAllergenType.lactose;
    }
    if (normalized.contains('gluten') || normalized.contains('wheat')) {
      return MealDetailsAllergenType.gluten;
    }
    return MealDetailsAllergenType.nuts;
  }

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
