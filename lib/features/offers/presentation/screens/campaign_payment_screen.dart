import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/payment_redirect_web_view.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_screen_args.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/campaign_payment_header_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/campaign_pending_status_view.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_failed_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';

class CampaignPaymentScreen extends StatefulWidget {
  const CampaignPaymentScreen({super.key, this.args, this.viewModel});

  final CampaignPaymentScreenArgs? args;
  final CampaignPaymentViewModel? viewModel;

  @override
  State<CampaignPaymentScreen> createState() => _CampaignPaymentScreenState();
}

class _CampaignPaymentScreenState extends State<CampaignPaymentScreen> {
  late final CampaignPaymentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<CampaignPaymentViewModel>();

    final args = widget.args;
    if (args != null && args.sessionId.isNotEmpty) {
      if (args.callbackStatus != null && args.callbackStatus!.isNotEmpty) {
        _viewModel.doIntent(
          HandleReturnIntent(
            sessionId: args.sessionId,
            paymentId: args.paymentId,
            callbackStatus: args.callbackStatus,
          ),
        );
      } else {
        _viewModel.doIntent(StartPaymentIntent(sessionId: args.sessionId));
      }
    }
  }

  @override
  void dispose() {
    if (widget.viewModel == null) {
      unawaited(_viewModel.close());
    }
    super.dispose();
  }

  String _mapErrorCode(BuildContext context, String? code) {
    final locale = context.localization;
    return switch (code) {
      'SessionExpired' => locale.campaign_error_session_expired,
      'IdempotencyConflict' => locale.campaign_error_idempotency_conflict,
      'CapacityFull' ||
      'CapacityConflict' => locale.campaign_error_capacity_conflict,
      'SessionNotFound' || 'NotFound' => locale.campaign_error_not_found,
      'InvalidQuote' ||
      'ValidationError' => locale.campaign_error_invalid_request,
      'ProviderUnavailable' ||
      'ServiceUnavailable' => locale.campaign_error_provider_unavailable,
      _ => locale.error_other_desc,
    };
  }

  void _handleSuccess(BuildContext context, CampaignPaymentState state) {
    final args = widget.args;
    final lang = Localizations.localeOf(context).languageCode;
    final successArgs = PaymentSuccessArgs(
      subscriptionId: state.subscriptionId ?? '',
      packageName: args?.offer?.title(lang),
      durationDays: args?.offer?.minSubscriptionDays ?? 26,
      paymentDate: DateTime.now().toIso8601String().split('T').first,
    );

    unawaited(
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.paymentSuccess,
        (route) => false,
        arguments: successArgs,
      ),
    );
  }

  void _handleFailure(BuildContext context, CampaignPaymentState state) {
    final errorMessage = _mapErrorCode(context, state.serverErrorCode);

    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.paymentFailed,
        arguments: PaymentFailedArgs(
          errorMessage: errorMessage,
          onRetry: () {
            Navigator.of(context).pop();
            _viewModel.doIntent(const RetryPaymentIntent());
          },
          onChangePaymentMethod: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          onContactSupport: () {
            unawaited(
              Navigator.of(context).pushNamed(AppRoutes.profileContactUs),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final args = widget.args;

    if (args == null || args.sessionId.isEmpty) {
      return Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(title: locale.campaign_payment_title),
        body: EmptyStateWidget(
          title: locale.campaign_payment_title,
          description: locale.campaign_error_not_found,
          icon: Icons.error_outline_rounded,
        ),
      );
    }

    final lang = Localizations.localeOf(context).languageCode;
    final title = args.offer?.title(lang) ?? '';

    return BlocProvider<CampaignPaymentViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<CampaignPaymentViewModel, CampaignPaymentState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.isFailed != current.isFailed ||
            previous.isExpired != current.isExpired ||
            previous.isCancelled != current.isCancelled ||
            (previous.failure == null && current.failure != null),
        listener: (context, state) {
          if (state.isSuccess) {
            _handleSuccess(context, state);
            return;
          }

          if (state.isFailed || state.isExpired || state.isCancelled) {
            _handleFailure(context, state);
            return;
          }

          if (state.failure != null && !state.isPolling) {
            final message = _mapErrorCode(context, state.serverErrorCode);
            CustomSnackbar.showError(context: context, message: message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.campaign_payment_title,
              showBackButton: true,
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: CampaignPaymentHeaderCard(
                      title: title,
                      amount: state.amount ?? args.amount,
                      currency: state.currency,
                    ),
                  ),
                  Expanded(child: _buildBody(context, state, args.sessionId)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CampaignPaymentState state,
    String sessionId,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: color.primary),
            const SizedBox(height: Spacing.md),
            Text(
              locale.campaign_payment_redirecting,
              style: TextStyle(color: color.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (state.isPolling ||
        (state.status == CampaignPaymentStatus.pending &&
            (state.paymentUrl == null || state.paymentUrl!.isEmpty))) {
      return CampaignPendingStatusView(
        onCheckStatus: () => _viewModel.doIntent(ReadStatusIntent(sessionId)),
        pollCount: state.pollAttemptCount,
      );
    }

    if (state.paymentUrl != null && state.paymentUrl!.isNotEmpty) {
      return PaymentRedirectWebView(
        paymentUrl: state.paymentUrl!,
        isProcessing: state.isPolling,
        processingMessage: locale.campaign_payment_verifying,
        onPaymentReturn: (paymentReturn) {
          _viewModel.doIntent(
            HandleReturnIntent(
              sessionId: sessionId,
              paymentId: paymentReturn.paymentId,
              callbackStatus: paymentReturn.callbackStatus,
            ),
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payment_rounded, size: 48, color: color.primary),
          const SizedBox(height: Spacing.md),
          ElevatedButton(
            onPressed: () =>
                _viewModel.doIntent(StartPaymentIntent(sessionId: sessionId)),
            child: Text(locale.campaign_payment_pay_now),
          ),
        ],
      ),
    );
  }
}
