import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_activated_coupon_row.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_activated_hero_banner.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_activated_order_summary_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';

/// Screen shown after the user successfully activates an offer.
class OfferActivatedScreen extends StatelessWidget {
  const OfferActivatedScreen({super.key});

  static const routeName = '/offer-activated';

  static const _accentColor = AppColors.primary;
  static const _imageAsset = 'assets/images/offers/grilled_plate.png';
  static const _mealBoxAsset = 'assets/images/offers/meal_boxes.png';
  static const _couponCode = 'SAVE20';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _OfferActivatedAppBar(
          title: 'تم تفعيل العرض بنجاح',
          onClose: () => Navigator.of(context).pop(),
          onForward: () {},
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.base),

                    // 1. Hero banner
                    OfferActivatedHeroBanner(
                      imageAsset: _imageAsset,
                      discountLabel: '20%',
                      title: l10n.offers_hero_title,
                      subtitle: l10n.offer_details_hero_description,
                      timerText: '02 يوم : 14 ساعة',
                      accentColor: _accentColor,
                    ),

                    const SizedBox(height: Spacing.base),

                    // 2. Order summary card
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: OfferActivatedOrderSummaryCard(
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

                    // 3. Coupon code row
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

                    // 4. Info card
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

            // Sticky bottom CTA
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

// ── App bar ──────────────────────────────────────────────────────

class _OfferActivatedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _OfferActivatedAppBar({
    required this.title,
    required this.onClose,
    required this.onForward,
  });

  final String title;
  final VoidCallback onClose;
  final VoidCallback onForward;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: onClose,
        icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
      ),
      title: Text(
        title,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size16,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onForward,
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ],
    );
  }
}

// ── Bottom CTA ───────────────────────────────────────────────────

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: SafeArea(
        top: false,
        child: CustomAppButton(
          text: label,
          onPressed: onPressed,
         height: 40,
         
        ),
      ),
    );
  }
}
