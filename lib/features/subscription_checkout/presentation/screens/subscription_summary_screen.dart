import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/services/promo_code_session.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/sections/subscription_summary_bottom_bar_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/sections/subscription_summary_content_sliver_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/sections/subscription_summary_hero_sliver_section.dart';

/// Subscription Checkout Summary screen refactored into modular sliver sections.
class SubscriptionSummaryScreen extends StatelessWidget {
  const SubscriptionSummaryScreen({super.key, required this.args});

  final SubscriptionSummaryArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final summaryArgs = args;

    if (summaryArgs == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.subscription_summary_title,
          description: locale.subscription_summary_title,
          icon: Icons.receipt_long_rounded,
        ),
      );
    }
    final initialStartDate = summaryArgs.request.startDate.trim().isNotEmpty
        ? summaryArgs.request.startDate.trim()
        : '';

    final savedPromoCode = PromoCodeSession.activePromoCode;
    final promoCode =
        (summaryArgs.request.promoCode?.trim().isNotEmpty == true)
            ? summaryArgs.request.promoCode
            : savedPromoCode;

    final initialRequest = summaryArgs.request.copyWith(
      startDate: initialStartDate,
      promoCode: promoCode,
    );

    return BlocProvider<SubscriptionSummaryViewModel>(
      create: (_) =>
          getIt<SubscriptionSummaryViewModel>()
            ..doIntent(GetSubscriptionSummaryEvent(initialRequest)),
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SubscriptionSummaryHeroSliverSection(summaryArgs: summaryArgs),
                SubscriptionSummaryContentSliverSection(
                  summaryArgs: summaryArgs,
                  initialStartDate: initialStartDate,
                ),
              ],
            ),
            SubscriptionSummaryBottomBarSection(
              summaryArgs: summaryArgs,
              initialStartDate: initialStartDate,
            ),
            Positioned.fill(
              child:
                  BlocBuilder<
                    SubscriptionSummaryViewModel,
                    SubscriptionSummaryState
                  >(
                    buildWhen: (previous, current) =>
                        previous.isSummaryRefreshing !=
                        current.isSummaryRefreshing,
                    builder: (context, current) => current.isSummaryRefreshing
                        ? const AbsorbPointer(
                            child: Center(child: CustomProgressIndicator()),
                          )
                        : const SizedBox.shrink(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
