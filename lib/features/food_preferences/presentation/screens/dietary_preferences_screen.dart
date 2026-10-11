import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_content.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_loading_skeleton.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_save_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

class DietaryPreferencesScreen extends StatelessWidget {
  const DietaryPreferencesScreen({super.key, this.args});

  final SubscriptionFlowArgs? args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodPreferencesViewModel>(
      create: (_) => getIt<FoodPreferencesViewModel>()
        ..doIntent(const GetFoodPreferencesEvent())
        ..doIntent(const GetFoodPreferencesCatalogEvent()),
      child: BlocListener<FoodPreferencesViewModel, FoodPreferencesState>(
        listenWhen: (previous, current) => previous.action != current.action,
        listener: (context, state) {
          if (state.action.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.action.failure!,
              ),
            );
          } else if (state.action.isSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: context.localization.dietary_preferences_update_success,
            );
            if (args?.isSubscriptionSource == true) {
              Navigator.of(context).pop(true);
            }
          }
        },
        child: const _DietaryPreferencesScreenBody(),
      ),
    );
  }
}

class _DietaryPreferencesScreenBody extends StatelessWidget {
  const _DietaryPreferencesScreenBody();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: locale.profile_dietary_preferences,
            titleFontSize: FontSize.size15,
            backgroundColor: color.surface,
            showShadow: false,
          ),
          body: BlocBuilder<FoodPreferencesViewModel, FoodPreferencesState>(
            buildWhen: (previous, current) =>
                previous.preferences.isLoading !=
                    current.preferences.isLoading ||
                previous.preferences.data != current.preferences.data ||
                previous.preferences.failure != current.preferences.failure ||
                previous.catalog.isLoading != current.catalog.isLoading ||
                previous.catalog.data != current.catalog.data ||
                previous.catalog.failure != current.catalog.failure,
            builder: (context, state) {
              final preferencesState = state.preferences;
              final catalogState = state.catalog;
              final catalog = catalogState.data;

              if ((preferencesState.isLoading &&
                      preferencesState.data == null) ||
                  (catalogState.isLoading && catalog == null)) {
                return const DietaryPreferencesLoadingSkeleton();
              }

              final failure = preferencesState.failure ?? catalogState.failure;
              if (failure != null &&
                  (preferencesState.data == null || catalog == null)) {
                return ApiErrorWidget(
                  exception: failure.exception,
                  onRetry: () {
                    context.read<FoodPreferencesViewModel>()
                      ..doIntent(const GetFoodPreferencesEvent())
                      ..doIntent(const GetFoodPreferencesCatalogEvent());
                  },
                );
              }

              final content = SafeArea(
                top: false,
                child: DietaryPreferencesContent(catalog: catalog),
              );

              if (MediaQuery.disableAnimationsOf(context)) {
                return content;
              }

              return content
                  .animate()
                  .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                  .slideY(
                    begin: 0.04,
                    end: 0,
                    duration: 350.ms,
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
          bottomNavigationBar:
              BlocSelector<
                FoodPreferencesViewModel,
                FoodPreferencesState,
                ({bool isReady, bool isLoading})
              >(
                selector: (state) => (
                  isReady:
                      state.catalog.data != null &&
                      state.preferences.data != null,
                  isLoading: state.action.isLoading,
                ),
                builder: (context, data) {
                  if (!data.isReady) return const SizedBox.shrink();
                  final saveSection = DietaryPreferencesSaveSection(
                    isLoading: data.isLoading,
                  );

                  if (MediaQuery.disableAnimationsOf(context)) {
                    return saveSection;
                  }

                  return saveSection
                      .animate()
                      .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 300.ms,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
        ),
        BlocSelector<FoodPreferencesViewModel, FoodPreferencesState, bool>(
          selector: (state) => state.action.isLoading,
          builder: (context, isLoading) {
            if (!isLoading) return const SizedBox.shrink();
            return Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: color.scrim.withValues(alpha: 0.35),
                  child: const Center(child: CustomProgressIndicator()),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
