import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_body.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance_registry.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';

class SubscriptionBillingContent extends StatefulWidget {
  const SubscriptionBillingContent({super.key});

  @override
  State<SubscriptionBillingContent> createState() =>
      _SubscriptionBillingContentState();
}

class _SubscriptionBillingContentState
    extends State<SubscriptionBillingContent> {
  late final SubscriptionBillingActionCoordinator _coordinator;
  final Set<String> _playedSectionKeys = <String>{};

  @override
  void initState() {
    super.initState();
    _coordinator = SubscriptionBillingActionCoordinator(
      onRenew: (subscriptionId) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          RenewSubscriptionEvent(subscriptionId),
        );
      },
      onFreeze: (subscriptionId, request) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          FreezeSubscriptionEvent(
            subscriptionId: subscriptionId,
            request: request,
          ),
        );
      },
      onCancelQuote: (subscriptionId) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          GetSubscriptionCancellationQuoteEvent(subscriptionId),
        );
      },
      onCancel: (subscriptionId, request) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          CancelSubscriptionEvent(
            subscriptionId: subscriptionId,
            request: request,
          ),
        );
      },
      onResetAction: () {
        context.read<SubscriptionBillingViewModel>().doIntent(
          const ResetSubscriptionBillingActionEvent(),
        );
      },
      onDeleteUncompleted: (subscriptionId) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          DeleteUncompletedSubscriptionEvent(subscriptionId),
        );
      },
      onResumePreview: (subscriptionId) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          GetSubscriptionResumePreviewEvent(subscriptionId),
        );
      },
      onResumeFamily: (item) {
        final next = item.actions.nextScreen?.toLowerCase();
        final route =
            next == 'family_payment' ||
                item.status.toLowerCase() == 'checkoutpending'
            ? AppRoutes.familyPaymentSetup
            : AppRoutes.familySubscriptionSetup;
        context.pushNamed(route);
      },
      onResume: (subscriptionId, [startDate]) {
        context.read<SubscriptionBillingViewModel>().doIntent(
          ResumeSubscriptionEvent(
            subscriptionId: subscriptionId,
            startDate: startDate,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SubscriptionBillingEntranceRegistry(
      playedKeys: _playedSectionKeys,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.profile_billing,
          titleFontSize: FontSize.size17,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body:
            BlocListener<
              SubscriptionBillingViewModel,
              SubscriptionBillingState
            >(
              listenWhen: (previous, current) =>
                  previous.billingAction != current.billingAction,
              listener: (context, state) {
                _coordinator.handleActionState(context, state.billingAction);
              },
              child: SubscriptionBillingBody(coordinator: _coordinator),
            ),
      ),
    );
  }
}
