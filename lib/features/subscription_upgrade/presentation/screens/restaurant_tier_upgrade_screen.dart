import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_continue_section.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_selection_body.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_selection_loading_skeleton.dart';

class RestaurantTierUpgradeScreen extends StatefulWidget {
  const RestaurantTierUpgradeScreen({super.key, this.args});

  final RestaurantTierUpgradeArgs? args;

  @override
  State<RestaurantTierUpgradeScreen> createState() =>
      _RestaurantTierUpgradeScreenState();
}

class _RestaurantTierUpgradeScreenState
    extends State<RestaurantTierUpgradeScreen> {
  late final RestaurantTierUpgradeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<RestaurantTierUpgradeViewModel>();
    _viewModel.doIntent(
      LoadUpgradeOptionsEvent(subscriptionId: widget.args?.subscriptionId),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider<RestaurantTierUpgradeViewModel>.value(
      value: _viewModel,
      child:
          BlocBuilder<
            RestaurantTierUpgradeViewModel,
            RestaurantTierUpgradeState
          >(
            buildWhen: (previous, current) =>
                previous.isLoadingOptions != current.isLoadingOptions ||
                previous.optionsFailure != current.optionsFailure ||
                previous.optionsEntity != current.optionsEntity,
            builder: (context, state) {
              final title = locale.restaurant_tier_upgrade_title;

              if (state.isLoadingOptions) {
                return const RestaurantTierSelectionLoadingSkeleton();
              }

              if (state.optionsFailure != null) {
                return Scaffold(
                  appBar: CustomAppBar(elevation: Spacing.zero, title: title),
                  body: ApiErrorWidget(
                    exception: state.optionsFailure!.exception,
                    onRetry: () => _viewModel.doIntent(
                      LoadUpgradeOptionsEvent(
                        subscriptionId: widget.args?.subscriptionId,
                      ),
                    ),
                  ),
                );
              }

              final optionsEntity = state.optionsEntity;

              if (optionsEntity == null) {
                return Scaffold(
                  appBar: CustomAppBar(elevation: Spacing.zero, title: title),
                  body: EmptyStateWidget(
                    title: title,
                    description:
                        state.errorMessage ??
                        locale.subscription_upgrade_not_available,
                    icon: Icons.star_border_rounded,
                  ),
                );
              }

              if (!optionsEntity.canUpgrade) {
                final reason = optionsEntity.unavailableReason?.trim();
                final description = (reason != null && reason.isNotEmpty)
                    ? mapFailureMessage(context, reason)
                    : locale.restaurant_tier_unavailable_generic;

                return Scaffold(
                  appBar: CustomAppBar(elevation: Spacing.zero, title: title),
                  body: EmptyStateWidget(
                    title: title,
                    description: description,
                    icon: Icons.info_outline_rounded,
                  ),
                );
              }

              return Semantics(
                label: locale.nav_subscription,
                child: Scaffold(
                  appBar: CustomAppBar(elevation: Spacing.zero, title: title),
                  bottomNavigationBar: RestaurantTierContinueSection(
                    onContinue: (selectedOption) =>
                        _navigateToConfirmation(state, selectedOption),
                  ),
                  body: RestaurantTierSelectionBody(
                    optionsEntity: optionsEntity,
                    bundleName: state.bundleName,
                    onOptionSelected: (option) {
                      if (state.selectedOption?.targetTier ==
                          option.targetTier) {
                        _navigateToConfirmation(state, option);
                      } else {
                        _viewModel.doIntent(SelectTierOptionEvent(option));
                      }
                    },
                  ),
                ),
              );
            },
          ),
    );
  }

  void _navigateToConfirmation(
    RestaurantTierUpgradeState state,
    SubscriptionUpgradeOptionEntity selectedOption,
  ) {
    if (state.optionsEntity == null) return;
    context.pushNamed(
      AppRoutes.restaurantTierUpgradeConfirmation,
      arguments: RestaurantTierUpgradeConfirmationArgs(
        subscriptionId: state.subscriptionId,
        selectedOption: selectedOption,
        optionsEntity: state.optionsEntity!,
        programName: state.programName,
        bundleName: state.bundleName,
      ),
    );
  }
}
