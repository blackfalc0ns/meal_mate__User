import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_confirmation_body.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_confirmation_loading_skeleton.dart';

class RestaurantTierUpgradeConfirmationScreen extends StatefulWidget {
  const RestaurantTierUpgradeConfirmationScreen({super.key, this.args});

  final RestaurantTierUpgradeConfirmationArgs? args;

  @override
  State<RestaurantTierUpgradeConfirmationScreen> createState() =>
      _RestaurantTierUpgradeConfirmationScreenState();
}

class _RestaurantTierUpgradeConfirmationScreenState
    extends State<RestaurantTierUpgradeConfirmationScreen> {
  late final RestaurantTierUpgradeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<RestaurantTierUpgradeViewModel>();

    final args = widget.args;
    if (args != null) {
      _viewModel.doIntent(InitUpgradeConfirmationEvent(args));
    }
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final args = widget.args;

    if (args == null) {
      return Scaffold(
        appBar: CustomAppBar(
          elevation: Spacing.zero,
          title: locale.restaurant_tier_upgrade_confirm_title,
        ),
        body: EmptyStateWidget(
          title: locale.restaurant_tier_upgrade_confirm_title,
          description: locale.restaurant_tier_upgrade_no_data,
          icon: Icons.error_outline_rounded,
        ),
      );
    }

    return BlocProvider<RestaurantTierUpgradeViewModel>.value(
      value: _viewModel,
      child:
          BlocConsumer<
            RestaurantTierUpgradeViewModel,
            RestaurantTierUpgradeState
          >(
            listenWhen: (previous, current) =>
                previous.isUpgradeSuccess != current.isUpgradeSuccess ||
                previous.upgradeRequestResult != current.upgradeRequestResult ||
                previous.submitFailure != current.submitFailure,
            listener: (context, state) {
              if (state.isUpgradeSuccess) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message: locale.restaurant_tier_upgrade_success,
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
                return;
              }

              final requestResult = state.upgradeRequestResult;
              if (requestResult != null &&
                  requestResult.paymentUrl != null &&
                  requestResult.paymentUrl!.isNotEmpty) {
                context.pushNamed(
                  AppRoutes.restaurantTierUpgradeWebView,
                  arguments: RestaurantTierUpgradeWebViewArgs(
                    subscriptionId: state.subscriptionId,
                    upgradeId: requestResult.upgradeId,
                    paymentUrl: requestResult.paymentUrl!,
                  ),
                );
                return;
              }

              if (state.submitFailure != null) {
                final message = ErrorMessagePresenter.fromFailure(
                  context,
                  state.submitFailure!,
                );
                CustomSnackbar.showError(context: context, message: message);
              }
            },
            buildWhen: (previous, current) =>
                previous.isLoadingSummary != current.isLoadingSummary ||
                previous.summaryFailure != current.summaryFailure,
            builder: (context, state) {
              if (state.isLoadingSummary) {
                return const RestaurantTierConfirmationLoadingSkeleton();
              }

              if (state.summaryFailure != null) {
                return Scaffold(
                  appBar: CustomAppBar(
                    elevation: Spacing.zero,
                    title: locale.restaurant_tier_upgrade_confirm_title,
                  ),
                  body: ApiErrorWidget(
                    exception: state.summaryFailure!.exception,
                    onRetry: () => _viewModel.doIntent(
                      InitUpgradeConfirmationEvent(args),
                    ),
                  ),
                );
              }

              final selectedOption =
                  state.selectedOption ?? args.selectedOption;

              return Semantics(
                label: locale.nav_subscription,
                child: Scaffold(
                  appBar: CustomAppBar(
                    elevation: Spacing.zero,
                    title: locale.restaurant_tier_upgrade_confirm_title,
                  ),
                  body: RestaurantTierConfirmationBody(
                    optionsEntity: args.optionsEntity,
                    selectedOption: selectedOption,
                    programName: args.programName,
                    onPaymentMethodSelected: (method) => _viewModel.doIntent(
                      SelectUpgradePaymentMethodEvent(method),
                    ),
                    onConfirm: () => _viewModel.doIntent(
                      const SubmitUpgradeRequestEvent(),
                    ),
                    onBack: () => context.pop(),
                  ),
                ),
              );
            },
          ),
    );
  }
}
