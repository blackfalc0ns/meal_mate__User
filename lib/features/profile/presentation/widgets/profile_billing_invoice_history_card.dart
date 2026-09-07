import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_empty_invoices_card.dart';

class ProfileBillingInvoiceHistoryCard extends StatelessWidget {
  const ProfileBillingInvoiceHistoryCard({required this.invoices, super.key});

  final List<ProfileBillingInvoiceEntity> invoices;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final visibleInvoices = invoices.take(3).toList();
    final dateFormatter = DateFormat.yMMMd(locale.localeName);
    final isEmpty = invoices.isEmpty;

    return Container(
      height: isEmpty ? null : Spacing.profileBillingInvoicesHeight,
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.profileBillingCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: .07),
            blurRadius: Spacing.xss,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.xs),
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusXs),
                ),
                child: SvgPicture.asset(
                  Assets.profileBillingReceipt,
                  width: Spacing.iconSm,
                  height: Spacing.iconSm,
                ),
              ),
              const SizedBox(width: Spacing.xs),

              Text(
                locale.billing_invoices,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          if (isEmpty) ...[
            const ProfileBillingEmptyInvoicesCard(),
          ] else ...[
            const SizedBox(height: Spacing.xs),
            Expanded(
              child: Column(
                children: List.generate(visibleInvoices.length, (index) {
                final invoice = visibleInvoices[index];
                final issuedAt = DateTime.tryParse(invoice.issuedAtUtc);
                final dateText = issuedAt == null
                    ? invoice.issuedAtUtc
                    : dateFormatter.format(issuedAt.toLocal());
                final statusText = invoice.statusNameAr.isEmpty
                    ? locale.billing_paid
                    : invoice.statusNameAr;
                final amountText =
                    '${invoice.amount.toStringAsFixed(2)} ${invoice.currencyCode}';

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            amountText,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                              vertical: Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: color.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusXs,
                              ),
                            ),
                            child: Text(
                              statusText,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            invoice.displayNumber,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dateText,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: Spacing.iconSm,
                            color: color.onSurfaceVariant,
                          ),
                        ],
                      ),
                      if (index != visibleInvoices.length - 1)
                        Divider(color: color.outlineVariant),
                    ],
                  ),
                );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
