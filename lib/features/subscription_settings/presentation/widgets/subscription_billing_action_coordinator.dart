import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_action_type.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_active_freeze_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_freeze_rules_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_pending_freeze_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_reason_input_field.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_freeze_notice_sheet.dart';

class SubscriptionBillingActionCoordinator {
  SubscriptionBillingActionCoordinator({
    required this.onRenew,
    required this.onFreeze,
    required this.onCancelQuote,
    required this.onCancel,
    required this.onResetAction,
    required this.onDeleteUncompleted,
    required this.onResumePreview,
    required this.onResumeFamily,
    required this.onResume,
  });

  final void Function(String subscriptionId) onRenew;
  final void Function(
    String subscriptionId,
    SubscriptionBillingFreezeRequestEntity request,
  )
  onFreeze;
  final void Function(String subscriptionId) onCancelQuote;
  final void Function(
    String subscriptionId,
    SubscriptionBillingCancellationRequestEntity request,
  )
  onCancel;
  final VoidCallback onResetAction;
  final void Function(String subscriptionId) onDeleteUncompleted;
  final void Function(String subscriptionId) onResumePreview;
  final void Function(SubscriptionBillingUncompletedSubscriptionEntity)
  onResumeFamily;
  final void Function(String subscriptionId, [String? startDate]) onResume;

  bool _isFreezeFlowOpen = false;
  bool get isFreezeFlowOpen => _isFreezeFlowOpen;

  Future<void> confirmRenew(
    BuildContext context,
    SubscriptionBillingSubscriptionEntity subscription,
  ) async {
    final locale = context.localization;
    final confirmed = await context.showAppCustomDialog<bool>(
      title: locale.billing_renew_confirm_title,
      message: locale.billing_renew_confirm_message,
      cancelText: locale.billing_dismiss,
      confirmText: locale.billing_confirm,
      icon: Icons.autorenew_rounded,
      onCancel: () => false,
      onConfirm: () => true,
    );

    if (!context.mounted || confirmed != true) {
      return;
    }

    onRenew(subscription.subscriptionId);
  }

  Future<void> confirmFreeze({
    required BuildContext context,
    required SubscriptionBillingSubscriptionEntity subscription,
    SubscriptionBillingFreezePolicyEntity? freezePolicy,
  }) async {
    if (_isFreezeFlowOpen) {
      return;
    }
    _isFreezeFlowOpen = true;

    try {
      final activeFreeze = subscription.activeFreeze;
      if (activeFreeze != null) {
        await showActiveFreezeDialog(context, activeFreeze);
        return;
      }

      final pendingFreeze = subscription.pendingFreeze;
      if (pendingFreeze != null) {
        await showPendingFreezeDialog(
          context: context,
          pendingFreeze: pendingFreeze,
          subscription: subscription,
          freezePolicy: freezePolicy,
        );
        return;
      }

      if (!context.mounted) return;

      final locale = context.localization;
      final isArabic = locale.localeName == 'ar';

      String? resolvedNotice;
      final serverNotice = isArabic
          ? (subscription.actions.freezeNoticeAr?.trim().isNotEmpty == true
                ? subscription.actions.freezeNoticeAr!.trim()
                : subscription.actions.freezeNotice?.trim())
          : (subscription.actions.freezeNotice?.trim().isNotEmpty == true
                ? subscription.actions.freezeNotice!.trim()
                : subscription.actions.freezeNoticeAr?.trim());

      if (serverNotice != null && serverNotice.isNotEmpty) {
        resolvedNotice = serverNotice;
      } else {
        final policyNotice = isArabic
            ? (freezePolicy?.noticeAr.trim().isNotEmpty == true
                  ? freezePolicy!.noticeAr.trim()
                  : freezePolicy?.messageAr.trim())
            : (freezePolicy?.notice.trim().isNotEmpty == true
                  ? freezePolicy!.notice.trim()
                  : freezePolicy?.messageEn.trim());
        if (policyNotice != null && policyNotice.isNotEmpty) {
          resolvedNotice = policyNotice;
        }
      }

      if (resolvedNotice == null || resolvedNotice.isEmpty) {
        resolvedNotice = locale.billing_notice;
      }

      final accepted = await requestFreezeConsent(context, resolvedNotice);
      if (!context.mounted || !accepted) {
        return;
      }

      final firstDate = SubscriptionBillingFreezeDatePolicy.minimumStartDate(
        now: DateTime.now(),
        freezeStartDelayDays: subscription.actions.freezeStartDelayDays,
        earliestFreezeStartDate: subscription.actions.earliestFreezeStartDate,
      );

      final pickedRange = await context.showAppDateRangePicker(
        title: locale.billing_pick_freeze_dates,
        cancelText: locale.billing_dismiss,
        confirmText: locale.billing_confirm,
        firstDate: firstDate,
        lastDate: firstDate.add(const Duration(days: 365)),
      );

      if (!context.mounted || pickedRange == null) {
        return;
      }

      final freezeDays =
          pickedRange.end.difference(pickedRange.start).inDays + 1;
      if (freezeDays > subscription.actions.maximumFreezeDays) {
        CustomSnackbar.showWarning(
          context: context,
          message: locale.billing_freeze_range_too_long(
            subscription.actions.maximumFreezeDays,
          ),
        );
        return;
      }

      String reasonText = '';
      final color = context.colorScheme;
      final dateFormatter = intl.DateFormat.yMd(locale.localeName);
      final confirmed = await context.showAppCustomDialog<bool>(
        title: locale.billing_freeze_confirm_title,
        message: locale.billing_freeze_confirm_message,
        cancelText: locale.billing_dismiss,
        confirmText: locale.billing_confirm,
        icon: Icons.ac_unit_rounded,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (freezePolicy != null) ...[
              SubscriptionBillingFreezeRulesCard(policy: freezePolicy),
              const SizedBox(height: Spacing.md),
            ],
            Text(
              locale.billing_selected_freeze_dates(
                dateFormatter.format(pickedRange.start),
                dateFormatter.format(pickedRange.end),
              ),
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SubscriptionBillingReasonInputField(
              labelText: locale.billing_optional_reason,
              onChanged: (value) => reasonText = value,
            ),
          ],
        ),
        onCancel: () => false,
        onConfirm: () => true,
      );

      if (!context.mounted || confirmed != true) {
        return;
      }

      final reason = reasonText.trim();
      onFreeze(
        subscription.subscriptionId,
        SubscriptionBillingFreezeRequestEntity(
          startDate: formatApiDate(pickedRange.start),
          endDate: formatApiDate(pickedRange.end),
          reason: reason.isEmpty ? null : reason,
          acknowledgeLostSelections: false,
        ),
      );
    } finally {
      _isFreezeFlowOpen = false;
    }
  }

  Future<void> showActiveFreezeDialog(
    BuildContext context,
    SubscriptionBillingActiveFreezeEntity activeFreeze,
  ) async {
    final locale = context.localization;

    await context.showAppCustomDialog<void>(
      title: locale.billing_pending_freeze_title,
      message: locale.billing_pending_freeze_message,
      confirmText: locale.billing_dismiss,
      icon: Icons.ac_unit_rounded,
      content: SubscriptionBillingActiveFreezeCard(activeFreeze: activeFreeze),
      onConfirm: () {},
    );
  }

  Future<void> showPendingFreezeDialog({
    required BuildContext context,
    required SubscriptionBillingPendingFreezeEntity pendingFreeze,
    required SubscriptionBillingSubscriptionEntity subscription,
    SubscriptionBillingFreezePolicyEntity? freezePolicy,
  }) async {
    final locale = context.localization;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final notice = isRtl
        ? (freezePolicy?.noticeAr.isNotEmpty == true
              ? freezePolicy!.noticeAr
              : freezePolicy?.notice ?? '')
        : (freezePolicy?.notice.isNotEmpty == true
              ? freezePolicy!.notice
              : freezePolicy?.noticeAr ?? '');

    await context.showAppCustomDialog<void>(
      title: locale.billing_pending_freeze_title,
      message: locale.billing_pending_freeze_message,
      confirmText: locale.billing_dismiss,
      icon: Icons.ac_unit_rounded,
      content: SubscriptionBillingPendingFreezeCard(
        pendingFreeze: pendingFreeze,
        notice: notice.isNotEmpty ? notice : null,
      ),
      onConfirm: () {},
    );
  }

  Future<void> confirmCancel(
    BuildContext context,
    SubscriptionBillingCancellationQuoteEntity quote,
  ) async {
    final locale = context.localization;
    String reasonText = '';
    final color = context.colorScheme;
    final confirmed = await context.showAppCustomDialog<bool>(
      title: locale.billing_cancel_quote_title,
      message: locale.billing_cancel_quote_message(
        quote.refundableDays,
        quote.refundAmount.toStringAsFixed(3),
        quote.currencyCode,
      ),
      cancelText: locale.billing_dismiss,
      confirmText: locale.billing_confirm,
      icon: Icons.cancel_outlined,
      iconColor: color.error,
      confirmTextColor: color.error,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (quote.policyMessageAr.isNotEmpty) ...[
            Text(
              quote.policyMessageAr,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.sm),
          ],
          SubscriptionBillingReasonInputField(
            labelText: locale.billing_optional_reason,
            onChanged: (value) => reasonText = value,
          ),
        ],
      ),
      onCancel: () => false,
      onConfirm: () => true,
    );

    if (!context.mounted) {
      return;
    }

    if (confirmed != true) {
      onResetAction();
      return;
    }

    final reason = reasonText.trim();
    onCancel(
      quote.subscriptionId,
      SubscriptionBillingCancellationRequestEntity(
        reason: reason.isEmpty ? null : reason,
      ),
    );
  }

  Future<void> confirmDeleteUncompleted(
    BuildContext context,
    SubscriptionBillingUncompletedSubscriptionEntity subscription,
  ) async {
    final locale = context.localization;
    final color = context.colorScheme;
    final confirmed = await context.showAppCustomDialog<bool>(
      title: locale.billing_uncompleted_delete_title,
      message: locale.billing_uncompleted_delete_message,
      cancelText: locale.billing_dismiss,
      confirmText: locale.billing_uncompleted_delete,
      icon: Icons.delete_outline_rounded,
      iconColor: color.error,
      confirmTextColor: color.error,
      onCancel: () => false,
      onConfirm: () => true,
    );
    if (!context.mounted || confirmed != true) {
      return;
    }
    onDeleteUncompleted(subscription.subscriptionId);
  }

  Future<void> handleResumePreview(
    BuildContext context,
    SubscriptionBillingResumePreviewEntity preview,
  ) async {
    if (preview.canPayDirectly) {
      onResume(preview.subscriptionId);
      return;
    }

    final locale = context.localization;
    final confirmed = await context.showAppCustomDialog<bool>(
      title: locale.billing_uncompleted_resume_title,
      message:
          '${locale.billing_uncompleted_resume_message}\n'
          '${preview.suggestedStartDate}',
      cancelText: locale.billing_dismiss,
      confirmText: locale.billing_confirm,
      icon: Icons.event_available_rounded,
      onCancel: () => false,
      onConfirm: () => true,
    );
    if (!context.mounted || confirmed != true) {
      return;
    }
    onResume(preview.subscriptionId, preview.suggestedStartDate);
  }

  Future<void> handleConfirmOverwriteSelections({
    required BuildContext context,
    required SubscriptionBillingFreezeRequestEntity pendingRequest,
    required String pendingSubscriptionId,
    String? backendDetail,
  }) async {
    final locale = context.localization;
    final color = context.colorScheme;
    final message =
        (backendDetail != null &&
            backendDetail.trim().isNotEmpty &&
            backendDetail != 'freeze.confirm_overwrite_selections')
        ? backendDetail.trim()
        : locale.billing_confirm_overwrite_selections_message;

    final confirmed = await context.showAppCustomDialog<bool>(
      title: locale.billing_confirm_overwrite_selections_title,
      message: message,
      cancelText: locale.billing_dismiss,
      confirmText: locale.billing_confirm,
      icon: Icons.warning_amber_rounded,
      iconColor: color.error,
      confirmTextColor: color.error,
      onCancel: () => false,
      onConfirm: () => true,
    );

    if (!context.mounted) {
      return;
    }

    if (confirmed != true) {
      onResetAction();
      return;
    }

    onFreeze(
      pendingSubscriptionId,
      SubscriptionBillingFreezeRequestEntity(
        startDate: pendingRequest.startDate,
        endDate: pendingRequest.endDate,
        reason: pendingRequest.reason,
        acknowledgeLostSelections: true,
      ),
    );
  }

  static String formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void handleActionState(
    BuildContext context,
    SubscriptionBillingActionState actionState,
  ) {
    if (!context.mounted) {
      return;
    }

    final locale = context.localization;

    if (actionState.failure != null) {
      if (actionState.type == SubscriptionBillingActionType.freeze &&
          actionState.failure?.code == 'freeze.confirm_overwrite_selections') {
        final pendingRequest = actionState.pendingFreezeRequest;
        final pendingSubId = actionState.pendingFreezeSubscriptionId;
        if (pendingSubId != null && pendingRequest != null) {
          unawaited(
            handleConfirmOverwriteSelections(
              context: context,
              pendingRequest: pendingRequest,
              pendingSubscriptionId: pendingSubId,
              backendDetail: actionState.failure?.errorMessage,
            ),
          );
        }
        return;
      }

      final failure = actionState.failure;
      if (failure != null) {
        CustomSnackbar.showError(
          context: context,
          message: ErrorMessagePresenter.fromFailure(context, failure),
        );
        onResetAction();
        return;
      }
    }

    if (!actionState.isSuccess) {
      return;
    }

    switch (actionState.type) {
      case SubscriptionBillingActionType.quote:
        final quote = actionState.cancellationQuote;
        if (quote != null) {
          unawaited(confirmCancel(context, quote));
        }
        break;
      case SubscriptionBillingActionType.renew:
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_renew_success,
        );
        onResetAction();
        break;
      case SubscriptionBillingActionType.freeze:
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_freeze_success,
        );
        onResetAction();
        break;
      case SubscriptionBillingActionType.cancel:
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_cancel_success,
        );
        onResetAction();
        break;
      case SubscriptionBillingActionType.deleteUncompleted:
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_uncompleted_delete_success,
        );
        onResetAction();
        break;
      case SubscriptionBillingActionType.resumePreview:
        final preview = actionState.resumePreview;
        if (preview != null) {
          unawaited(handleResumePreview(context, preview));
        }
        break;
      case SubscriptionBillingActionType.resume:
        final result = actionState.resumeResult;
        onResetAction();
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
      case null:
        break;
    }
  }
}
