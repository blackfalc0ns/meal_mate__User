import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_freeze_rules_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_pending_freeze_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_invoice_history_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_loading_skeleton.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_payment_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_plan_card.dart';

class ProfileBillingScreen extends StatelessWidget {
  const ProfileBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<ProfileViewModel>(
      create: (_) =>
          getIt<ProfileViewModel>()..doIntent(const GetProfileBillingEvent()),
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.profile_billing,
          titleFontSize: FontSize.size17,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocConsumer<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
              previous.billingAction != current.billingAction,
          listener: (context, state) {
            _handleBillingActionState(context, state.billingAction);
          },
          buildWhen: (previous, current) =>
              previous.billing != current.billing ||
              previous.billingAction.isLoading !=
                  current.billingAction.isLoading,
          builder: (context, state) {
            final billingState = state.billing;
            final billing = billingState.data;

            if (billingState.isLoading && billing == null) {
              return const ProfileBillingLoadingSkeleton();
            }

            if (billingState.failure != null && billing == null) {
              return ApiErrorWidget(
                exception: billingState.failure!.exception,
                onRetry: () => context.read<ProfileViewModel>().doIntent(
                  const GetProfileBillingEvent(),
                ),
              );
            }

            final subscription = billing?.current.subscription;
            final paymentMethod = billing?.paymentMethod;
            final freezePolicy = billing?.freezePolicy;
            final isRtl = Directionality.of(context) == TextDirection.rtl;
            final freezeMessage = isRtl
                ? freezePolicy?.messageAr
                : freezePolicy?.messageEn;

            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                  vertical: Spacing.md,
                ),
                child: Column(
                  children: [
                    if (subscription == null)
                      EmptyStateWidget(
                        title: locale.billing_no_subscription_title,
                        description: locale.billing_no_subscription_description,
                        icon: Icons.receipt_long_rounded,
                      )
                    else
                      ProfileBillingPlanCard(
                        subscription: subscription,
                        isActionLoading: state.billingAction.isLoading,
                        onRenew: () => _confirmRenew(context, subscription),
                        onFreeze: () =>
                            _confirmFreeze(context, subscription, freezePolicy),
                        onCancel: () =>
                            context.read<ProfileViewModel>().doIntent(
                              GetCancellationQuoteEvent(
                                subscription.subscriptionId,
                              ),
                            ),
                      ),
                    if (subscription != null &&
                        subscription.pendingFreeze != null) ...[
                      const SizedBox(height: Spacing.md),
                      InkWell(
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        onTap: () => _showPendingFreezeDialog(
                          context,
                          subscription.pendingFreeze!,
                          subscription,
                          freezePolicy,
                        ),
                        child: ProfileBillingPendingFreezeCard(
                          pendingFreeze: subscription.pendingFreeze!,
                        ),
                      ),
                    ],
                    if (subscription?.pendingUpgrade != null) ...[
                      const SizedBox(height: Spacing.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: color.inverseSurface,
                          borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        ),
                        child: Text(
                          locale.billing_pending_upgrade_notice,
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onInverseSurface,
                          ),
                        ),
                      ),
                    ],
                    if (paymentMethod != null &&
                        paymentMethod.hasSavedMethod) ...[
                      const SizedBox(height: Spacing.md),
                      ProfileBillingPaymentCard(paymentMethod: paymentMethod),
                    ],
                    const SizedBox(height: Spacing.md),
                    ProfileBillingInvoiceHistoryCard(
                      invoices: billing?.invoices ?? const [],
                    ),
                    const SizedBox(height: Spacing.md),
                    CustomWarningWidget(
                      icon: Icons.info_rounded,
                      message: freezeMessage?.isEmpty ?? true
                          ? locale.billing_notice
                          : freezeMessage!,
                      isWarning: true,
                      height: Spacing.profileBillingNoticeHeight,
                      backgroundColor: color.secondary.withValues(alpha: 0.06),
                      borderColor: color.secondary.withValues(alpha: 0.25),
                      horizontalPadding: Spacing.sm,
                      iconTextSpacing: Spacing.sm,
                      borderRadius: Spacing.radiusMd,
                      messageFontSize: FontSize.size11,
                      maxMessageLines: 3,
                    ),
                    const SizedBox(height: Spacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: Spacing.profileBillingButtonHeight,
                      child: AppButton(
                        text: locale.billing_manage_subscription,
                        onPressed: subscription == null
                            ? null
                            : () => context.pushNamed(
                                AppRoutes.familySubscriptionSettings,
                              ),
                        height: Spacing.profileBillingButtonHeight,
                        borderRadius: Spacing.radiusPill,
                        color: color.primary,
                        textColor: color.onPrimary,
                        fontSize: FontSize.size12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmRenew(
    BuildContext context,
    ProfileBillingSubscriptionEntity subscription,
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

    context.read<ProfileViewModel>().doIntent(
      RenewSubscriptionEvent(subscription.subscriptionId),
    );
  }

  Future<void> _confirmFreeze(
    BuildContext context,
    ProfileBillingSubscriptionEntity subscription,
    ProfileBillingFreezePolicyEntity? freezePolicy,
  ) async {
    final pendingFreeze = subscription.pendingFreeze;
    if (pendingFreeze != null) {
      await _showPendingFreezeDialog(
        context,
        pendingFreeze,
        subscription,
        freezePolicy,
      );
      return;
    }

    final locale = context.localization;
    final firstDate = ProfileBillingFreezeDatePolicy.minimumStartDate(
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

    final freezeDays = pickedRange.end.difference(pickedRange.start).inDays + 1;
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
            ProfileBillingFreezeRulesCard(policy: freezePolicy),
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
          _BillingReasonInputField(
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
    context.read<ProfileViewModel>().doIntent(
      FreezeSubscriptionEvent(
        subscriptionId: subscription.subscriptionId,
        request: ProfileBillingFreezeRequestEntity(
          startDate: _formatApiDate(pickedRange.start),
          endDate: _formatApiDate(pickedRange.end),
          reason: reason.isEmpty ? null : reason,
          acknowledgeLostSelections: false,
        ),
      ),
    );
  }

  Future<void> _showPendingFreezeDialog(
    BuildContext context,
    ProfileBillingPendingFreezeEntity pendingFreeze,
    ProfileBillingSubscriptionEntity subscription,
    ProfileBillingFreezePolicyEntity? freezePolicy,
  ) async {
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
      content: ProfileBillingPendingFreezeCard(
        pendingFreeze: pendingFreeze,
        notice: notice.isNotEmpty ? notice : null,
      ),
      onConfirm: () {},
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    ProfileBillingCancellationQuoteEntity quote,
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
          _BillingReasonInputField(
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
      context.read<ProfileViewModel>().doIntent(
        const ResetBillingActionEvent(),
      );
      return;
    }

    final reason = reasonText.trim();
    context.read<ProfileViewModel>().doIntent(
      CancelSubscriptionEvent(
        subscriptionId: quote.subscriptionId,
        request: ProfileBillingCancellationRequestEntity(
          reason: reason.isEmpty ? null : reason,
        ),
      ),
    );
  }

  void _handleBillingActionState(
    BuildContext context,
    ProfileBillingActionState actionState,
  ) {
    if (!context.mounted) {
      return;
    }

    final locale = context.localization;

    if (actionState.failure != null) {
      if (actionState.type == 'freeze' &&
          actionState.failure?.code == 'freeze.confirm_overwrite_selections') {
        _handleConfirmOverwriteSelections(context, actionState);
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
      return;
    }

    if (!actionState.isSuccess) {
      return;
    }

    switch (actionState.type) {
      case 'quote':
        final quote = actionState.cancellationQuote;
        if (quote != null) {
          _confirmCancel(context, quote);
        }
        break;
      case 'renew':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_renew_success,
        );
        break;
      case 'freeze':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_freeze_success,
        );
        break;
      case 'cancel':
        CustomSnackbar.showSuccess(
          context: context,
          message: locale.billing_cancel_success,
        );
        break;
    }
  }

  Future<void> _handleConfirmOverwriteSelections(
    BuildContext context,
    ProfileBillingActionState actionState,
  ) async {
    final locale = context.localization;
    final color = context.colorScheme;
    final backendDetail = actionState.failure?.errorMessage;
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
      context.read<ProfileViewModel>().doIntent(
        const ResetBillingActionEvent(),
      );
      return;
    }

    final pendingRequest = actionState.pendingFreezeRequest;
    final pendingSubId = actionState.pendingFreezeSubscriptionId;
    if (pendingSubId != null && pendingRequest != null) {
      context.read<ProfileViewModel>().doIntent(
        FreezeSubscriptionEvent(
          subscriptionId: pendingSubId,
          request: ProfileBillingFreezeRequestEntity(
            startDate: pendingRequest.startDate,
            endDate: pendingRequest.endDate,
            reason: pendingRequest.reason,
            acknowledgeLostSelections: true,
          ),
        ),
      );
    }
  }

  String _formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class _BillingReasonInputField extends StatefulWidget {
  const _BillingReasonInputField({
    required this.labelText,
    required this.onChanged,
  });

  final String labelText;
  final ValueChanged<String> onChanged;

  @override
  State<_BillingReasonInputField> createState() =>
      _BillingReasonInputFieldState();
}

class _BillingReasonInputFieldState extends State<_BillingReasonInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.labelText),
      maxLines: 2,
      onChanged: widget.onChanged,
    );
  }
}
