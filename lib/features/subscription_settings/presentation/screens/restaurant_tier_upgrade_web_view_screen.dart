import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/payment_redirect_web_view.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_view_model.dart';

class RestaurantTierUpgradeWebViewScreen extends StatefulWidget {
  const RestaurantTierUpgradeWebViewScreen({super.key, this.args});

  final RestaurantTierUpgradeWebViewArgs? args;

  @override
  State<RestaurantTierUpgradeWebViewScreen> createState() =>
      _RestaurantTierUpgradeWebViewScreenState();
}

class _RestaurantTierUpgradeWebViewScreenState
    extends State<RestaurantTierUpgradeWebViewScreen> {
  late final RestaurantTierUpgradeViewModel _viewModel;
  bool _hasStartedVerification = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<RestaurantTierUpgradeViewModel>();
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

    if (args == null || args.paymentUrl.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: locale.payment_title),
        body: EmptyStateWidget(
          title: locale.payment_title,
          description: locale.payment_secure_label,
          icon: Icons.payment_rounded,
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
                previous.isUpgradeFailed != current.isUpgradeFailed,
            listener: (context, state) {
              final color = context.colorScheme;
              if (state.isUpgradeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(locale.payment_success_title),
                    backgroundColor: color.primary,
                  ),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
                return;
              }

              if (state.isUpgradeFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(locale.error_other_desc),
                    backgroundColor: color.error,
                  ),
                );
                Navigator.maybePop(context, false);
              }
            },
            builder: (context, state) {
              final failure = state.statusFailure;
              if (failure != null) {
                return Scaffold(
                  appBar: CustomAppBar(title: locale.payment_title),
                  body: ApiErrorWidget(
                    exception: failure.exception,
                    onRetry: () => _viewModel.doIntent(
                      VerifyUpgradeStatusEvent(
                        subscriptionId: args.subscriptionId,
                        upgradeId: args.upgradeId,
                      ),
                    ),
                  ),
                );
              }

              return Scaffold(
                appBar: CustomAppBar(title: locale.payment_title),
                body: PaymentRedirectWebView(
                  paymentUrl: args.paymentUrl,
                  isProcessing: state.isPollingStatus,
                  onSuccessRedirect: _verifyUpgradePayment,
                  onErrorRedirect: _markPaymentFailed,
                ),
              );
            },
          ),
    );
  }

  void _verifyUpgradePayment() {
    if (_hasStartedVerification) return;
    _hasStartedVerification = true;

    final args = widget.args;
    if (args != null &&
        args.subscriptionId.isNotEmpty &&
        args.upgradeId.isNotEmpty) {
      _viewModel.doIntent(
        VerifyUpgradeStatusEvent(
          subscriptionId: args.subscriptionId,
          upgradeId: args.upgradeId,
        ),
      );
    } else {
      _viewModel.doIntent(const MarkUpgradeFailedEvent());
    }
  }

  void _markPaymentFailed() {
    if (_hasStartedVerification) return;
    _hasStartedVerification = true;
    _viewModel.doIntent(const MarkUpgradeFailedEvent());
  }
}
