import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_button_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_loading_skeleton.dart';

class SubscriptionSummaryScreen extends StatefulWidget {
  const SubscriptionSummaryScreen({super.key, required this.args});

  final SubscriptionSummaryArgs? args;

  @override
  State<SubscriptionSummaryScreen> createState() =>
      _SubscriptionSummaryScreenState();
}

class _SubscriptionSummaryScreenState extends State<SubscriptionSummaryScreen> {
  late String _selectedStartDate;

  @override
  void initState() {
    super.initState();
    _selectedStartDate =
        widget.args?.request.startDate.trim().isNotEmpty == true
        ? widget.args!.request.startDate
        : _formatApiDate(_kuwaitToday);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final summaryArgs = widget.args;

    if (summaryArgs == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.subscription_summary_title,
          description: locale.subscription_program_subtitle,
          icon: Icons.receipt_long_rounded,
        ),
      );
    }

    return BlocProvider<SubscriptionSummaryViewModel>(
      create: (_) =>
          getIt<SubscriptionSummaryViewModel>()
            ..doIntent(GetSubscriptionSummaryEvent(_summaryRequest)),
      child: BlocBuilder<SubscriptionSummaryViewModel, SubscriptionSummaryState>(
        builder: (context, state) {
          final summary = state.summary;
          final plan = summary == null
              ? summaryArgs.initialPlan
              : summary.toPlanDetails(
                  localeName: locale.localeName,
                  dayLabel: locale.subscription_day,
                  primaryColor: color.primary,
                  initialPlan: summaryArgs.initialPlan,
                );
          final hasSummary = summary != null;

          return Scaffold(
            body: Semantics(
              label: locale.subscription_summary_title,
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            children: [
                              MonthlyPlanHeroSection(
                                plan: plan,
                                imageAsset: plan.heroImageAsset.isNotEmpty
                                    ? plan.heroImageAsset
                                    : Assets.monthlyPlanHero,
                                imageUrl:
                                    summary?.imageUrl ??
                                    summary?.programImageUrl,
                                onBack: () => Navigator.maybePop(context),
                              ),
                              const SizedBox(height: Spacing.md),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                ),
                                child: state.isLoading && !hasSummary
                                    ? const SubscriptionSummaryDetailsLoadingSkeleton()
                                    : state.failure != null && !hasSummary
                                    ? ApiErrorWidget(
                                        exception: state.failure!.exception,
                                        onRetry: () => context
                                            .read<
                                              SubscriptionSummaryViewModel
                                            >()
                                            .doIntent(
                                              GetSubscriptionSummaryEvent(
                                                _summaryRequest,
                                              ),
                                            ),
                                      )
                                    : SubscriptionSummaryDetailsCard(
                                        plan: plan,
                                        summary: summary,
                                        selectedStartDate: _selectedStartDate,
                                        onEditStartDate: () =>
                                            _openDatePicker(context),
                                      ),
                              ),
                              const SizedBox(
                                height:
                                    Spacing.monthlyPlanSubscribeHeight +
                                    Spacing.xxxl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  PositionedDirectional(
                    start: Spacing.monthlyPlanContentHorizontalPadding,
                    end: Spacing.monthlyPlanContentHorizontalPadding,
                    bottom: Spacing.monthlyPlanContentHorizontalPadding,
                    child: state.isLoading && !hasSummary
                        ? const SubscriptionSummaryButtonLoadingSkeleton()
                        : AppSubscriptionButton(
                            price: hasSummary ? plan.price : '',
                            currency: hasSummary ? plan.currency : '',
                            onPressed: hasSummary && summary.canCheckout
                                ? () => context.pushNamed(
                                    AppRoutes.payment,
                                    arguments: PaymentArgs(
                                      summary: summary,
                                      summaryRequest: _summaryRequest,
                                      restaurantId:
                                          summary.firstRestaurantId ??
                                          summaryArgs.restaurantId,
                                    ),
                                  )
                                : null,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SubscriptionSummaryRequestEntity get _summaryRequest =>
      widget.args!.request.copyWith(startDate: _selectedStartDate);

  DateTime get _kuwaitToday {
    final kuwaitNow = DateTime.now().toUtc().add(const Duration(hours: 3));
    return DateUtils.dateOnly(
      DateTime(kuwaitNow.year, kuwaitNow.month, kuwaitNow.day),
    );
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final locale = context.localization;
    final currentDate = _parseApiDate(_selectedStartDate) ?? _kuwaitToday;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isBefore(_kuwaitToday)
          ? _kuwaitToday
          : currentDate,
      firstDate: _kuwaitToday,
      lastDate: DateTime(2100, 12, 31),
      locale: Locale(locale.localeName),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    final formattedDate = _formatApiDate(pickedDate);
    if (formattedDate == _selectedStartDate) {
      return;
    }

    setState(() {
      _selectedStartDate = formattedDate;
    });
    if (!context.mounted) {
      return;
    }
    context.read<SubscriptionSummaryViewModel>().doIntent(
      GetSubscriptionSummaryEvent(_summaryRequest),
    );
  }

  DateTime? _parseApiDate(String value) {
    try {
      return DateUtils.dateOnly(DateTime.parse(value));
    } on FormatException {
      return null;
    }
  }

  String _formatApiDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(DateUtils.dateOnly(date));
  }
}
