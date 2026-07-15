import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_order_summary_card.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_activated_coupon_row.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_activated_hero_banner.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';

class OfferActivatedScreen extends StatelessWidget {
  const OfferActivatedScreen({super.key});

  static const routeName = '/offer-activated';

  static const _accentColor = AppColors.primary;
  static const _imageAsset = 'assets/images/offers/grilled_plate.png';
  static const _mealBoxAsset = AssetsFake.mealBoxes;
  static const _couponCode = 'SAVE20';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: l10n.offer_activated_title),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.base),
                    OfferActivatedHeroBanner(
                      imageAsset: _imageAsset,
                      discountLabel: '20%',
                      title: l10n.offers_hero_title,
                      subtitle: l10n.offer_details_hero_description,
                      timerText: '02 يوم : 14 ساعة',
                      accentColor: _accentColor,
                    ),
                    const SizedBox(height: Spacing.base),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: AppOrderSummaryCard(
                        planTitle: l10n.offer_details_plan_month_title,
                        planDuration: l10n.offer_details_plan_duration_month,
                        mealsPerDay: l10n.offer_details_plan_meals,
                        originalPrice: '52.000',
                        discountAmount: '10.400',
                        totalPrice: '41.600',
                        discountLabel: '20%',
                        imageAsset: _mealBoxAsset,
                      ),
                    ),
                    const SizedBox(height: Spacing.base),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: OfferActivatedCouponRow(
                        couponCode: _couponCode,
                        accentColor: _accentColor,
                        copyLabel: 'نسخ',
                        titleLabel: l10n.offer_details_info_coupon_label,
                        onCopy: () async {
                          await Clipboard.setData(
                            const ClipboardData(text: _couponCode),
                          );
                          if (context.mounted) {
                            CustomSnackbar.showSuccess(
                              context: context,
                              message: 'تم نسخ الرمز بنجاح',
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: Spacing.base),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.offer_details_info_title,
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          OfferDetailsInfoCard(
                            summaryText: l10n.offer_details_info_summary,
                            durationText:
                                '${l10n.offer_details_hero_timer_label} : 02 يوم : 14 ساعة',
                            couponCode: _couponCode,
                            termsText:
                                l10n.offer_details_info_terms_description,
                            accentColor: _accentColor,
                            showSummaryRow: true,
                            showCouponSection: false,
                            onCopyCode: () async {
                              await Clipboard.setData(
                                const ClipboardData(text: _couponCode),
                              );
                              if (context.mounted) {
                                CustomSnackbar.showSuccess(
                                  context: context,
                                  message: 'تم نسخ الرمز بنجاح',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xxl),
                  ],
                ),
              ),
            ),
            _BottomCta(
              label: l10n.offer_details_open_plans_button,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.payment),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: SafeArea(
        top: false,
        child: CustomAppButton(text: label, onPressed: onPressed, height: 40),
      ),
    );
  }
}
