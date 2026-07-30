import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_details_info_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_details_monthly_strip.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/section_header_button_sheet.dart';

class OfferDetailsSheetContent extends StatelessWidget {
  const OfferDetailsSheetContent({
    super.key,
    required this.offer,
    this.onClose,
    this.onPrimaryPressed,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 6, 20, 20),
    this.showCloseButton = true,
    this.showActionButton = true,
  });

  final OfferDealEntity offer;
  final VoidCallback? onClose;
  final VoidCallback? onPrimaryPressed;
  final EdgeInsetsGeometry padding;
  final bool showCloseButton;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    final isMonthlyOffer = offer.couponCode == 'SAVE20';

    final expiryText = offer.expiryText ?? '02 يوم : 14 ساعة';
    final couponCode = offer.couponCode ?? 'SAVE20';
    final summaryText = isMonthlyOffer
        ? 'خصم ${offer.discountLabel.isNotEmpty ? offer.discountLabel : '20%'} على جميع الباقات الشهرية'
        : offer.conditionsText ?? offer.detailSubtitle ?? 'تفاصيل العرض';
    final termsText =
        offer.conditionsText ??
        (isMonthlyOffer
            ? 'يسري العرض على الباقات الشهرية فقط. لا يمكن دمجه مع عروض أخرى.'
            : 'تطبق الشروط والأحكام حسب العرض المحدد.');

    return Material(
      color: AppColors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeaderButtonSheet(
                offer: offer,
                onClose: showCloseButton ? onClose : null,
              ),
              if (isMonthlyOffer) ...[
                const SizedBox(height: 12),
                const OfferDetailsMonthlyStrip(),
              ],
              const SizedBox(height: 16),
              OfferDetailsInfoCard(
                summaryText: summaryText,
                durationText: expiryText,
                couponCode: couponCode,
                termsText: termsText,
                accentColor: offer.accentColor,
                onCopyCode: () async {
                  await Clipboard.setData(ClipboardData(text: couponCode));
                },
              ),
              if (showActionButton) ...[
                const SizedBox(height: 18),
                AppButton(
                  text: 'استفد الآن',
                  onPressed: onPrimaryPressed,
                  height: 48,
                  // borderRadius: 12,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
