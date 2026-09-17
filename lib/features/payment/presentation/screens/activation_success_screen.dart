import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/payment/domain/entities/activation_success_args.dart';

class ActivationSuccessScreen extends StatelessWidget {
  const ActivationSuccessScreen({super.key, required this.args});

  final ActivationSuccessArgs args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;
    final checkout = args.checkoutArgs;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: AppBar(
          backgroundColor: color.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            locale.offer_activation_success_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.close, color: color.onSurface),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Spacing.md),

                // ── Celebration Icon Header ──
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primary.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      Icons.celebration_rounded,
                      color: color.primary,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  locale.offer_activation_congrats,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size18,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  locale.offer_activation_subtitle,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // ── Activated Order Card ──
                Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(Spacing.md),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: color.primary,
                            size: 24,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            locale.offer_activation_order_title,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size15,
                              color: color.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      _buildRow(
                        context,
                        label: locale.offer_checkout_package_label,
                        value: checkout.packageName,
                      ),
                      const SizedBox(height: Spacing.sm),
                      _buildRow(
                        context,
                        label: locale.offer_checkout_original_price,
                        value:
                            '${checkout.originalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
                      ),
                      const SizedBox(height: Spacing.sm),
                      _buildRow(
                        context,
                        label: locale.offer_checkout_discount_amount,
                        value:
                            '-${checkout.discountAmountKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
                        valueColor: color.primary,
                        isBold: true,
                      ),
                      const Divider(height: Spacing.xl),
                      _buildRow(
                        context,
                        label: locale.offer_activation_paid_total,
                        value:
                            '${checkout.finalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
                        valueColor: color.primary,
                        fontSize: FontSize.size17,
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                if (checkout.offer.promoCode != null &&
                    checkout.offer.promoCode!.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Spacing.sm),
                      border: Border.all(
                        color: color.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.discount_outlined,
                          color: color.primary,
                          size: 20,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          '${locale.offer_details_code_label}: ',
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          checkout.offer.promoCode!,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.primary,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: checkout.offer.promoCode!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(locale.offer_details_copy_code),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(Spacing.xs),
                            child: Icon(
                              Icons.copy_rounded,
                              color: color.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (checkout.offer.terms(lang) != null &&
                    checkout.offer.terms(lang)!.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  Text(
                    checkout.offer.terms(lang)!,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.outline,
                    ),
                  ),
                ],

                const SizedBox(height: Spacing.xxl),

                // ── Primary Action: Navigate to Meal Calendar ──
                AppButton(
                  text: locale.offer_activation_choose_plan_button,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.calendar,
                      (route) => route.isFirst,
                      arguments: args.subscriptionId,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    double? fontSize,
    bool isBold = false,
  }) {
    final color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: fontSize ?? FontSize.size13,
            color: color.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: isBold
              ? getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: fontSize ?? FontSize.size13,
                  color: valueColor ?? color.onSurface,
                )
              : getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: fontSize ?? FontSize.size13,
                  color: valueColor ?? color.onSurface,
                ),
        ),
      ],
    );
  }
}
