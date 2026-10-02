import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/widget/app_date_picker.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_loading_skeleton.dart';

/// Middle content sliver section of the subscription checkout summary screen.
class SubscriptionSummaryContentSliverSection extends StatelessWidget {
  const SubscriptionSummaryContentSliverSection({
    super.key,
    required this.summaryArgs,
    required this.initialStartDate,
  });

  final SubscriptionSummaryArgs summaryArgs;
  final String initialStartDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionSummaryViewModel, SubscriptionSummaryState>(
      builder: (context, state) {
        final summary = state.summary;
        final hasSummary = summary != null;
        final currentStartDate = summary?.startDate.trim().isNotEmpty == true
            ? summary!.startDate.trim()
            : (state.selectedStartDate.trim().isNotEmpty
                ? state.selectedStartDate.trim()
                : initialStartDate);

        final activeRequest = summaryArgs.request.copyWith(
          startDate: currentStartDate,
        );

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
            ).copyWith(
              top: Spacing.md,
              bottom:
                  Spacing.monthlyPlanSubscribeHeight + Spacing.xxxl,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: state.isLoading || !hasSummary
                    ? (state.failure != null && !hasSummary
                        ? ApiErrorWidget(
                            key: const ValueKey('summary-error'),
                            exception: state.failure!.exception,
                            onRetry: () => context
                                .read<SubscriptionSummaryViewModel>()
                                .doIntent(
                                  GetSubscriptionSummaryEvent(activeRequest),
                                ),
                          )
                        : const SubscriptionSummaryDetailsLoadingSkeleton(
                            key: ValueKey('summary-skeleton'),
                          ))
                    : SubscriptionSummaryDetailsCard(
                        key: const ValueKey('summary-details-card'),
                        summary: summary,
                        selectedStartDate: currentStartDate,
                        onEditStartDate: () => _openDatePicker(
                          context: context,
                          currentStartDate: currentStartDate,
                          summaryArgs: summaryArgs,
                          earliestStartDate:
                              state.earliestStartDate.isNotEmpty
                              ? state.earliestStartDate
                              : summary.startDate,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> _openDatePicker({
    required BuildContext context,
    required String currentStartDate,
    required SubscriptionSummaryArgs summaryArgs,
    String? earliestStartDate,
  }) async {
    final formattedDate = await AppDatePicker.showFormatted(
      context: context,
      initialDateString: currentStartDate,
      earliestDateString: earliestStartDate,
    );

    if (formattedDate == null || !context.mounted) {
      return;
    }

    if (formattedDate == currentStartDate) {
      return;
    }

    context.read<SubscriptionSummaryViewModel>().doIntent(
      ChangeSubscriptionStartDateEvent(
        startDate: formattedDate,
        baseRequest: summaryArgs.request,
      ),
    );
  }
}
