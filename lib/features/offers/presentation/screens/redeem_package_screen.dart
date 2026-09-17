import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_countdown_timer_widget.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/package_tier_radio_card.dart';
import 'package:meal_meat_user/features/payment/domain/entities/offer_checkout_args.dart';

class RedeemPackageScreen extends StatefulWidget {
  const RedeemPackageScreen({super.key, required this.offer});

  final OfferEntity offer;

  @override
  State<RedeemPackageScreen> createState() => _RedeemPackageScreenState();
}

class _RedeemPackageScreenState extends State<RedeemPackageScreen> {
  int _selectedDurationDays = 26;

  @override
  void initState() {
    super.initState();
    // Default to minSubscriptionDays if specified, else 26
    if (widget.offer.minSubscriptionDays != null &&
        widget.offer.minSubscriptionDays! > 0) {
      _selectedDurationDays = widget.offer.minSubscriptionDays!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;
    final offer = widget.offer;

    final packages = [
      _PackageConfig(
        durationDays: 26,
        title: locale.offer_package_month_title,
        basePrice: 52.000,
        mealsPerDay: 4,
      ),
      _PackageConfig(
        durationDays: 13,
        title: locale.offer_package_half_month_title,
        basePrice: 26.000,
        mealsPerDay: 4,
      ),
      _PackageConfig(
        durationDays: 6,
        title: locale.offer_package_week_title,
        basePrice: 14.500,
        mealsPerDay: 4,
      ),
    ];

    final selectedConfig = packages.firstWhere(
      (p) => p.durationDays == _selectedDurationDays,
      orElse: () => packages.first,
    );

    final discountValue = _calculateDiscount(
      selectedConfig.basePrice,
      selectedConfig.durationDays,
    );
    final finalPrice = (selectedConfig.basePrice - discountValue).clamp(
      0.0,
      double.infinity,
    );

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.offer_redeem_title,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mini Hero Card
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(Spacing.md),
                        border: Border.all(
                          color: color.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  offer.title(lang),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size15,
                                    color: color.onSurface,
                                  ),
                                ),
                              ),
                              if (offer.formattedDiscount().isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.xs,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    offer.formattedDiscount(),
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size12,
                                      color: color.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            offer.description(lang),
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          if (offer.endsAt != null) ...[
                            const SizedBox(height: Spacing.sm),
                            OfferCountdownTimerWidget(endsAt: offer.endsAt!),
                          ],
                        ],
                      ),
                    ),

                    if (offer.promoCode != null &&
                        offer.promoCode!.isNotEmpty) ...[
                      const SizedBox(height: Spacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: color.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(Spacing.sm),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${locale.offer_details_code_label}: ',
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              offer.promoCode!,
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
                                  ClipboardData(text: offer.promoCode!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      locale.offer_details_copy_code,
                                    ),
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

                    const SizedBox(height: Spacing.lg),
                    Text(
                      locale.offer_redeem_select_package_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size15,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),

                    // Package Tier Selection Cards
                    ...packages.map((pkg) {
                      final isEligible = _checkEligibility(pkg.durationDays);
                      final discount = _calculateDiscount(
                        pkg.basePrice,
                        pkg.durationDays,
                      );
                      final discPrice = isEligible
                          ? (pkg.basePrice - discount).clamp(
                              0.0,
                              double.infinity,
                            )
                          : pkg.basePrice;
                      final percent = (isEligible && pkg.basePrice > 0)
                          ? ((discount / pkg.basePrice) * 100).round()
                          : 0;

                      return PackageTierRadioCard(
                        title: pkg.title,
                        originalPrice: pkg.basePrice,
                        discountedPrice: discPrice,
                        discountPercent: percent,
                        isSelected: _selectedDurationDays == pkg.durationDays,
                        isEligible: isEligible,
                        ineligibilityReason: !isEligible
                            ? locale.offer_redeem_min_days_notice(
                                offer.minSubscriptionDays.toString(),
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedDurationDays = pkg.durationDays;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: color.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.offer_redeem_total_after_discount,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${finalPrice.toStringAsFixed(3)} ${locale.currency_kwd}',
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size18,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    text: locale.offer_redeem_proceed_button,
                    onPressed: () => _proceedToCheckout(
                      context,
                      selectedConfig,
                      discountValue,
                      finalPrice,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 14, color: color.outline),
                      const SizedBox(width: 4),
                      Text(
                        locale.offer_redeem_safe_payment_notice,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkEligibility(int durationDays) {
    if (widget.offer.minSubscriptionDays != null) {
      return durationDays >= widget.offer.minSubscriptionDays!;
    }
    return true;
  }

  double _calculateDiscount(double basePrice, int durationDays) {
    if (!_checkEligibility(durationDays)) return 0.0;

    if (widget.offer.discountRate != null && widget.offer.discountRate! > 0) {
      return basePrice * widget.offer.discountRate!;
    }
    if (widget.offer.discountAmount != null &&
        widget.offer.discountAmount! > 0) {
      return widget.offer.discountAmount!;
    }
    return 0.0;
  }

  void _proceedToCheckout(
    BuildContext context,
    _PackageConfig config,
    double discountAmount,
    double finalPrice,
  ) {
    final checkoutArgs = OfferCheckoutArgs(
      offer: widget.offer,
      durationDays: config.durationDays,
      packageName: config.title,
      mealsPerDay: config.mealsPerDay,
      originalPriceKwd: config.basePrice,
      discountAmountKwd: discountAmount,
      finalPriceKwd: finalPrice,
      programId: widget.offer.programIds.isNotEmpty
          ? widget.offer.programIds.first
          : null,
      bundleId: widget.offer.bundleIds.isNotEmpty
          ? widget.offer.bundleIds.first
          : null,
    );

    Navigator.of(
      context,
    ).pushNamed(AppRoutes.promoCheckout, arguments: checkoutArgs);
  }
}

class _PackageConfig {
  const _PackageConfig({
    required this.durationDays,
    required this.title,
    required this.basePrice,
    required this.mealsPerDay,
  });

  final int durationDays;
  final String title;
  final double basePrice;
  final int mealsPerDay;
}
