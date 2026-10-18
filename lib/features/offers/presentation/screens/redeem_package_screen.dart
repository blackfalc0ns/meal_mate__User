import 'dart:async';

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

class RedeemPackageScreen extends StatelessWidget {
  const RedeemPackageScreen({super.key, required this.offer});

  final OfferEntity offer;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

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
                            Expanded(
                              child: Text(
                                offer.promoCode!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size14,
                                  color: color.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            InkWell(
                              onTap: () => _copyCode(context),
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
                    // Instructions Card
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
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
                                Icons.info_outline_rounded,
                                color: color.primary,
                                size: 20,
                              ),
                              const SizedBox(width: Spacing.sm),
                              Text(
                                locale.offer_details_title,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size14,
                                  color: color.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            locale.offer_details_info_terms_description,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (offer.terms(lang) != null &&
                        offer.terms(lang)!.isNotEmpty) ...[
                      const SizedBox(height: Spacing.md),
                      Container(
                        padding: const EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          color: color.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(Spacing.md),
                          border: Border.all(color: color.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.offer_details_info_terms_label,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(
                              offer.terms(lang)!,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
              child: AppButton(
                text: _buttonTitle(locale),
                onPressed: () => _navigateToSubscriptionCatalog(context),
                height: Spacing.buttonHeight,
                borderRadius: Spacing.radiusMd,
                gradient: LinearGradient(
                  colors: [color.primary, color.tertiary],
                ),
                textColor: color.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buttonTitle(dynamic locale) {
    if (offer.bundleIds.isNotEmpty && offer.programIds.isEmpty) {
      return locale.family_packages_header_title;
    }
    if (offer.programIds.isNotEmpty && offer.bundleIds.isEmpty) {
      return locale.offer_details_open_plans_button;
    }
    return locale.subscription_type_title;
  }

  void _copyCode(BuildContext context) {
    if (offer.promoCode == null || offer.promoCode!.isEmpty) return;
    unawaited(Clipboard.setData(ClipboardData(text: offer.promoCode!)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.localization.offer_details_copy_code),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToSubscriptionCatalog(BuildContext context) {
    _copyCode(context);
    if (offer.bundleIds.isNotEmpty && offer.programIds.isEmpty) {
      unawaited(
        Navigator.of(context).pushNamed(AppRoutes.familyPackageSelection),
      );
      return;
    }
    if (offer.programIds.isNotEmpty && offer.bundleIds.isEmpty) {
      unawaited(
        Navigator.of(context).pushNamed(AppRoutes.subscriptionProgramSelection),
      );
      return;
    }
    unawaited(Navigator.of(context).pushNamed(AppRoutes.subscriptions));
  }
}
