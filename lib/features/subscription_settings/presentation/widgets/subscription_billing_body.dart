import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_invoices_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_management_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_payment_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_pending_freeze_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_plan_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_uncompleted_section.dart';

class SubscriptionBillingBody extends StatelessWidget {
  const SubscriptionBillingBody({required this.coordinator, super.key});

  final SubscriptionBillingActionCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SubscriptionBillingViewModel,
      SubscriptionBillingState,
      ({bool isLoading, Object? failure, bool hasData})
    >(
      selector: (state) => (
        isLoading: state.billing.isLoading,
        failure: state.billing.failure,
        hasData: state.billing.data != null,
      ),
      builder: (context, rootState) {
        if (rootState.isLoading && !rootState.hasData) {
          return const SubscriptionBillingLoadingSkeleton();
        }

        if (rootState.failure != null && !rootState.hasData) {
          final failure = rootState.failure;
          final exception = failure is Failure
              ? failure.exception
              : ApiException(
                  errorType: ApiErrorType.unknown,
                  message: failure?.toString() ?? '',
                );

          return Center(
            child: ApiErrorWidget(
              exception: exception,
              onRetry: () {
                context.read<SubscriptionBillingViewModel>().doIntent(
                  const GetSubscriptionBillingEvent(),
                );
              },
            ),
          );
        }

        return SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              final vm = context.read<SubscriptionBillingViewModel>();
              final completer = Completer<void>();
              late final StreamSubscription sub;
              sub = vm.stream.listen((nextState) {
                if (!nextState.billing.isLoading) {
                  if (!completer.isCompleted) {
                    completer.complete();
                  }
                  unawaited(sub.cancel());
                }
              });
              vm.doIntent(const GetSubscriptionBillingEvent());
              await completer.future.timeout(
                const Duration(seconds: 10),
                onTimeout: () {
                  unawaited(sub.cancel());
                },
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
                vertical: Spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SubscriptionBillingPlanSection(coordinator: coordinator),
                  SubscriptionBillingPendingFreezeSection(
                    coordinator: coordinator,
                  ),
                  SubscriptionBillingUncompletedSection(
                    coordinator: coordinator,
                  ),
                  const SubscriptionBillingPaymentSection(),
                  const SubscriptionBillingInvoicesSection(),
                  const SubscriptionBillingManagementSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
