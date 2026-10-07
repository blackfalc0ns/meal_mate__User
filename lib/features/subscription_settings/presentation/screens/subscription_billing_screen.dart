import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_empty_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_invoice_history_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_payment_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_pending_freeze_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_plan_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_uncompleted_subscription_card.dart';

class SubscriptionBillingScreen extends StatelessWidget {
  const SubscriptionBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionBillingViewModel>(
      create: (_) =>
          getIt<SubscriptionBillingViewModel>()
            ..doIntent(const GetSubscriptionBillingEvent()),
      child: const _SubscriptionBillingContent(),
    );
  }
}

class _SubscriptionBillingContent extends StatefulWidget {
  const _SubscriptionBillingContent();

  @override
  State<_SubscriptionBillingContent> createState() =>
      _SubscriptionBillingContentState();
}

class _SubscriptionBillingContentState
    extends State<_SubscriptionBillingContent> {
  late final SubscriptionBillingActionCoordinator _coordinator;

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
          GetCancellationQuoteEvent(subscriptionId),
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
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.profile_billing,
          titleFontSize: FontSize.size17,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<
              SubscriptionBillingViewModel,
              SubscriptionBillingState
            >(
              listenWhen: (previous, current) =>
                  previous.billingAction != current.billingAction,
              listener: (context, state) {
                _handleBillingActionState(context, state.billingAction);
              },
            ),
          ],
          child:
              BlocSelector<
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
                    final state = context
                        .read<SubscriptionBillingViewModel>()
                        .state;
                    return ApiErrorWidget(
                      exception: state.billing.failure!.exception,
                      onRetry: () => context
                          .read<SubscriptionBillingViewModel>()
                          .doIntent(const GetSubscriptionBillingEvent()),
                    );
                  }

                  return SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.screenH,
                        vertical: Spacing.md,
                      ),
                      child: Column(
                        children: [
                          // Section 1: Summary / Plan Card
                          SubscriptionBillingEntrance(
                            sectionKey: 'plan_summary',
                            delay: Duration.zero,
                            child:
                                BlocSelector<
                                  SubscriptionBillingViewModel,
                                  SubscriptionBillingState,
                                  ({
                                    SubscriptionBillingSubscriptionEntity?
                                    subscription,
                                    SubscriptionBillingFreezePolicyEntity?
                                    freezePolicy,
                                    bool hasUncompleted,
                                    bool isActionLoading,
                                  })
                                >(
                                  selector: (state) => (
                                    subscription: state
                                        .billing
                                        .data
                                        ?.current
                                        .subscription,
                                    freezePolicy:
                                        state.billing.data?.freezePolicy,
                                    hasUncompleted:
                                        state
                                            .billing
                                            .data
                                            ?.uncompletedSubscriptions
                                            .isNotEmpty ==
                                        true,
                                    isActionLoading:
                                        state.billingAction.isLoading,
                                  ),
                                  builder: (context, data) {
                                    final subscription = data.subscription;
                                    if (subscription == null) {
                                      return SubscriptionBillingEmptySubscriptionCard(
                                        hasUncompletedSubscriptions:
                                            data.hasUncompleted,
                                        onBrowseSubscriptions: () {
                                          unawaited(
                                            Navigator.of(
                                              context,
                                            ).pushNamedAndRemoveUntil(
                                              AppRoutes.home,
                                              (route) => false,
                                              arguments: 3,
                                            ),
                                          );
                                        },
                                      );
                                    }

                                    return SubscriptionBillingPlanCard(
                                      subscription: subscription,
                                      isActionLoading: data.isActionLoading,
                                      onRenew: () => _coordinator.confirmRenew(
                                        context,
                                        subscription,
                                      ),
                                      onFreeze: () =>
                                          _coordinator.confirmFreeze(
                                            context: context,
                                            subscription: subscription,
                                            freezePolicy: data.freezePolicy,
                                          ),
                                      onCancel: () =>
                                          _coordinator.onCancelQuote(
                                            subscription.subscriptionId,
                                          ),
                                    );
                                  },
                                ),
                          ),

                          // Section 2: Pending Freeze
                          BlocSelector<
                            SubscriptionBillingViewModel,
                            SubscriptionBillingState,
                            ({
                              SubscriptionBillingSubscriptionEntity?
                              subscription,
                              SubscriptionBillingPendingFreezeEntity?
                              pendingFreeze,
                              SubscriptionBillingFreezePolicyEntity?
                              freezePolicy,
                            })
                          >(
                            selector: (state) => (
                              subscription:
                                  state.billing.data?.current.subscription,
                              pendingFreeze: state
                                  .billing
                                  .data
                                  ?.current
                                  .subscription
                                  ?.pendingFreeze,
                              freezePolicy: state.billing.data?.freezePolicy,
                            ),
                            builder: (context, data) {
                              final pendingFreeze = data.pendingFreeze;
                              final subscription = data.subscription;
                              if (subscription == null ||
                                  pendingFreeze == null) {
                                return const SizedBox.shrink();
                              }

                              return SubscriptionBillingEntrance(
                                sectionKey: 'pending_freeze',
                                delay: const Duration(milliseconds: 40),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: Spacing.md,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                      Spacing.radiusMd,
                                    ),
                                    onTap: () =>
                                        _coordinator.showPendingFreezeDialog(
                                          context: context,
                                          pendingFreeze: pendingFreeze,
                                          subscription: subscription,
                                          freezePolicy: data.freezePolicy,
                                        ),
                                    child: SubscriptionBillingPendingFreezeCard(
                                      pendingFreeze: pendingFreeze,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Section 3: Unfinished Subscriptions
                          BlocSelector<
                            SubscriptionBillingViewModel,
                            SubscriptionBillingState,
                            ({
                              List<
                                SubscriptionBillingUncompletedSubscriptionEntity
                              >
                              list,
                              bool isActionLoading,
                              String? actionSubId,
                            })
                          >(
                            selector: (state) => (
                              list:
                                  state
                                      .billing
                                      .data
                                      ?.uncompletedSubscriptions ??
                                  const [],
                              isActionLoading: state.billingAction.isLoading,
                              actionSubId: state.billingAction.subscriptionId,
                            ),
                            builder: (context, data) {
                              if (data.list.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return SubscriptionBillingEntrance(
                                sectionKey: 'unfinished_subscriptions',
                                delay: const Duration(milliseconds: 80),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: Spacing.lg),
                                    Text(
                                      locale.billing_uncompleted_title,
                                      style: getSemiBoldStyle(
                                        fontFamily: FontConstant.alexandria,
                                        fontSize: FontSize.size15,
                                        color: color.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.sm),
                                    for (final item in data.list) ...[
                                      SubscriptionBillingUncompletedSubscriptionCard(
                                        subscription: item,
                                        isLoading:
                                            data.isActionLoading &&
                                            data.actionSubId ==
                                                item.subscriptionId,
                                        onDelete: () => _coordinator
                                            .confirmDeleteUncompleted(
                                              context,
                                              item,
                                            ),
                                        onResume: () =>
                                            _coordinator.onResumePreview(
                                              item.subscriptionId,
                                            ),
                                      ),
                                      const SizedBox(height: Spacing.sm),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),

                          // Section 4: Payment Method
                          BlocSelector<
                            SubscriptionBillingViewModel,
                            SubscriptionBillingState,
                            SubscriptionBillingPaymentMethodEntity?
                          >(
                            selector: (state) =>
                                state.billing.data?.paymentMethod,
                            builder: (context, paymentMethod) {
                              if (paymentMethod == null ||
                                  !paymentMethod.hasSavedMethod) {
                                return const SizedBox.shrink();
                              }

                              return SubscriptionBillingEntrance(
                                sectionKey: 'payment_method',
                                delay: const Duration(milliseconds: 120),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: Spacing.md,
                                  ),
                                  child: SubscriptionBillingPaymentCard(
                                    paymentMethod: paymentMethod,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Section 5: Invoices
                          BlocSelector<
                            SubscriptionBillingViewModel,
                            SubscriptionBillingState,
                            List<SubscriptionBillingInvoiceEntity>
                          >(
                            selector: (state) =>
                                state.billing.data?.invoices ?? const [],
                            builder: (context, invoices) {
                              return SubscriptionBillingEntrance(
                                sectionKey: 'invoice_history',
                                delay: const Duration(milliseconds: 160),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: Spacing.md,
                                  ),
                                  child: SubscriptionBillingInvoiceHistoryCard(
                                    invoices: invoices,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Section 6: Notice Banner & Manage Subscription CTA
                          BlocSelector<
                            SubscriptionBillingViewModel,
                            SubscriptionBillingState,
                            ({
                              bool hasSubscription,
                              SubscriptionBillingFreezePolicyEntity?
                              freezePolicy,
                            })
                          >(
                            selector: (state) => (
                              hasSubscription:
                                  state.billing.data?.current.subscription !=
                                  null,
                              freezePolicy: state.billing.data?.freezePolicy,
                            ),
                            builder: (context, data) {
                              if (!data.hasSubscription) {
                                return const SizedBox.shrink();
                              }

                              final isRtl =
                                  Directionality.of(context) ==
                                  TextDirection.rtl;
                              final freezeMessage = isRtl
                                  ? data.freezePolicy?.messageAr
                                  : data.freezePolicy?.messageEn;

                              return SubscriptionBillingEntrance(
                                sectionKey: 'manage_footer',
                                delay: const Duration(milliseconds: 200),
                                child: Column(
                                  children: [
                                    const SizedBox(height: Spacing.md),
                                    CustomWarningWidget(
                                      icon: Icons.info_rounded,
                                      message: (freezeMessage?.isEmpty ?? true)
                                          ? locale.billing_notice
                                          : freezeMessage!,
                                      isWarning: true,
                                      height:
                                          Spacing.profileBillingNoticeHeight,
                                      backgroundColor: color.secondary
                                          .withValues(alpha: 0.06),
                                      borderColor: color.secondary.withValues(
                                        alpha: 0.25,
                                      ),
                                      horizontalPadding: Spacing.sm,
                                      iconTextSpacing: Spacing.sm,
                                      borderRadius: Spacing.radiusMd,
                                      messageFontSize: FontSize.size11,
                                      maxMessageLines: 3,
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                    SizedBox(
                                      width: double.infinity,
                                      height:
                                          Spacing.profileBillingButtonHeight,
                                      child: AppButton(
                                        text:
                                            locale.billing_manage_subscription,
                                        onPressed: () => context.pushNamed(
                                          AppRoutes.familySubscriptionSettings,
                                        ),
                                        height:
                                            Spacing.profileBillingButtonHeight,
                                        borderRadius: Spacing.radiusPill,
                                        color: color.primary,
                                        textColor: color.onPrimary,
                                        fontSize: FontSize.size12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  void _handleBillingActionState(
    BuildContext context,
    SubscriptionBillingActionState actionState,
  ) {
    if (!context.mounted) {
      return;
    }

    final locale = context.localization;

    if (actionState.failure != null) {
      if (actionState.type == 'freeze' &&
          actionState.failure?.code == 'freeze.confirm_overwrite_selections') {
        final pendingRequest = actionState.pendingFreezeRequest;
        final pendingSubId = actionState.pendingFreezeSubscriptionId;
        if (pendingSubId != null && pendingRequest != null) {
          unawaited(
            _coordinator.handleConfirmOverwriteSelections(
              context: context,
              pendingRequest: pendingRequest,
              pendingSubscriptionId: pendingSubId,
              backendDetail: actionState.failure?.errorMessage,
            ),
          );
        }
        return;
      }

      final failureCode = actionState.failure?.code ?? '';
      final failureMessage = actionState.failure?.errorMessage ?? '';
      final rawError = failureCode.isNotEmpty
          ? failureCode
          : (failureMessage.isNotEmpty
                ? failureMessage
                : actionState.errorMessage ?? locale.billing_action_failed);

      CustomSnackbar.showError(
        context: context,
        message: mapFailureMessage(context, rawError),
      );
      _coordinator.onResetAction();
      return;
    }

    if (!actionState.isSuccess) {
      return;
    }

    switch (actionState.type) {
      case 'quote':
        final quote = actionState.cancellationQuote;
        if (quote != null) {
          unawaited(_coordinator.confirmCancel(context, quote));
        }
        break;
      case 'renew':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_renew_success,
        );
        _coordinator.onResetAction();
        break;
      case 'freeze':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_freeze_success,
        );
        _coordinator.onResetAction();
        break;
      case 'cancel':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_cancel_success,
        );
        _coordinator.onResetAction();
        break;
      case 'deleteUncompleted':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_uncompleted_delete_success,
        );
        _coordinator.onResetAction();
        break;
      case 'resumePreview':
        final preview = actionState.resumePreview;
        if (preview != null) {
          unawaited(_coordinator.handleResumePreview(context, preview));
        }
        break;
      case 'resume':
        final result = actionState.resumeResult;
        _coordinator.onResetAction();
        if (result != null && result.paymentUrl.isNotEmpty) {
          unawaited(
            context.pushNamed(
              AppRoutes.paymentWebView,
              arguments: PaymentWebViewArgs(
                checkout: PaymentCheckoutEntity(
                  subscriptionId: result.subscriptionId,
                  paymentUrl: result.paymentUrl,
                  holdExpiresAtUtc:
                      result.holdExpiresAtUtc?.toIso8601String() ?? '',
                  chosenStartDate: '',
                  startDate: '',
                  finalPrice: result.finalPrice,
                  priceSnapshotId: '',
                  restaurantPoolSnapshotId: '',
                  paymentStatus: result.paymentStatus,
                ),
              ),
            ),
          );
        }
        break;
    }
  }
}
