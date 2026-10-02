import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_coverage_error_banner.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_dates_row.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_delivery_address_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_participating_restaurants_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_plan_summary_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_restaurant_repetition_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_total_price_card.dart';

class SubscriptionSummaryDetailsCard extends StatelessWidget {
  const SubscriptionSummaryDetailsCard({
    super.key,
    required this.summary,
    required this.selectedStartDate,
    required this.onEditStartDate,
  });

  final SubscriptionSummaryEntity summary;
  final String selectedStartDate;
  final VoidCallback onEditStartDate;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    final repetitionLimit = summary.restaurantRepetition?.limit ?? 0;
    final hasAddress = summary.address != null;
    final noRestaurantsError =
        !summary.canCheckout &&
        (summary.checkoutBlockReason ==
                SubscriptionErrorCodes.noRestaurantsForAddress ||
            summary.checkoutBlockReason ==
                SubscriptionErrorCodes.checkoutNoRestaurantsForAddress);

    final paymentDateFormatted = _formatDisplayDate(
      dateString: summary.chosenStartDate,
      localeName: locale.localeName,
    );

    final startDateFormatted = _formatDisplayDate(
      dateString: summary.startDate.trim().isNotEmpty
          ? summary.startDate
          : selectedStartDate,
      localeName: locale.localeName,
    );

    final endDateFormatted = _formatDisplayDate(
      dateString: summary.endDate,
      localeName: locale.localeName,
    );

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final slideBegin = isRtl ? 0.12 : -0.12;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: Spacing.subscriptionSummaryDetailsWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubscriptionPlanSummaryCard(summary: summary)
              .animate()
              .fadeIn(duration: 350.ms, curve: Curves.easeOut)
              .slideX(
                begin: slideBegin,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: Spacing.md),
          SubscriptionParticipatingRestaurantsCard(
            restaurants: summary.restaurants,
            totalCount: summary.restaurantCount,
          )
              .animate()
              .fadeIn(delay: 70.ms, duration: 350.ms, curve: Curves.easeOut)
              .slideX(
                begin: slideBegin,
                end: 0,
                delay: 70.ms,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              ),
          if (repetitionLimit > 0) ...[
            const SizedBox(height: Spacing.md),
            SubscriptionRestaurantRepetitionCard(limit: repetitionLimit)
                .animate()
                .fadeIn(delay: 120.ms, duration: 350.ms, curve: Curves.easeOut)
                .slideX(
                  begin: slideBegin,
                  end: 0,
                  delay: 120.ms,
                  duration: 350.ms,
                  curve: Curves.easeOutCubic,
                ),
          ],
          if (hasAddress) ...[
            const SizedBox(height: Spacing.md),
            SubscriptionDeliveryAddressCard(address: summary.address!)
                .animate()
                .fadeIn(delay: 160.ms, duration: 350.ms, curve: Curves.easeOut)
                .slideX(
                  begin: slideBegin,
                  end: 0,
                  delay: 160.ms,
                  duration: 350.ms,
                  curve: Curves.easeOutCubic,
                ),
          ],
          if (noRestaurantsError) ...[
            const SizedBox(height: Spacing.md),
            SubscriptionCoverageErrorBanner(
              message: locale.subscription_summary_no_restaurants_for_address,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 350.ms, curve: Curves.easeOut)
                .slideX(
                  begin: slideBegin,
                  end: 0,
                  delay: 200.ms,
                  duration: 350.ms,
                  curve: Curves.easeOutCubic,
                ),
          ],
          const SizedBox(height: Spacing.md),
          SubscriptionTotalPriceCard(
            price: summary.finalPrice.formattedPrice,
            currency: summary.currencyCode,
          )
              .animate()
              .fadeIn(delay: 220.ms, duration: 350.ms, curve: Curves.easeOut)
              .slideX(
                begin: slideBegin,
                end: 0,
                delay: 220.ms,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: Spacing.md),
          SubscriptionDatesRow(
            paymentDate: paymentDateFormatted,
            startDate: startDateFormatted,
            endDate: endDateFormatted,
            onEditStartDate: onEditStartDate,
          )
              .animate()
              .fadeIn(delay: 280.ms, duration: 350.ms, curve: Curves.easeOut)
              .slideX(
                begin: slideBegin,
                end: 0,
                delay: 280.ms,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }

  String _formatDisplayDate({
    required String? dateString,
    required String localeName,
  }) {
    if (dateString == null || dateString.trim().isEmpty) {
      return '-';
    }
    final parsed = DateTime.tryParse(dateString.trim());
    if (parsed == null) {
      return dateString.trim();
    }
    return DateFormat('d MMMM yyyy', localeName).format(parsed);
  }
}
