import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileBillingInvoiceHistoryCard extends StatelessWidget {
  const ProfileBillingInvoiceHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.profileBillingInvoicesHeight,
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
          const SizedBox(height: Spacing.xs),
          Expanded(
            child: Column(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Text(
                            '\$49.99',
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
                              locale.billing_paid,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '2025-000123',
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            locale.billing_invoice_date,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Icon(
                            Icons.chevron_left_rounded,
                            size: Spacing.iconSm,
                            color: color.onSurfaceVariant,
                          ),
                        ],
                      ),
                      if (index != 2) Divider(color: color.outlineVariant),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
