import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/compensation_entity.dart';
import '../manager/compensations_view_model.dart';
import '../manager/compensations_state.dart';
import 'compensation_choice_actions.dart';

class CompensationCard extends StatelessWidget {
  const CompensationCard({super.key, required this.item});
  final CompensationEntity item;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final date = DateTime.tryParse(item.failedServiceDate);
    final dateLabel = date == null
        ? item.failedServiceDate
        : DateFormat.yMMMd(locale.localeName).format(date);
    final money = NumberFormat.currency(
      locale: locale.localeName,
      symbol: item.currency,
      decimalDigits: 3,
    );
    final status = switch (item.status) {
      'PendingChoice' => locale.compensations_pending,
      'AutoRefundInitiated' => locale.compensations_auto_refund,
      'Settled' => locale.compensations_settled,
      'AlternativeDayChosen' => locale.compensations_alternative_chosen,
      _ => locale.compensations_other_status,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.compensations_failed_date(dateLabel),
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              status,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                color: color.primary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            if (item.totalAmount case final amount?)
              Text(
                locale.compensations_total(money.format(amount)),
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurface,
                ),
              )
            else
              Text(
                locale.compensations_unavailable_amount,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurfaceVariant,
                ),
              ),
            if (item.cardRefundAmount case final amount?)
              Text(
                locale.compensations_card_amount(money.format(amount)),
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurfaceVariant,
                ),
              ),
            if (item.walletRefundAmount case final amount?)
              Text(
                locale.compensations_wallet_amount(money.format(amount)),
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurfaceVariant,
                ),
              ),
            if (item.apologyCreditAmount case final amount? when amount > 0)
              Text(
                locale.compensations_apology_amount(money.format(amount)),
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurfaceVariant,
                ),
              ),
            if (DateTime.tryParse(item.selectedAlternativeDate ?? '')
                case final selected?) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                locale.compensations_selected_date(
                  DateFormat.yMMMd(locale.localeName).format(selected),
                ),
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurface,
                ),
              ),
            ],
            BlocSelector<CompensationsViewModel, CompensationsState, Failure?>(
              selector: (state) => state.actionFailures[item.id],
              builder: (context, failure) => failure == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: Spacing.sm),
                      child: InlineApiErrorWidget(failure: failure),
                    ),
            ),
            if (item.isPendingChoice) ...[
              const SizedBox(height: Spacing.base),
              CompensationChoiceActions(item: item),
            ],
          ],
        ),
      ),
    );
  }
}
