import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_summary_content.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_summary_loading_skeleton.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_home_action.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

class FamilySummaryScreen extends StatefulWidget {
  const FamilySummaryScreen({super.key});

  @override
  State<FamilySummaryScreen> createState() => _FamilySummaryScreenState();
}

class _FamilySummaryScreenState extends State<FamilySummaryScreen> {
  PaymentCheckoutEntity? _lastHandledCheckoutResult;
  Failure? _lastHandledFailure;

  bool _listenWhen(FamilySummaryState previous, FamilySummaryState current) {
    if (current.checkoutResult == null && previous.checkoutResult != null) {
      _lastHandledCheckoutResult = null;
    }
    if (current.failure == null && previous.failure != null) {
      _lastHandledFailure = null;
    }
    final hasNewCheckoutResult =
        current.checkoutResult != null &&
        current.checkoutResult != _lastHandledCheckoutResult &&
        previous.checkoutResult != current.checkoutResult;
    final hasNewFailure =
        current.failure != null &&
        current.failure != _lastHandledFailure &&
        previous.failure != current.failure;
    return hasNewCheckoutResult || hasNewFailure;
  }

  bool _buildWhen(FamilySummaryState previous, FamilySummaryState current) {
    final prevSkeleton = previous.isSummaryLoading && previous.summary == null;
    final currSkeleton = current.isSummaryLoading && current.summary == null;
    final prevError = previous.failure != null && previous.summary == null;
    final currError = current.failure != null && current.summary == null;
    final prevOverlay = previous.isCheckoutLoading || previous.isRetryLoading;
    final currOverlay = current.isCheckoutLoading || current.isRetryLoading;
    final summaryTransition =
        previous.summary == null && current.summary != null;
    final flowTransition = previous.currentFlow != current.currentFlow;
    final activeMemberChanged =
        previous.activeMemberId != current.activeMemberId;
    final summaryRefreshed = previous.summary != current.summary;

    return prevSkeleton != currSkeleton ||
        prevError != currError ||
        prevOverlay != currOverlay ||
        summaryTransition ||
        summaryRefreshed ||
        flowTransition ||
        activeMemberChanged;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider<FamilySummaryViewModel>(
      create: (_) => getIt<FamilySummaryViewModel>()
        ..doIntent(const GetFamilySubscriptionCurrentEvent())
        ..doIntent(
          GetFamilySummaryEvent(
            memberId: FamilyFlowScope.targetMemberIdOf(context),
          ),
        ),
      child: isInFamilyFlow
          ? BlocConsumer<FamilySummaryViewModel, FamilySummaryState>(
              listenWhen: _listenWhen,
              buildWhen: _buildWhen,
              listener: _onStateChanged,
              builder: _buildContent,
            )
          : Scaffold(
              appBar: CustomAppBar(
                showBackButton: true,
                titleWidget: Column(
                  children: [
                    Text(
                      locale.family_setup_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_setup_subtitle,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                actions: const [FamilyFlowHomeAction()],
              ),
              body: SafeArea(
                child: BlocConsumer<FamilySummaryViewModel, FamilySummaryState>(
                  listenWhen: _listenWhen,
                  buildWhen: _buildWhen,
                  listener: _onStateChanged,
                  builder: _buildContent,
                ),
              ),
            ),
    );
  }

  void _onStateChanged(BuildContext context, FamilySummaryState state) {
    if (state.checkoutResult != null &&
        state.checkoutResult != _lastHandledCheckoutResult) {
      _lastHandledCheckoutResult = state.checkoutResult;
      unawaited(
        Navigator.of(context, rootNavigator: true)
            .pushNamed(
              AppRoutes.paymentWebView,
              arguments: PaymentWebViewArgs(
                checkout: state.checkoutResult!,
                flowType: 'family',
                batchId: state.summary?.batchId,
                batchVersion: state.summary?.batchVersion,
              ),
            )
            .then((_) {
              if (context.mounted) {
                final activeMemberId = context
                    .read<FamilySummaryViewModel>()
                    .state
                    .activeMemberId;
                context.read<FamilySummaryViewModel>().doIntent(
                  const GetFamilySubscriptionCurrentEvent(),
                );
                context.read<FamilySummaryViewModel>().doIntent(
                  GetFamilySummaryEvent(memberId: activeMemberId),
                );
              }
            }),
      );
      return;
    }

    if (state.failure != null &&
        state.failure != _lastHandledFailure &&
        !state.isCheckoutLoading &&
        !state.isRetryLoading &&
        state.checkoutResult == null) {
      _lastHandledFailure = state.failure;
      CustomSnackbar.showError(
        context: context,
        message: ErrorMessagePresenter.fromFailure(context, state.failure!),
      );
    }
  }

  Widget _buildContent(BuildContext context, FamilySummaryState state) {
    if (state.isSummaryLoading && state.summary == null) {
      return const FamilySummaryLoadingSkeleton();
    }

    if (state.failure != null && state.summary == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<FamilySummaryViewModel>().doIntent(
          const GetFamilySummaryEvent(),
        ),
      );
    }

    return Stack(
      children: [
        FamilySummaryContent(state: state)
            .animate(key: const ValueKey('family-payment-content'))
            .fadeIn(duration: 250.ms),
        Positioned.fill(
          child: BlocBuilder<FamilySummaryViewModel, FamilySummaryState>(
            buildWhen: (previous, current) =>
                previous.isStartDateSaving != current.isStartDateSaving,
            builder: (context, current) => current.isStartDateSaving
                ? AbsorbPointer(
                    child: ColoredBox(
                      color: context.colorScheme.scrim.withValues(alpha: 0.32),
                      child: const Center(child: CustomProgressIndicator()),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        if (state.isCheckoutLoading || state.isRetryLoading)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: context.colorScheme.scrim.withValues(alpha: 0.32),
                child: const Center(child: CustomProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }
}

typedef FamilyPaymentSetupScreen = FamilySummaryScreen;
